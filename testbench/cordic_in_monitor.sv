class cordic_in_monitor extends uvm_monitor;
  `uvm_component_utils(cordic_in_monitor)
  
  virtual cordic_if vif;
  uvm_analysis_port #(cordic_seq_item) in_mon_ap;
  
  function new(string name="cordic_in_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual cordic_if)::get(this,"","vif",vif)) begin
      `uvm_fatal("MON", "Virtual interface not found")
    end
    
    in_mon_ap = new("in_mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    cordic_seq_item cseq;
    
    forever begin
      if (vif.RSTn !== 1'b0) begin
        @(negedge vif.RSTn);
      end
      @(posedge vif.RSTn);
      
      fork
        begin: normal_loop
          forever begin
            @(vif.in_mon_cb iff (vif.in_mon_cb.START == 1'b1 && vif.in_mon_cb.BUSY ==1'b0));
            cseq = cordic_seq_item::type_id::create("cseq");
            cseq.ANG_MUL = vif.in_mon_cb.ANG_MUL; 
            @(vif.in_mon_cb);//Cycle C1
            cseq.payload_in[7:0]  = vif.in_mon_cb.DATA_IN; 
            @(vif.in_mon_cb);// Cycle C2
            cseq.payload_in[15:8] = vif.in_mon_cb.DATA_IN; 
            cseq.is_reset = 1'b0;
            in_mon_ap.write(cseq);
          end
        end
        begin: reset_check
          @(negedge vif.RSTn);
        end
      join_any
      
      disable fork;
      
      if(vif.RSTn == 1'b0) begin
        cseq = cordic_seq_item::type_id::create("cseq");
        cseq.is_reset = 1'b1;
        in_mon_ap.write(cseq);    
      end
    end
  endtask
  
endclass
