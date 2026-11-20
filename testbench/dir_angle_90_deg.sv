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
    #520;
    phase.drop_objection(this);
  endtask
endclass
