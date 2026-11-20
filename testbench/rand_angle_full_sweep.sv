class rand_angle_full_sweep extends cordic_test;
  `uvm_component_utils(rand_angle_full_sweep)

  seq_rand_angle_full_sweep s10;

  function new(string name="rand_angle_full_sweep",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s10 = seq_rand_angle_full_sweep::type_id::create("s10");
    s10.start(env.in_agt.seqr);
    #520;
    phase.drop_objection(this);
  endtask
endclass
