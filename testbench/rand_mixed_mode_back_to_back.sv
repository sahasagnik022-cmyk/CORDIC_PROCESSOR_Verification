class rand_mixed_mode_back_to_back extends cordic_test;
  `uvm_component_utils(rand_mixed_mode_back_to_back)

  seq_rand_mixed_mode_back_to_back s12;

  function new(string name="rand_mixed_mode_back_to_back",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s12 = seq_rand_mixed_mode_back_to_back::type_id::create("s12");
    s12.start(env.in_agt.seqr);
    #520;
    phase.drop_objection(this);
  endtask
endclass
