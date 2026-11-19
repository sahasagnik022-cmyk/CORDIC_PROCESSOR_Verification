`include "uvm_macros.svh"
`include "cordic_if.sv"
`include "cordic_pkg.sv"
`include "CORDIC.v"

module tb_top;
  
  import uvm_pkg::*;
  import cordic_pkg::*;
  
  bit CLK, RSTn;
  
  cordic_if vif(CLK, RSTn);
  
  CORDIC DUT(
    .CLK(CLK),
    .RSTn(RSTn),
    .START(vif.START),
    .ANG_MUL(vif.ANG_MUL),
    .DATA_IN(vif.DATA_IN),
    .BUSY(vif.BUSY),
    .DONE(vif.DONE),
    .ERROR(vif.ERROR),
    .ENABLE(vif.ENABLE),
    .DATA_OUT(vif.DATA_OUT)
  );
  
  /*initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end*/
  
  initial begin
    uvm_config_db #(virtual cordic_if)::set(null,"*","vif",vif);
    run_test();
  end
  
  initial begin
    CLK = 1'b0;
    
    forever begin
      #10 CLK = ~CLK;
    end
  end
  
  initial begin
    RSTn = 1'b0;
    #20;
    RSTn = 1'b1;
  end
  

endmodule
