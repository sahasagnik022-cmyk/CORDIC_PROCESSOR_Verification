class dir_mult_neg_neg extends cordic_test;
  `uvm_component_utils(dir_mult_neg_neg)

  seq_dir_mult_neg_neg s7;

  function new(string name="dir_mult_neg_neg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s7 = seq_dir_mult_neg_neg::type_id::create("s7");
    s7.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
