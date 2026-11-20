module cordic_sva(
  input logic CLK;
  input logic RSTn;
  input logic START;
  input logic ANG_MUL;
  input logic[7:0] DATA_IN;
  output logic BUSY;
  output logic ERROR;
  output logic DONE;
  output logic [7:0]ENABLE;
  output logic [7:0]DATA_OUT;
)

property p1;
  @(negedge RSTn)
  (!START)|-> (!DATA_OUT && !DONE && !BUSY && !ERROR);
endproperty
p1_check:assert property(p1)
   $display("%0t assertion passed",$time);
  else
   $display("%0t assertion failed",$time);
  
property p2;
  @(posedge CLK)
  ENABLE==8'b00111000;
endproperty
  p2_check:assert property(p2)
   $display("%0t assertion passed",$time);
  else
   $display("%0t assertion failed",$time);
    
property p3;
  @(posedge CLK) disable iff(!RSTn);
  START|->BUSY;
endproperty
  p3_check:assert property(p3)
   $display("%0t assertion passed",$time);
  else
   $display("%0t assertion failed",$time);
    
property p4;
  @(posedge CLK) disable iff(!RSTn);
  (BUSY && START)|-> ERROR;
endproperty
    p4_check:assert property(p4)
   $display("%0t assertion passed",$time);
  else
   $display("%0t assertion failed",$time);
      
property p5;
  @(posedge CLK) disable iff(!RSTn);
  (ANG_MUL && START)|->##22(DONE[*4]##1 !DONE);
endproperty
  p5_check:assert property(p5)
   $display("%0t assertion passed",$time);
  else
   $display("%0t assertion failed",$time);

property p6;
  @(posedge CLK) disable iff(!RSTn);
  (!ANG_MUL && START)|->##22(DONE[*2]##1 !DONE);
endproperty
    p6_check:assert property(p6)
   $display("%0t assertion passed",$time);
  else
   $display("%0t assertion failed",$time);

endmodule
