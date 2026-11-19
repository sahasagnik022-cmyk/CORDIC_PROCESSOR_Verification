interface cordic_if(input bit CLK,input bit RSTn);
  logic [7:0] DATA_IN;
  logic START;
  logic ANG_MUL;
  logic BUSY;
  logic DONE;
  logic ERROR;
  logic [7:0] ENABLE;//Bi-directional pins
  logic [7:0] DATA_OUT;
  
  clocking drv_cb @(posedge CLK);
    default input #1 output #1;
    output DATA_IN,START,ANG_MUL;
    input BUSY,DONE,ERROR;
  endclocking
  
  clocking in_mon_cb @(posedge CLK);
    default input #1 output #1;
    input DATA_IN,START,ANG_MUL,BUSY;
  endclocking
  
  clocking out_mon_cb @(posedge CLK);
    default input #1 output #1;
    input DATA_OUT,ERROR,BUSY,DONE;
  endclocking
  
  modport drv_in(clocking drv_cb,input CLK,RSTn);
  modport in_mon(clocking in_mon_cb,input CLK,RSTn);
  modport out_mon(clocking out_mon_cb,input CLK,RSTn);
  
endinterface
