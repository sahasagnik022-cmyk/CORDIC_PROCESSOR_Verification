`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)
 
class cordic_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cordic_scoreboard)
  uvm_analysis_imp_in  #(cordic_seq_item, cordic_scoreboard) port_in;
  uvm_analysis_imp_out #(cordic_seq_item, cordic_scoreboard) port_out;

  cordic_seq_item eq[$];
  
  function new(string name="cordic_scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port_in  = new("port_in",this);
    port_out = new("port_out",this);
  endfunction

  virtual function void write_in(cordic_seq_item tx);
      cordic_seq_item exp_tx;
      
      if (tx.is_reset == 1'b1) begin
          eq.delete();
          return;
      end
      
      `uvm_info("SCB","Cloning transaction",UVM_HIGH)
      if(!$cast(exp_tx,tx.clone()))
          `uvm_fatal("SCB","Cloning failed")
      if(exp_tx.ANG_MUL==1'b1) begin
          calc_ang(exp_tx.payload_in,exp_tx.payload_out[15:0],exp_tx.payload_out[31:16]);
      end
      else begin
       calc_mul(exp_tx.payload_in,exp_tx.payload_out[15:0]);
      end
      eq.push_back(exp_tx);
  endfunction

  virtual function void write_out(cordic_seq_item tx);
      cordic_seq_item exp_tx;
      bit signed [15:0] act_product,act_cos,act_sin;
      int cos_diff,sin_diff;
      
      if (tx.is_reset == 1'b1) begin
          eq.delete();
          return;
      end
      
      if(eq.size()==0) begin
          `uvm_error("SCB","Received output but expected queue is empty")
      end
      exp_tx=eq.pop_front();
      if(exp_tx.ANG_MUL==1'b1) begin
          act_cos=tx.payload_out[15:0];
          act_sin=tx.payload_out[31:16];
          cos_diff=(act_cos > exp_tx.payload_out[15:0]) ? (act_cos - exp_tx.payload_out[15:0]):(exp_tx.payload_out[15:0] - act_cos);
          sin_diff=(act_sin > exp_tx.payload_out[31:16]) ? (act_sin - exp_tx.payload_out[31:16]):(exp_tx.payload_out[31:16] - act_sin); 
          if(cos_diff <= 11 && sin_diff <=11) begin
              `uvm_info("SCB_PASS", $sformatf("ANGLE:Cos(Exp:%0d,Act:%0d) Sin(Exp:%0d, Act:%0d)", exp_tx.payload_out[15:0],act_cos,exp_tx.payload_out[31:16],act_sin), UVM_LOW)      
          end 
          else begin
              `uvm_error("SCB_FAIL", $sformatf("ANGLE TOLERANCE EXCEEDED! Cos Diff: %0d, Sin Diff: %0d", cos_diff, sin_diff))
          end
      end
      else begin
          act_product = tx.payload_out[15:0];
          if (exp_tx.payload_out !== act_product) begin
              `uvm_error("SCB_FAIL",$sformatf("MULT MISMATCH (OPA=%0d) x (OPB=%0d): Exp:%0d,Act:%0d",exp_tx.payload_in[7:0],exp_tx.payload_in[15:8],exp_tx.payload_out,act_product))
          end 
          else begin
              `uvm_info("SCB_PASS",$sformatf("MULT MATCH (OPA=%0d) x (OPB=%0d): %0d",exp_tx.payload_in[7:0],exp_tx.payload_in[15:8],act_product), UVM_LOW)
          end
      end
  endfunction

  function void calc_mul(input bit [15:0] data_in, output bit signed [15:0] data_out);
    bit signed [7:0] opa;
    bit signed [7:0] opb;
    opa = data_in[7:0];
    opb = data_in[15:8];
    data_out = opa * opb;
  endfunction
  
  function void calc_ang(input bit [15:0] data_in, output bit signed [15:0] cos_out, output bit signed [15:0] sin_out);
    real pi = $acos(-1.0);
    real angle_radians;
    real ideal_cos, ideal_sin;
    angle_radians = (real'(data_in) / 65536.0) * 2.0 * pi; //Convert to radians
    ideal_cos = $cos(angle_radians);
    ideal_sin = $sin(angle_radians);
    cos_out = $rtoi(ideal_cos * 16384.0);//Multiply with 2^14 and round off to nearest integer
    sin_out = $rtoi(ideal_sin * 16384.0);
  endfunction
endclass
