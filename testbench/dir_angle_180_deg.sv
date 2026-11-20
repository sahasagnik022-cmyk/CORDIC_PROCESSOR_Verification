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
    #520;
    phase.drop_objection(this);
  endtask
endclass
