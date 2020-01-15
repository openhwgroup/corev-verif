// COPYRIGHT HEADER


`ifndef __UVMA_DEBUG_SQR_SV__
`define __UVMA_DEBUG_SQR_SV__


/**
 * Component running Debug sequences extending uvma_debug_seq_base_c.
 * Provides sequence items for uvma_debug_drv_c.
 */
class uvma_debug_sqr_c extends uvm_sequencer#(
   .REQ(uvma_debug_seq_item_c),
   .RSP(uvma_debug_seq_item_c)
);
   
   // Objects
   uvma_debug_cfg_c    cfg;
   uvma_debug_cntxt_c  cntxt;
   
   
   `uvm_component_utils_begin(uvma_debug_sqr_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_debug_sqr", uvm_component parent=null);
   
   /**
    * Ensures cfg & cntxt handles are not null
    */
   extern virtual function void build_phase(uvm_phase phase);
   
endclass : uvma_debug_sqr_c


`pragma protect begin


function uvma_debug_sqr_c::new(string name="uvma_debug_sqr", uvm_component parent=null);
   
   super.new(name, parent);
   
endfunction : new


function void uvma_debug_sqr_c::build_phase(uvm_phase phase);
   
   super.build_phase(phase);
   
   void'(uvm_config_db#(uvma_debug_cfg_c)::get(this, "", "cfg", cfg));
   if (!cfg) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end
   
   void'(uvm_config_db#(uvma_debug_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (!cntxt) begin
      `uvm_fatal("CNTXT", "Context handle is null")
   end
   
endfunction : build_phase


`pragma protect end


`endif // __UVMA_DEBUG_SQR_SV__
