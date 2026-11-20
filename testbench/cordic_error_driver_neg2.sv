class cordic_error_driver extends cordic_driver;
    `uvm_component_utils(cordic_error_driver)

    function new(string name="cordic_error_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

  virtual task drive_item(cordic_seq_item req);
    wait(vif.drv_cb.BUSY == 1'b0);
    @(vif.drv_cb);//C0
    vif.drv_cb.START   <= 1'b1;
    vif.drv_cb.ANG_MUL <= 1'b0;
    @(vif.drv_cb);//C1
    vif.drv_cb.START   <= 1'b0;
    vif.drv_cb.DATA_IN <= req.payload_in[7:0];
    @(vif.drv_cb);//C2
    vif.drv_cb.DATA_IN <= req.payload_in[15:8];
    @(vif.drv_cb);//C3
    vif.drv_cb.DATA_IN <= 8'h00;
    repeat(req.delay_start) begin
        @(vif.drv_cb);
    end
    `uvm_info("DRV",$sformatf("Toggle the ANG_MUL pin to random value while BUSY"),UVM_LOW)
    vif.drv_cb.ANG_MUL<=1'b1;
    @(vif.drv_cb);
    vif.drv_cb.ANG_MUL<=1'b0;
    @(vif.drv_cb);
    vif.drv_cb.ANG_MUL<=1'b1;
    @(vif.drv_cb);
    vif.drv_cb.ANG_MUL<=1'b0;
  endtask
endclass
