class dir_mult_pos_pos extends cordic_test;
  `uvm_component_utils(dir_mult_pos_pos)

  seq_dir_mult_pos_pos s15;

  function new(string name="dir_mult_pos_pos",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s15 = seq_dir_mult_pos_pos::type_id::create("s15");
    s15.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
