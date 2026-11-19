class dir_mult_pos_neg extends cordic_test;
  `uvm_component_utils(dir_mult_pos_neg)

  seq_dir_mult_pos_neg s8;

  function new(string name="dir_mult_pos_neg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s8 = seq_dir_mult_pos_neg::type_id::create("s8");
    s8.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
