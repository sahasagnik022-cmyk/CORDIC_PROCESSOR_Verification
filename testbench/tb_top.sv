`include "uvm_macros.svh"
`include "cordic_if.sv"
`include "cordic_pkg.sv"
`include "CORDIC.v"
`include "cordic_sva.sv"
module tb_top;

  import uvm_pkg::*;
  import cordic_pkg::*;

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

  bind CORDIC cordic_sva sva_inst (
    .CLK(CLK),
    .RSTn(RSTn),
    .START(START),
    .ANG_MUL(ANG_MUL),
    .DATA_IN(DATA_IN),
    .BUSY(BUSY),
    .ERROR(ERROR),
    .DONE(DONE),
    .ENABLE(ENABLE),
    .DATA_OUT(DATA_OUT)
  );

  initial begin
    uvm_config_db #(virtual cordic_if)::set(null,"*","vif",DUV_IF);
    run_test();
  end

  initial begin
    CLK = 1'b0;

    forever begin
      #10 CLK = ~CLK;
    end
  end

  initial begin
      $fsdbDumpfile("dump.fsdb");
      $fsdbDumpvars(0,tb_top);
  end

  initial begin
    RSTn = 1'b0;
    #20;
    RSTn = 1'b1;
    if($test$plusargs("MID_TEST_RESET")) begin
        @(posedge DUV_IF.START);
        @(posedge DUV_IF.CLK);
        #1;
        RSTn = 1'b0; //load_input->idle
        @(posedge DUV_IF.CLK);
        #1; RSTn = 1'b1;
        @(posedge DUV_IF.BUSY);
        repeat(3) @(posedge DUV_IF.CLK);
        #1; RSTn = 1'b0;
        @(posedge DUV_IF.CLK);
        #1; RSTn = 1'b1;
        repeat(12)@(posedge DUV_IF.CLK);
        #1; RSTn = 1'b0; //cordic_op->idle
        @(posedge DUV_IF.CLK);
        #1; RSTn = 1'b1;
    end
  end

endmodule
