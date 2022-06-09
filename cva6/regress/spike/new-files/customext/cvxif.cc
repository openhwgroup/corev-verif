// See LICENSE for license details.
// Contributed by Zbigniew CHAMSKI <zbigniew.chamski@thalesgroup.com>

#include "cvxif.h"
#include "mmu.h"
#include <cstring>

// This class instantiates the CV-X-IF interface.
class cvxif_t : public cvxif_extn_t
{
 public:
  const char* name() { return "cvxif_spike"; }

  bool do_writeback_p(cvxif_insn_t copro_insn)
  {
    // INSN_R personality serves to simplify access to standard encoding fields.
    cvxif_r_insn_t insn_r = copro_insn.r_type;

    if (insn_r.opcode != MATCH_CUSTOM3)
      return false;
    else switch (insn_r.funct3)
    {
      case 0b000:
        // CUSTOM_NOP and CUSTOM_EXC have rd == x0.
        // Return TRUE if destination is NOT x0.
        return (insn_r.rd != 0x0);

      case 0b010:
        // Return false for CUS_SD.
        return false;

      default:
        // All other cases: writeback is assumed REQUIRED.
        return true;
    }
  }

  reg_t custom3(cvxif_insn_t incoming_insn)
  {
    // Assume R-type insn: it shares opcode and funct3 fields with other CVXIF insn formats.
    cvxif_r_insn_t r_insn = incoming_insn.r_type;
    // INSN_T simplifies access to register values.
    insn_t insn = incoming_insn.i;

    switch (r_insn.funct3)
    {
      case 0:

        // funct7[1:0] == 0b01: three-input RV add.
        // If rd is x0: illegal instruction.
        if ((r_insn.funct7 & 0x3) == 0b01)
        {
          if (insn.rd() == 0x0)
            illegal_instruction();

          // Destination is not x0: R4-type insn performing a 3-operand RV add
          return (reg_t) ((reg_t) RS1 + (reg_t) RS2 + (reg_t) RS3);
        }

        // Non-memory operations (including NOP and EXC)
        switch (r_insn.funct7 & 0b1111001)
        {
          case 0:
            {
              // Single-cycle RV addition with privilege: all non-privilege bits are zero.
              // funct7[2:1] == 0x0 (PRV_U): CUS_ADD (single-cycle RV ADD, any mode)
              // funct7[2:1] == 0x1 (PRV_S): CUS_S_ADD (single-cycle S-/M-mode RV ADD)
              // funct7[2:1] == 0x2 (PRV_HS): ILLEGAL
              // funct7[2:1] == 0x3 (PRV_M): CUS_M_ADD (single-cycle M-mode RV ADD)
              reg_t required_priv = (r_insn.funct7 & 0x6) >> 1;
              if (required_priv != PRV_HS && (p->get_state()->prv & required_priv) == required_priv)
                return (reg_t) ((reg_t) RS1 + (reg_t) RS2);
              else
                illegal_instruction();
            }

          case 0x8:
            // Multi-cycle RV add.
            // TODO FIXME: Represent delay.
            return (reg_t) ((reg_t) RS1 + (reg_t) RS2);

          case 0x40:
            // Exception. MCAUSE[4:0] encoded in RS1, MCAUSE[5] assumed to be 0.
            if (insn.rd() == 0x0 && insn.rs2() == 0x0)
            {
              // Raise an exception only if registers rd and rs2 are both x0 (no 'bit 5' extension yet).
              raise_exception(insn, insn.rs1());
              // Writeback will be disabled by 'do_writeback_p'.
              return (reg_t) -1;
            }
            else
              // Illegal instruction.
              illegal_instruction();

          default:
            illegal_instruction();
        }

      case 1:
        // Perform RV load.  If runtime XLEN is not 64, assume 32.
        if (p->get_xlen() == 64)
          return MMU.load_int64(RS1 + insn.i_imm());
        else
          return MMU.load_int32(RS1 + insn.i_imm());

      case 2:
        // Perform RV store.  If runtime XLEN is not 64, assume 32.
        if (p->get_xlen() == 64)
          MMU.store_uint64(RS1 + insn.s_imm(), RS2);
        else
          MMU.store_uint32(RS1 + insn.s_imm(), RS2);

        // Writeback will be disabled by 'do_writeback_p'.
        break;

      default:
        illegal_instruction();
    }

    // FORNOW: Return 0xf......f to simplify debugging.
    return (reg_t) -1;
  }

  cvxif_t()
  {
  }

  void raise_exception(insn_t insn, reg_t exc_index)
  {
    switch (exc_index) {
      case CAUSE_MISALIGNED_LOAD:
        // Use 0x1 as perfectly unaligned address;-)
        throw trap_load_address_misaligned((p ? p->get_state()->v : false), 1, 0, 0);
      case CAUSE_LOAD_ACCESS:
        // Use 0x1 as invalid address.
        throw trap_load_access_fault((p ? p->get_state()->v : false), 1, 0, 0);
      case CAUSE_MISALIGNED_STORE:
        // Use 0x1 as perfectly unaligned address;-)
        throw trap_store_address_misaligned((p ? p->get_state()->v : false), 1, 0, 0);
      case CAUSE_STORE_ACCESS:
        // Use 0x1 as invalid address.
        throw trap_store_access_fault((p ? p->get_state()->v : false), 1, 0, 0);
      case CAUSE_LOAD_PAGE_FAULT:
        // Use 0x1 as always-faulting address.
        throw trap_load_page_fault((p ? p->get_state()->v : false), 1, 0, 0);
      case CAUSE_STORE_PAGE_FAULT:
        // Use 0x1 as always-faulting address.
        throw trap_store_page_fault((p ? p->get_state()->v : false), 1, 0, 0);
      default:
        illegal_instruction();
    }
  }

private:
  // State variables go here.
};

REGISTER_EXTENSION(cvxif, []() { return new cvxif_t; })
