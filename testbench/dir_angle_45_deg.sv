class dir_angle_45_deg extends cordic_test;
  `uvm_component_utils(dir_angle_45_deg)

  seq_dir_angle_45_deg s14;

  function new(string name="dir_angle_45_deg",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s14 = seq_dir_angle_45_deg::type_id::create("s14");
    s14.start(env.in_agt.seqr);
    #520;
    phase.drop_objection(this);
  endtask
endclass 
