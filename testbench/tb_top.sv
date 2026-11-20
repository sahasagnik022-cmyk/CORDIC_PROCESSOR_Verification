module tb_top;

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
      #5 CLK = ~CLK;
    end
  end

  initial begin
    RSTn = 1'b0;
    #10;
    RSTn = 1'b1;
    #100;
    RSTn=1'b0;
    #20;
    RSTn=1'b1;
  end

endmodule
