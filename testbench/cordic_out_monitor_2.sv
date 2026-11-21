class cordic_out_monitor_2 extends uvm_monitor;
  `uvm_component_utils(cordic_out_monitor_2)

  virtual cordic_if vif;
  uvm_analysis_port #(cordic_seq_item) out_mon_ap;

  function new(string name="cordic_out_monitor_2", uvm_component parent=null);
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
    
    if (vif.RSTn !== 1'b0) begin
      @(negedge vif.RSTn);
    end
    
    forever begin
      @(posedge vif.RSTn);

      fork
        begin : normal_loop
          forever begin 
            @(vif.out_mon_cb);
            cseq = cordic_seq_item::type_id::create("cseq");
            cseq.DONE = vif.out_mon_cb.DONE;
            cseq.DATA_OUT = vif.out_mon_cb.DATA_OUT;
            cseq.is_reset = 1'b0; 
            out_mon_ap.write(cseq);
          end
        end
        begin : reset_check
          @(negedge vif.RSTn);
        end
      join_any

      disable fork;

      if (vif.RSTn === 1'b0) begin
        cseq = cordic_seq_item::type_id::create("cseq");
        cseq.is_reset = 1'b1;
        out_mon_ap.write(cseq);    
      end
    end
  endtask

endclass
