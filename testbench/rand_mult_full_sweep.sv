class rand_mult_full_sweep extends cordic_test;
  `uvm_component_utils(rand_mult_full_sweep)

  seq_rand_mult_full_sweep s11;

  function new(string name="rand_mult_full_sweep",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s11 = seq_rand_mult_full_sweep::type_id::create("s11");
    s11.start(env.in_agt.seqr);
    #480;
    phase.drop_objection(this);
  endtask
endclass
