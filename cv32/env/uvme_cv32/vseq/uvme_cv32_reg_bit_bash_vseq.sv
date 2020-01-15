// COPYRIGHT HEADER


`ifndef __UVME_CV32_REG_BIT_BASH_VSEQ_SV__
`define __UVME_CV32_REG_BIT_BASH_VSEQ_SV__


/**
 * Virtual sequence that checks that  writable registers specified in the RAL
 * (uvme_cv32_ral_c) are writable in the DUT as well.
 */
class uvme_cv32_reg_bit_bash_vseq_c extends uvme_cv32_reg_base_vseq_c;
   
   `include "uvme_cv32_reg_ignore_bit_bash_list.sv"
   
   // Sub-sequences
   rand uvm_reg_bit_bash_seq  single_block_bit_bash_seq;
   rand uvm_reg_bit_bash_seq  all_blocks_bit_bash_seq[];
   
   
   `uvm_object_utils_begin(uvme_cv32_reg_bit_bash_vseq_c)
      `uvm_field_object      (UVM_DEFAULT, single_block_bit_bash_seq)
      `uvm_field_array_object(UVM_DEFAULT, all_blocks_bit_bash_seq  )
   `uvm_object_utils_end
   
   
   constraint limits_cons {
      // TODO Constrain size of all_blocks_bit_bash_seq
      //      Ex: all_blocks_bit_bash_seq.size() == UVME_CV32_MAX_NUM_CHANNELS;
   }
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvme_cv32_reg_bit_bash_vseq");
   
   /**
    * TODO Describe uvme_cv32_reg_bit_bash_vseq_c::run_single_block()
    */
   extern virtual task run_single_block();
   
   /**
    * TODO Describe uvme_cv32_reg_bit_bash_vseq_c::run_all_blocks()
    */
   extern virtual task run_all_blocks();
   
endclass : uvme_cv32_reg_bit_bash_vseq_c


`pragma protect begin


function uvme_cv32_reg_bit_bash_vseq_c::new(string name="uvme_cv32_reg_bit_bash_vseq");
   
   super.new(name);
   
   single_block_bit_bash_seq = uvm_reg_bit_bash_seq::type_id::create("single_block_bit_bash_seq");
   
   // TODO Initialize all_blocks_bit_bash_seq array
   //      Ex: all_blocks_bit_bash_seq = new[UVME_CV32_MAX_NUM_CHANNELS];
   foreach (all_blocks_bit_bash_seq[ii]) begin
     all_blocks_bit_bash_seq[ii] = uvm_reg_bit_bash_seq::type_id::create($sformatf("all_blocks_bit_bash_seq[%0d]", ii));
   end
   
endfunction : new


task uvme_cv32_reg_base_vseq_c::run_single_block();
   
   // TODO Implement uvme_cv32_reg_base_vseq_c::run_single_block()
   //      Ex: single_block_bit_bash_seq.model = single_block;
   //          `uvm_send(single_block_bit_bash_seq)
   
endtask : run_single_block


task uvme_cv32_reg_base_vseq_c::run_all_blocks();
   
   // TODO Implement uvme_cv32_reg_base_vseq_c::run_all_blocks()
   //      Ex: fork
   //             begin
   //                foreach (cfg.ral.channels[_ii]) begin
   //                   fork
   //                      automatic int unsigned ii = _ii;
   //                      
   //                      begin
   //                         all_blocks_bit_bash_seq[ii].model = cfg.ral.channels[ii];
   //                         `uvm_send(all_blocks_bit_bash_seq[ii])
   //                      end
   //                   join_none
   //                end
   //                wait fork;
   //             end
   //          join
   
endtask : run_all_blocks


`pragma protect end


`endif // __UVME_CV32_REG_BIT_BASH_VSEQ_SV__
