class cordic_sequencer extends uvm_sequencer#(cordic_seq_item);
  `uvm_component_utils(cordic_sequencer)
  
  function new(string name="cordic_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
endclass
