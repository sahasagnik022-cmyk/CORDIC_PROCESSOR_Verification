//BASE TEST
class cordic_test extends uvm_test;
  `uvm_component_utils(cordic_test)
  
  cordic_env env;
  
  function new(string name="cordic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=cordic_env::type_id::create("env",this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass


//RANDOM TEST
class test extends cordic_test;
  `uvm_component_utils(test)

  cordic_sequence s1;

  function new(string name="test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s1 = cordic_sequence::type_id::create("s1");
    s1.start(env.in_agt.seqr);
    #260;
    phase.drop_objection(this);
  endtask
endclass
    


//ANGLE MODE SANITY TEST
class rand_angle_mode extends cordic_test;
  `uvm_component_utils(rand_angle_mode)

  seq_angle_mode s1;

  function new(string name="rand_angle_mode",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s1 = seq_angle_mode::type_id::create("s1");
    s1.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass  


//MUL MODE SANITY TEST
class rand_mult_mode extends cordic_test;
  `uvm_component_utils(rand_mult_mode)

  seq_mult_mode s2;

  function new(string name="rand_mult_mode",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s2 = seq_mult_mode::type_id::create("s2");
    s2.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass 


//ANGLE 0 DIRECTED TEST
class dir_angle_0_deg extends cordic_test;
  `uvm_component_utils(dir_angle_0_deg)

  seq_dir_angle_0_deg s3;

  function new(string name="dir_angle_0_deg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s3 = seq_dir_angle_0_deg::type_id::create("s3");
    s3.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass 


//ANGLE 90 DIRECTED TEST
class dir_angle_90_deg extends cordic_test;
  `uvm_component_utils(dir_angle_90_deg)

  seq_dir_angle_90_deg s4;

  function new(string name="dir_angle_90_deg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s4 = seq_dir_angle_90_deg::type_id::create("s4");
    s4.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass 


//ANGLE 180 DIRECTED TEST
class dir_angle_180_deg extends cordic_test;
  `uvm_component_utils(dir_angle_180_deg)

  seq_dir_angle_180_deg s5;

  function new(string name="dir_angle_180_deg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s5 = seq_dir_angle_180_deg::type_id::create("s5");
    s5.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass 


//ANGLE 270 DIRECTED TEST
class dir_angle_270_deg extends cordic_test;
  `uvm_component_utils(dir_angle_270_deg)

  seq_dir_angle_270_deg s6;

  function new(string name="dir_angle_270_deg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s6 = seq_dir_angle_270_deg::type_id::create("s6");
    s6.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass


//ANGLE MAX DIRECTED TEST
class dir_angle_max_value extends cordic_test;
  `uvm_component_utils(dir_angle_max_value)

  seq_dir_angle_max_value s6;

  function new(string name="dir_angle_max_value",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s6 = seq_dir_angle_max_value::type_id::create("s6");
    s6.start(env.in_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass 


//MUL NEG NEG DIRECTED TEST
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
    phase.drop_objection(this);
  endtask
endclass


//MUL POS NEG DIRECTED TEST
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
    phase.drop_objection(this);
  endtask
endclass


//MUL ZERO DIRECTED TEST
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
    phase.drop_objection(this);
  endtask
endclass


//RAND ANGLE MODE FULL SWEEP TEST
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
    phase.drop_objection(this);
  endtask
endclass


//RAND MULT MODE FULL SWEEP TEST
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
    phase.drop_objection(this);
  endtask
endclass


//RAND MIXED MODE BACK TO BACK TEST
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
    phase.drop_objection(this);
  endtask
endclass
