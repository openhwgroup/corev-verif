//
//------------------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2015-2018 NVIDIA Corporation
// Copyright 2017 Cisco Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// CLASS -- NODOCS -- uvm_random_stimulus #(T)
//
// A general purpose unidirectional random stimulus class.
//
// The uvm_random_stimulus class generates streams of T transactions. These streams
// may be generated by the randomize method of T, or the randomize method of
// one of its subclasses.  The stream may go indefinitely, until terminated
// by a call to stop_stimulus_generation, or we may specify the maximum number
// of transactions to be generated.
//
// By using inheritance, we can add directed initialization or tidy up after
// random stimulus generation. Simply extend the class and define the run task,
// calling super.run() when you want to begin the random stimulus phase of
// simulation.
//
// While very useful in its own right, this component can also be used as a
// template for defining other stimulus generators, or it can be extended to
// add additional stimulus generation methods and to simplify test writing.
//
//------------------------------------------------------------------------------

`ifdef UVM_ENABLE_DEPRECATED_API 

class uvm_random_stimulus #(type T=uvm_transaction) extends uvm_component;

  typedef uvm_random_stimulus #(T) this_type;
  `uvm_component_param_utils(this_type)
  // TODO: Would this be better as:
  //| `uvm_type_name_decl($sformatf("uvm_random_stimulus #(%s)", T::type_name))
  `uvm_type_name_decl("uvm_random_stimulus #(T)")

  // Port -- NODOCS -- blocking_put_port
  //
  // The blocking_put_port is used to send the generated stimulus to the rest
  // of the testbench.
                                                      
  uvm_blocking_put_port #(T) blocking_put_port;


  // Function -- NODOCS -- new
  //
  // Creates a new instance of a specialization of this class.
  // Also, displays the random state obtained from a get_randstate call.
  // In subsequent simulations, set_randstate can be called with the same
  // value to reproduce the same sequence of transactions.

  function new(string name, uvm_component parent);

    super.new(name, parent);

    blocking_put_port=new("blocking_put_port", this);
    
    uvm_report_info("uvm_stimulus", {"rand state is ", get_randstate()});

  endfunction


  local bit m_stop;


  // Function -- NODOCS -- generate_stimulus
  //
  // Generate up to max_count transactions of type T.
  // If t is not specified, a default instance of T is allocated and used.
  // If t is specified, that transaction is used when randomizing. It must
  // be a subclass of T.
  //
  // max_count is the maximum number of transactions to be
  // generated. A value of zero indicates no maximum - in
  // this case, generate_stimulus will go on indefinitely
  // unless stopped by some other process
  //
  // The transactions are cloned before they are sent out 
  // over the blocking_put_port

  virtual task generate_stimulus(T t=null, int max_count=0);

    T temp;
    
    if (t == null)
      t = new;
    
    for (int i=0; (max_count == 0 || i < max_count) && !m_stop; i++) begin

       if (! t.randomize() )
          uvm_report_warning ("RANDFL", "Randomization failed in generate_stimulus");
      
       $cast(temp, t.clone());
       uvm_report_info("stimulus generation", temp.convert2string()); 
       blocking_put_port.put(temp);
    end
  endtask
  

  // Function -- NODOCS -- stop_stimulus_generation
  //
  // Stops the generation of stimulus.
  // If a subclass of this method has forked additional
  // processes, those processes will also need to be
  // stopped in an overridden version of this method
  
  virtual function void stop_stimulus_generation;
    m_stop = 1;
  endfunction
  

endclass : uvm_random_stimulus
`endif //UVM_ENABLE_DEPRECATED_API
