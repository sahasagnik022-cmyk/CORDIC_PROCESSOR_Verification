`include "cordic_if.sv"
`include "test_pkg.sv"

module testbench;
  
  import uvm_pkg::*;
  import test_pkg::*;
  
  bit CLK, RSTn;
  
  cordic_if DUV_IF(CLK, RSTn);
  
  CORDIC DUV(
    .CLK(CLK),
    .RSTn(RSTn),
    .START(DUV_IF.START),
    .ANG_MUL(DUV_IF.ANG_MUL),
    .DATA_IN(DUV_IF.DATA_IN),
    .BUSY(DUV_IF.BUSY),
    .DONE(DUV_IF.DONE),
    .ERROR(DUV_IF.ERROR),
    .ENABLE(DUV_IF.ENABLE),
    .DATA_OUT(DUV_IF.DATA_OUT)
  );
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, testbench);
end
  
  initial begin
    uvm_config_db #(virtual cordic_if)::set(null,"*","vif",DUV_IF);
    run_test("test");
  end
  
  initial begin
    CLK = 1'b0;
    
    forever begin
      #5 CLK = ~CLK;
    end
  end
  
  initial begin
    RSTn = 1'b0;
    #10;
    RSTn = 1'b1;
  end
  

endmodule
