class dir_mult_neg_pos extends cordic_test;
  `uvm_component_utils(dir_mult_neg_pos)

  seq_dir_mult_neg_pos s16;

  function new(string name="dir_mult_neg_pos",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s16 = seq_dir_mult_neg_pos::type_id::create("s16");
    s16.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
