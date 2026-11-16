class cordic_driver extends uvm_driver #(cordic_seq_item);
  `uvm_component_utils(cordic_driver)
  
  virtual cordic_if.DRV vif
  
  
  function new(string name="cordic_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual cordic_if)::get(this,"","virtual_if",vif))
      `uvm_error("Driver","DRIVER COULD NOT FETCH INTERFACE");
  endfunction
  
  task run_phase(uvm_phase phase);
    if(RSTn!=0) begin
      @(negedge RSTn);
    end
    @(posedge RSTn);
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_item(cordic_seq_item req); 
    if(vif.BUSY==0) begin
   // Wait for aligned clock edge (C0) 
      @(posedge vif.drv_cb)
  // Assert START and drive ANG_MUL selector     
      vif.drv_cb.START<=1;
      vif.drv_cb.ANG_MUL<=req.ANG_MUL;
  // Wait for next clock edge (C1) 
      @(posedge vif.drv_cb)
  // Deassert START     
      vif.START<=0;
  // Drive Low Byte onto DATA_IN bus 
      vif.DATA_IN<=req.DATA_IN;
    
  // Wait for next clock edge (C2)     
      @(posedge vif.drv_cb)
  // Drive High Byte onto DATA_IN bus     
      vif.DATA_IN<=req.DATA_IN;
 

  // Wait for next clock edge (C3) 
      @(posedge vif).drv_cb;
      vif.DATA_IN<=0;
  // Clear DATA_IN bus to avoid residual sampling 
    end
endtask 
      
      
      
      
      
    