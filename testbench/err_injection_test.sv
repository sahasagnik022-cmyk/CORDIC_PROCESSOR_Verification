class err_injection_test extends cordic_test;
  `uvm_component_utils(err_injection_test)

  seq_err_injection se;

  function new(string name="err_injection_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    se = seq_err_injection::type_id::create("se");
    se.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
