
// Copyright 2020 OpenHW Group
// Copyright 2020 Datum Technology Corporation
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//



// This file specifies all interfaces used by the CV32E40S test bench (uvmt_cv32e40s_tb).
// Most interfaces support tasks to allow control by the ENV or test cases.

`ifndef __UVMT_CV32E40S_TB_IFS_SV__
`define __UVMT_CV32E40S_TB_IFS_SV__


/**
 * clocks and reset
 */
interface uvmt_cv32e40s_clk_gen_if (output logic core_clock, output logic core_reset_n);

   import uvm_pkg::*;

   bit       start_clk               = 0;
   // TODO: get the uvme_cv32e40s_* values from random ENV CFG members.
   realtime  core_clock_period       = 1500ps; // uvme_cv32e40s_clk_period * 1ps;
   realtime  reset_deassert_duration = 7400ps; // uvme_cv32e40s_reset_deassert_duarion * 1ps;
   realtime  reset_assert_duration   = 7400ps; // uvme_cv32e40s_reset_assert_duarion * 1ps;

   /**
    * Generates clock and reset signals.
    * If reset_n comes up de-asserted (1'b1), wait a bit, then assert, then de-assert
    * Otherwise, leave reset asserted, wait a bit, then de-assert.
    */
   initial begin
      core_clock   = 0; // uvme_cv32e40s_clk_initial_value;
      core_reset_n = 0; // uvme_cv32e40s_reset_initial_value;
      wait (start_clk);
      fork
         forever begin
            #(core_clock_period/2) core_clock = ~core_clock;
         end
         begin
           if (core_reset_n == 1'b1) #(reset_deassert_duration);
           core_reset_n = 1'b0;
           #(reset_assert_duration);
           core_reset_n = 1'b1;
         end
      join_none
   end

   /**
    * Sets clock period in ps.
    */
   function void set_clk_period ( real clk_period );
      core_clock_period = clk_period * 1ps;
   endfunction : set_clk_period

   /** Triggers the generation of clk. */
   function void start();
      start_clk = 1;
      `uvm_info("CLK_GEN_IF", "uvmt_cv32e40s_clk_gen_if.start() called", UVM_NONE)
   endfunction : start

endinterface : uvmt_cv32e40s_clk_gen_if

/**
 * Status information generated by the Virtual Peripherals in the DUT WRAPPER memory.
 */
interface uvmt_cv32e40s_vp_status_if (
                                  output bit        tests_passed,
                                  output bit        tests_failed,
                                  output bit        exit_valid,
                                  output bit [31:0] exit_value
                                 );

  import uvm_pkg::*;

  // TODO: X/Z checks

endinterface : uvmt_cv32e40s_vp_status_if



/**
 * Core status signals.
 */
interface uvmt_cv32e40s_core_status_if (
                                    input  wire        core_busy,
                                    input  logic       sec_lvl
                                   );

  import uvm_pkg::*;

endinterface : uvmt_cv32e40s_core_status_if



// Interface to xsecure assertions and covergroups
interface uvmt_cv32e40s_xsecure_if
    import cv32e40s_pkg::*;
    import cv32e40s_rvfi_pkg::*;
    import uvmt_cv32e40s_pkg::*;
    #(
      parameter int     MTVT_ADDR_WIDTH = 5,
      parameter int     PMP_NUM_REGIONS = 2,
      parameter int     PMP_ADDR_WIDTH  = 6,
      parameter int     ALBUF_CNT_WIDTH = 3,
      parameter int     ALBUF_DEPTH = 3
    )

    (


   input dcsr_t core_i_cs_registers_i_dcsr_rdata,

   input logic [31:0] core_i_id_stage_i_operand_a,
   input logic [31:0] core_i_id_stage_i_operand_b,

   input logic core_i_id_stage_i_last_op,


   input mcause_t core_i_cs_registers_i_mcause_q,

   input logic core_i_wb_stage_i_ctrl_fsm_i_kill_if,
   input logic core_i_wb_stage_i_ctrl_fsm_i_kill_id,
   input logic core_i_wb_stage_i_ctrl_fsm_i_kill_ex,
   input logic core_i_wb_stage_i_ctrl_fsm_i_kill_wb,
   input logic [1:0] core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_n_flush_q,
   input [ALBUF_CNT_WIDTH-1:0] core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_rptr,

   input inst_resp_t [0:ALBUF_DEPTH-1] core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_resp_q,
   input [0:ALBUF_DEPTH-1] core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_valid_q,
   input logic [31:0] core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_instr_addr_o,
   input logic core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_unaligned_is_compressed,

   input [ALBUF_CNT_WIDTH-1:0] core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_wptr,

   input logic core_i_ex_wb_pipe_instr_bus_resp_integrity_err,

   input logic [31:0] core_i_ex_wb_pipe_instr_bus_resp_rdata,

   input logic core_i_cs_registers_i_xsecure_lfsr0_i_clock_en,
   input logic core_i_cs_registers_i_xsecure_lfsr1_i_clock_en,
   input logic core_i_cs_registers_i_xsecure_lfsr2_i_clock_en,

   input logic core_i_cs_registers_i_xsecure_lfsr0_i_seed_we_i,
   input logic core_i_cs_registers_i_xsecure_lfsr1_i_seed_we_i,
   input logic core_i_cs_registers_i_xsecure_lfsr2_i_seed_we_i,
   input logic [31:0] core_i_cs_registers_i_xsecure_lfsr0_i_lfsr_n,
   input logic [31:0] core_i_cs_registers_i_xsecure_lfsr1_i_lfsr_n,
   input logic [31:0] core_i_cs_registers_i_xsecure_lfsr2_i_lfsr_n,
   input logic [31:0] core_i_cs_registers_i_xsecure_lfsr0_i_seed_i,
   input logic [31:0] core_i_cs_registers_i_xsecure_lfsr1_i_seed_i,
   input logic [31:0] core_i_cs_registers_i_xsecure_lfsr2_i_seed_i,


   input logic [1:0] core_i_controller_i_controller_fsm_i_ctrl_fsm_cs,

    // CORE
   input logic core_i_sleep_unit_i_clock_en,

   input logic core_rf_we_wb,
   input logic [4:0] core_rf_waddr_wb,
   input logic [31:0] core_rf_wdata_wb,
   input logic [REGFILE_WORD_WIDTH-1:0] core_register_file_wrapper_register_file_mem [CORE_PARAM_REGFILE_NUM_WORDS],
   input logic [31:0] core_i_jump_target_id,


   input logic core_i_instr_req_o,
   input logic core_i_instr_gnt_i,
   input logic core_i_instr_rvalid_i,
   input logic core_i_instr_reqpar_o,
   input logic core_i_instr_gntpar_i,
   input logic core_i_instr_rvalidpar_i,
   input logic [11:0] core_i_instr_achk_o,
   input logic [4:0] core_i_instr_rchk_i,

   input logic core_i_data_req_o,
   input logic core_i_data_gnt_i,
   input logic core_i_data_rvalid_i,
   input logic core_i_data_reqpar_o,
   input logic core_i_data_gntpar_i,
   input logic core_i_data_rvalidpar_i,
   input logic [11:0] core_i_data_achk_o,
   input logic [4:0] core_i_data_rchk_i,

   input logic core_i_data_err_i,

   input obi_data_resp_t core_i_if_stage_i_bus_resp,
   input obi_data_resp_t core_i_load_store_unit_i_bus_resp,

   input obi_data_req_t core_i_m_c_obi_data_if_req_payload,
   input obi_data_resp_t core_i_m_c_obi_data_if_resp_payload,
   input obi_inst_req_t core_i_m_c_obi_instr_if_req_payload,
   input obi_inst_resp_t core_i_m_c_obi_instr_if_resp_payload,


   input logic core_i_m_c_obi_data_if_s_rvalid_rvalid,
   input logic core_i_m_c_obi_instr_if_s_rvalid_rvalid,
   input logic core_i_alert_i_itf_prot_err_i,


   input logic core_i_if_stage_i_prefetch_resp_valid,
   input logic core_i_load_store_unit_i_resp_valid,
   input logic core_i_load_store_unit_i_bus_resp_valid,

   input logic [1:0] core_i_load_store_unit_i_response_filter_i_core_cnt_q,

    // CSR
   input logic core_alert_minor_o,
   input logic core_alert_major_o,

   input logic core_xsecure_ctrl_cpuctrl_dataindtiming,
   input logic core_xsecure_ctrl_cpuctrl_rnddummy,
   input logic core_xsecure_ctrl_cpuctrl_integrity,
   input logic core_xsecure_ctrl_cpuctrl_pc_hardening,
   input logic core_xsecure_ctrl_cpuctrl_rndhint,

   input logic [3:0] core_xsecure_ctrl_cpuctrl_rnddummyfreq,
   input logic core_if_stage_gen_dummy_instr_dummy_instr_dummy_en,

   input logic [63:0] core_cs_registers_mhpmcounter_mcycle,
   input logic [63:0] core_cs_registers_mhpmcounter_minstret,
   input logic [31:3] [63:0] core_cs_registers_mhpmcounter_rdata_31_to_3,
   input logic [31:3] [31:0] core_cs_registers_mhpmevent_rdata_31_to_3,
   input logic [31:0] core_cs_registers_mcountinhibit_rdata,
   input logic core_cs_registers_mcountinhibit_rdata_mcycle,
   input logic core_cs_registers_mcountinhibit_rdata_minstret,
   input logic core_i_cs_registers_i_csr_en_gated,
   input logic [11:0] core_cs_registers_csr_waddr,


   input logic [31:0] core_xsecure_ctrl_lfsr0,
   input logic [31:0] core_xsecure_ctrl_lfsr1,
   input logic [31:0] core_xsecure_ctrl_lfsr2,

   input logic core_cs_registers_xsecure_lfsr0_seed_we,
   input logic core_cs_registers_xsecure_lfsr1_seed_we,
   input logic core_cs_registers_xsecure_lfsr2_seed_we,

   input logic [31:0] core_i_cs_registers_i_mepc_o,

    // Hardened CSR registers
   input logic [31:0] core_i_cs_registers_i_mstateen0_q,
   input logic [1:0] core_i_cs_registers_i_priv_lvl_q,

   input logic [31:0] core_i_cs_registers_i_jvt_q,
   input logic [31:0] core_i_cs_registers_i_mstatus_q,
   input logic [31:0] core_i_cs_registers_i_cpuctrl_q,
   input dcsr_t core_i_cs_registers_i_dcsr_q,
   input logic [31:0] core_i_cs_registers_i_mepc_q,
   input logic [31:0] core_i_cs_registers_i_mscratch_q,

   input mseccfg_t core_i_cs_registers_i_pmp_mseccfg_q,
   input pmpncfg_t core_i_cs_registers_i_pmpncfg_q[PMP_MAX_REGIONS],
   input logic [PMP_ADDR_WIDTH-1:0] core_i_cs_registers_i_pmp_addr_q[PMP_MAX_REGIONS],

   input mtvt_t core_i_cs_registers_i_mtvt_q,
   input mtvec_t core_i_cs_registers_i_mtvec_q,
   input mintstatus_t core_i_cs_registers_i_mintstatus_q,
   input logic [31:0] core_i_cs_registers_i_mintthresh_q,
   input logic [31:0] core_i_cs_registers_i_mie_q,

    // Shadow registers
   input logic [31:0] core_cs_registers_mstateen0_csr_gen_hardened_shadow_q,
   input logic [1:0] core_cs_registers_priv_lvl_gen_hardened_shadow_q,

   input logic [31:0] core_cs_registers_jvt_csr_gen_hardened_shadow_q,
   input logic [31:0] core_cs_registers_mstatus_csr_gen_hardened_shadow_q,
   input logic [31:0] core_cs_registers_xsecure_cpuctrl_csr_gen_hardened_shadow_q,
   input logic [31:0] core_cs_registers_dcsr_csr_gen_hardened_shadow_q,
   input logic [31:0] core_cs_registers_mepc_csr_gen_hardened_shadow_q,
   input logic [31:0] core_cs_registers_mscratch_csr_gen_hardened_shadow_q,

   input mseccfg_t uvmt_cv32e40s_tb_pmp_mseccfg_q_shadow_q,
   input pmpncfg_t uvmt_cv32e40s_tb_pmpncfg_q_shadow_q[PMP_MAX_REGIONS],
   input logic [PMP_ADDR_WIDTH-1:0] uvmt_cv32e40s_tb_pmp_addr_q_shadow_q[PMP_MAX_REGIONS],

   input mtvt_t uvmt_cv32e40s_tb_mtvt_q_shadow_q,
   input mtvec_t uvmt_cv32e40s_tb_mtvec_q_shadow_q,
   input mintstatus_t uvmt_cv32e40s_tb_mintstatus_q_shadow_q,
   input logic [31:0] uvmt_cv32e40s_tb_mintthresh_q_shadow_q,
   input logic [31:0] uvmt_cv32e40s_tb_mie_q_hardened_shadow_q,

    // Controller
   input logic core_i_controller_i_controller_fsm_i_dcsr_i_step,
   input logic core_i_controller_i_controller_fsm_i_dcsr_i_stepie,
   input logic core_controller_controller_fsm_debug_mode_q,
   input logic core_i_cs_registers_i_debug_stopcount,

    // IF stage
   input logic core_if_stage_if_valid_o,
   input logic core_if_stage_id_ready_i,


   input logic core_if_stage_instr_meta_n_dummy,
   input logic core_i_if_stage_i_instr_hint,
   input logic core_i_if_stage_i_dummy_insert,

   input logic [31:0] core_i_if_stage_i_pc_if_o,
   input logic core_i_if_stage_i_pc_check_i_pc_set_q,

   input logic core_i_if_stage_i_ptr_in_if_o,
   input logic core_i_if_stage_i_compressed_decoder_i_is_compressed_o,

    // IF ID pipe
   input inst_resp_t core_if_id_pipe_instr,
   input logic core_if_id_pipe_instr_meta_dummy,
   input logic core_if_id_pipe_instr_meta_hint,
   input logic [31:0] core_i_id_stage_i_if_id_pipe_i_pc,
   input logic core_i_if_id_pipe_last_op,

    // ID stage
   input logic core_id_stage_id_valid_o,
   input logic core_id_stage_ex_ready_i,

    // ID EX pipe

    //EX stage
   input logic [31:0] core_i_ex_stage_i_branch_target_o,
   input logic core_i_ex_stage_i_alu_i_cmp_result_o,

    // EX WB pipe
   input logic core_ex_wb_pipe_instr_meta_dummy,
   input logic core_ex_wb_pipe_instr_meta_hint,

    // WB stage
   input logic core_wb_stage_wb_valid_o,

    // CTRL
   input logic core_i_if_stage_i_prefetch_unit_i_alignment_buffer_i_ctrl_fsm_i_pc_set,
   input logic [3:0] core_i_if_stage_i_pc_check_i_ctrl_fsm_i_pc_mux,

   // Descriptive signal names:
   // IF ID pipe:
   input logic [4:0] if_id_pipe_rs1,
   input logic [4:0] if_id_pipe_rs2,
   input logic [4:0] if_id_pipe_rd,
   input logic [6:0] if_id_pipe_opcode,
   input logic [2:0] if_id_pipe_funct3,
   input logic [6:0] if_id_pipe_funct7,
   input logic [12:0] if_id_pipe_bltu_incrementation,

   // RVFI:
   input logic [2:0] rvfi_funct3,
   input logic [2:0] rvfi_cmpr_funct3,
   input logic [6:0] rvfi_funct7,
   input logic [6:0] rvfi_opcode,
   input logic [1:0] rvfi_cmpr_opcode,
   input logic [11:0] rvfi_csr,
   input logic [5:0] rvfi_c_slli_shamt

);

endinterface : uvmt_cv32e40s_xsecure_if


// Interface to debug assertions and covergroups
interface uvmt_cv32e40s_debug_cov_assert_if
    import cv32e40s_pkg::*;
    import cv32e40s_rvfi_pkg::*;
    (
    input  clk_i,
    input  rst_ni,

    // External interrupt interface
    input  [31:0] irq_i,
    input         irq_ack_o,
    input  [9:0]  irq_id_o,
    input  [31:0] mie_q,

    input         ex_stage_csr_en,
    input         ex_valid,
    input  [31:0] ex_stage_instr_rdata_i,
    input  [31:0] ex_stage_pc,

    input              wb_stage_instr_valid_i,
    input  [31:0]      wb_stage_instr_rdata_i,
    input  [31:0]      wb_stage_pc, // Program counter in writeback
    input              wb_illegal,
    input              wb_valid,
    input              wb_err,
    input mpu_status_e wb_mpu_status,

    input         id_valid,
    input wire ctrl_state_e  ctrl_fsm_cs,            // Controller FSM states with debug_req
    input         illegal_insn_i,
    input         sys_en_i,
    input         sys_ecall_insn_i,

    // Core signals
    input  [31:0] boot_addr_i,
    input         fetch_enable_i,

    // Debug signals
    input         debug_req_i, // From controller
    input         ctrl_fsm_async_debug_allowed,
    input         debug_havereset,
    input         debug_running,
    input         debug_halted,

    input         pending_sync_debug, // From controller
    input         pending_async_debug, // From controller
    input         pending_nmi, // From controller
    input         nmi_allowed, // From controller
    input         debug_mode_q, // From controller
    input  [31:0] dcsr_q, // From controller
    input  [31:0] dpc_q, // From cs regs
    input  [31:0] dpc_n,
    input  [31:0] dm_halt_addr_i,
    input  [31:0] dm_exception_addr_i,

    input  [31:0] mcause_q,
    input  [31:0] mtvec,
    input  [31:0] mepc_q,
    input  [31:0] tdata1,
    input  [31:0] tdata2,
    input  trigger_match_in_wb,
    input  etrigger_in_wb,

    // Counter related input from cs_registers
    input  [31:0] mcountinhibit_q,
    input  [63:0] mcycle,
    input  [63:0] minstret,
    input  inst_ret,

    // WFI Interface
    input  core_sleep_o,

    input  sys_fence_insn_i,

    input  csr_access,
    input  cv32e40s_pkg::csr_opcode_e csr_op,
    input  [11:0] csr_addr,
    input  csr_we_int,

    output logic is_wfi,
    output logic dpc_will_hit,
    output logic addr_match,
    output logic is_ebreak,
    output logic is_cebreak,
    output logic is_dret,
    output logic is_mulhsu,
    output logic [31:0] pending_enabled_irq,
    input  pc_set,
    input  branch_in_ex
);

  clocking mon_cb @(posedge clk_i);
    input #1step

    irq_i,
    irq_ack_o,
    irq_id_o,
    mie_q,

    wb_stage_instr_valid_i,
    wb_stage_instr_rdata_i,
    wb_valid,

    ctrl_fsm_cs,
    illegal_insn_i,
    sys_en_i,
    sys_ecall_insn_i,
    boot_addr_i,
    debug_req_i,
    debug_mode_q,
    dcsr_q,
    dpc_q,
    dpc_n,
    dm_halt_addr_i,
    dm_exception_addr_i,
    mcause_q,
    mtvec,
    mepc_q,
    tdata1,
    tdata2,
    pending_sync_debug,
    trigger_match_in_wb,
    etrigger_in_wb,
    sys_fence_insn_i,
    mcountinhibit_q,
    mcycle,
    minstret,
    inst_ret,

    core_sleep_o,
    csr_access,
    csr_op,
    csr_addr,
    is_wfi,
    dpc_will_hit,
    addr_match,
    is_ebreak,
    is_cebreak,
    is_dret,
    is_mulhsu,
    pending_enabled_irq,
    pc_set,
    branch_in_ex;
  endclocking : mon_cb

endinterface : uvmt_cv32e40s_debug_cov_assert_if

interface uvmt_cv32e40s_input_to_support_logic_module_if
   import cv32e40s_pkg::*;
   import cv32e40s_rvfi_pkg::*;
   (

   /* obi bus protocol signal information:
   ---------------------------------------
   - The obi protocol between alignmentbuffer (ab) and instructoin (i) interface (i) mpu (m) is refered to as abiim
   - The obi protocol between LSU (l) mpu (m) and LSU (l) is refered to as lml
   - The obi protocol between LSU (l) respons (r) filter (f) and OBI (o) data (d) interface (i) is refered to as lrfodi
   */

   input logic clk,
   input logic rst_n,

   //TODO: Copy pass - dont know what this does: Marton describes
   input ctrl_fsm_t ctrl_fsm_o,

   //Obi signals:

   //Data bus inputs
   input logic data_bus_rvalid,
   input logic data_bus_gnt,
   input logic data_bus_gntpar,
   input logic data_bus_req,

   //Instr bus inputs
   input logic instr_bus_rvalid,
   input logic instr_bus_gnt,
   input logic instr_bus_gntpar,
   input logic instr_bus_req,

   //Abiim bus inputs
   input logic abiim_bus_rvalid,
   input logic abiim_bus_gnt,
   input logic abiim_bus_req,

   //Lml bus inputs
   input logic lml_bus_rvalid,
   input logic lml_bus_gnt,
   input logic lml_bus_req,

   //Instr bus inputs
   input logic lrfodi_bus_rvalid,
   input logic lrfodi_bus_gnt,
   input logic lrfodi_bus_req,

   //Obi request information
   input logic req_is_store,
   input logic req_instr_integrity,
   input logic req_data_integrity

   );

   modport driver_mp (
     input  clk,
      rst_n,

      ctrl_fsm_o,

      data_bus_rvalid,
      data_bus_gnt,
      data_bus_gntpar,
      data_bus_req,

      instr_bus_rvalid,
      instr_bus_gnt,
      instr_bus_gntpar,
      instr_bus_req,

      abiim_bus_rvalid,
      abiim_bus_gnt,
      abiim_bus_req,

      lml_bus_rvalid,
      lml_bus_gnt,
      lml_bus_req,

      lrfodi_bus_rvalid,
      lrfodi_bus_gnt,
      lrfodi_bus_req,

      req_is_store,
      req_instr_integrity,
      req_data_integrity
   );

endinterface : uvmt_cv32e40s_input_to_support_logic_module_if


interface uvmt_cv32e40s_support_logic_for_assert_coverage_modules_if;
   import cv32e40s_pkg::*;
   import cv32e40s_rvfi_pkg::*;

   //TODO: Copy pass - dont know what this does: Marton describes
   logic req_after_exception;

   // support logic signals for the obi bus protocol:

   // continued address and respons phase indicators, indicates address and respons phases
   // of more than one cycle
   logic data_bus_addr_ph_cont;
   logic data_bus_resp_ph_cont;

   logic instr_bus_addr_ph_cont;
   logic instr_bus_resp_ph_cont;

   logic abiim_bus_addr_ph_cont;
   logic abiim_bus_resp_ph_cont;

   logic lml_bus_addr_ph_cont;
   logic lml_bus_resp_ph_cont;

   logic lrfodi_bus_addr_ph_cont;
   logic lrfodi_bus_resp_ph_cont;

   // address phase counter, used to verify no response phase preceedes an address phase
   integer data_bus_v_addr_ph_cnt;
   integer instr_bus_v_addr_ph_cnt;
   integer abiim_bus_v_addr_ph_cnt;
   integer lml_bus_v_addr_ph_cnt;
   integer lrfodi_bus_v_addr_ph_cnt;

   //Signals stating whether the request for the current response had the attribute value or not
   logic req_was_store;
   logic instr_req_had_integrity;
   logic data_req_had_integrity;
   logic gntpar_error_in_response_instr;
   logic gntpar_error_in_response_data;

   modport master_mp (
      output req_after_exception,
         data_bus_addr_ph_cont,
	      data_bus_resp_ph_cont,
	      data_bus_v_addr_ph_cnt,

         instr_bus_addr_ph_cont,
	      instr_bus_resp_ph_cont,
	      instr_bus_v_addr_ph_cnt,

         abiim_bus_addr_ph_cont,
	      abiim_bus_resp_ph_cont,
	      abiim_bus_v_addr_ph_cnt,

         lml_bus_addr_ph_cont,
	      lml_bus_resp_ph_cont,
	      lml_bus_v_addr_ph_cnt,

         lrfodi_bus_addr_ph_cont,
	      lrfodi_bus_resp_ph_cont,
	      lrfodi_bus_v_addr_ph_cnt,

         req_was_store,
         instr_req_had_integrity,
         data_req_had_integrity,
         gntpar_error_in_response_instr,
         gntpar_error_in_response_data
   );

   modport slave_mp (
      input req_after_exception,
         data_bus_addr_ph_cont,
	      data_bus_resp_ph_cont,
	      data_bus_v_addr_ph_cnt,

         instr_bus_addr_ph_cont,
	      instr_bus_resp_ph_cont,
	      instr_bus_v_addr_ph_cnt,

         abiim_bus_addr_ph_cont,
	      abiim_bus_resp_ph_cont,
	      abiim_bus_v_addr_ph_cnt,

         lml_bus_addr_ph_cont,
	      lml_bus_resp_ph_cont,
	      lml_bus_v_addr_ph_cnt,

         lrfodi_bus_addr_ph_cont,
	      lrfodi_bus_resp_ph_cont,
	      lrfodi_bus_v_addr_ph_cnt,

         req_was_store,
         instr_req_had_integrity,
         data_req_had_integrity,
         gntpar_error_in_response_instr,
         gntpar_error_in_response_data
   );

endinterface : uvmt_cv32e40s_support_logic_for_assert_coverage_modules_if



`endif // __UVMT_CV32E40S_TB_IFS_SV__
