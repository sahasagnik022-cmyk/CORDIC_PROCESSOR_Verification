class cordic_in_agent extends uvm_agent;
  `uvm_component_utils(cordic_in_agent)
  cordic_sequencer seqr;
  cordic_driver drv;
  cordic_in_monitor in_mon;
  
  function new(string name="cordic_in_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr=cordic_sequencer::type_id::create("seqr",this);
    drv=cordic_driver::type_id::create("drv",this);
    in_mon=cordic_in_monitor::type_id::create("in_mon",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass
