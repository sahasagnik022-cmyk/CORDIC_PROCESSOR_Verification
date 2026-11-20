class dir_mult_zero extends cordic_test;
  `uvm_component_utils(dir_mult_zero)

  seq_dir_mult_zero s9;

  function new(string name="dir_mult_zero",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s9 = seq_dir_mult_zero::type_id::create("s9");
    s9.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
