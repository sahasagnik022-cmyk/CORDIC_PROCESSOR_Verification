class cordic_out_agent extends uvm_agent;
  `uvm_component_utils(cordic_out_agent)
  cordic_out_monitor out_mon;
  
  function new(string name="cordic_out_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    out_mon=cordic_out_monitor::type_id::create("out_mon",this);
  endfunction
  
endclass
