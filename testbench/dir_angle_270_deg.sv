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
    #520;
    phase.drop_objection(this);
  endtask
endclass
