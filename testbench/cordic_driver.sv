class cordic_driver extends uvm_driver #(cordic_seq_item);
  `uvm_component_utils(cordic_driver)
  
  virtual cordic_if vif;


  function new(string name="cordic_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual cordic_if)::get(this,"","vif",vif))
      `uvm_fatal("DRIVER", "Could not fetch virtual interface")
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    if (vif.RSTn !== 1'b0) begin
      @(negedge vif.RSTn);
    end
    vif.START   <= 1'b0;
    vif.DATA_IN <= 8'h00;
    @(posedge vif.RSTn);
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask
  virtual task drive_item(cordic_seq_item req); 
    wait(vif.drv_cb.BUSY == 1'b0);
    @(vif.drv_cb);//C0    
    vif.drv_cb.START   <= 1'b1;
    vif.drv_cb.ANG_MUL <= req.ANG_MUL;
    @(vif.drv_cb);//C1
    vif.drv_cb.START   <= 1'b0;
    vif.drv_cb.DATA_IN <= req.payload_in[7:0];
    @(vif.drv_cb);//C2
    vif.drv_cb.DATA_IN <= req.payload_in[15:8];
    @(vif.drv_cb);//C3
    vif.drv_cb.DATA_IN <= 8'h00;
  endtask
  
endclass
