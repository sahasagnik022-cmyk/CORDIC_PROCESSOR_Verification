class cordic_out_monitor extends uvm_monitor;
  `uvm_component_utils(cordic_out_monitor)
  
  virtual cordic_if vif;
  uvm_analysis_port #(cordic_seq_item) out_mon_ap;
  
  function new(string name="cordic_out_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual cordic_if)::get(this,"","vif",vif)) begin
      `uvm_fatal("OUT_MON", "Virtual interface not found")
    end
    
    out_mon_ap = new("out_mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    cordic_seq_item cseq;
    int byte_cnt;
    if (vif.RSTn!==1'b0) begin
      @(negedge vif.RSTn);
    end
    @(posedge vif.RSTn);
    
    forever begin
      @(vif.out_mon_cb iff vif.out_mon_cb.DONE === 1'b1);
      cseq = cordic_seq_item::type_id::create("cseq");
      cseq.payload_out = 32'h0;
      byte_cnt = 0;
      
      while (vif.out_mon_cb.DONE === 1'b1) begin
        if (byte_cnt==0) cseq.payload_out[7:0]=vif.out_mon_cb.DATA_OUT;
        if (byte_cnt==1) cseq.payload_out[15:8]=vif.out_mon_cb.DATA_OUT;
        if (byte_cnt==2) cseq.payload_out[23:16]=vif.out_mon_cb.DATA_OUT;
        if (byte_cnt==3) cseq.payload_out[31:24]=vif.out_mon_cb.DATA_OUT;
        byte_cnt++;
        @(vif.out_mon_cb);
      end
      out_mon_ap.write(cseq);
    end
  endtask
  
endclass
