class dir_mult_corners_test extends cordic_test;
  `uvm_component_utils(dir_mult_corners_test)

  seq_dir_mult_corners sx;

  function new(string name="dir_mult_corners_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    sx = seq_dir_mult_corners::type_id::create("sx");
    sx.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
