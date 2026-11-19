class cordic_env extends uvm_env;
  `uvm_component_utils(cordic_env)
  cordic_subscriber sub;
  cordic_scoreboard scb;
  cordic_in_agent in_agt;
  cordic_out_agent out_agt;
  
  
  function new(string name="cordic_env",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_agt=cordic_in_agent::type_id::create("in_agt",this);
    out_agt=cordic_out_agent::type_id::create("out_agt",this);
    sub=cordic_subscriber::type_id::create("sub",this);
    scb=cordic_scoreboard::type_id::create("scb",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    in_agt.in_mon.in_mon_ap.connect(scb.port_in);
    out_agt.out_mon.out_mon_ap.connect(scb.port_out);
    in_agt.in_mon.in_mon_ap.connect(sub.analysis_export);
  endfunction
  
endclass
