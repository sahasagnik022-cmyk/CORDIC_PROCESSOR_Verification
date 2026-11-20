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
    #520;
    phase.drop_objection(this);
  endtask
endclass 
