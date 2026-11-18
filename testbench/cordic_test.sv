class cordic_test extends uvm_test;
  `uvm_component_utils(cordic_test)
  cordic_env env;
  
  function new(string name="cordic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=cordic_env::type_id::create("env",this);
  endfunction
  
  virtual function void end_of_elaboaration_phase(uvm_phase phase);
    super.end_of_elaboaration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass