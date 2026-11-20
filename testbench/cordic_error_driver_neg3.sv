class cordic_error_driver extends cordic_driver;
    `uvm_component_utils(cordic_error_driver)

    function new(string name="cordic_error_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual task drive_item(cordic_seq_item req);
        wait(vif.drv_cb.BUSY == 1'b0);

        @(vif.drv_cb); // C0
        vif.drv_cb.START   <= 1'b1;
        vif.drv_cb.ANG_MUL <= req.ANG_MUL;

        @(vif.drv_cb); // C1
        vif.drv_cb.START   <= 1'b0;
        vif.drv_cb.DATA_IN <= 8'h42;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'h42), UVM_LOW)

        @(vif.drv_cb); // C2
        vif.drv_cb.DATA_IN <= 8'h4F;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'h4F), UVM_LOW)

        @(vif.drv_cb); // C3
        vif.drv_cb.DATA_IN <= 8'h76;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'h76), UVM_LOW)

        repeat(req.delay_start) begin
            @(vif.drv_cb);
        end

        `uvm_info("DRV", "Give garbage DATA_IN values during CORDIC operation", UVM_LOW)

        vif.drv_cb.DATA_IN <= 8'h65;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'h65), UVM_LOW)

        @(vif.drv_cb);
        vif.drv_cb.DATA_IN <= 8'h35;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'h35), UVM_LOW)

        @(vif.drv_cb);
        vif.drv_cb.DATA_IN <= 8'h1C;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'h1C), UVM_LOW)

        @(vif.drv_cb);
        vif.drv_cb.DATA_IN <= 8'hAB;
        `uvm_info("DRV", $sformatf("DATA_IN = %h", 8'hAB), UVM_LOW)

    endtask
endclass
