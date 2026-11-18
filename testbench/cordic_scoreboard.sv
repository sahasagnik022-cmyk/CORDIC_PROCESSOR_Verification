
`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)
 
class cordic_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cordic_scoreboard)
  uvm_analysis_imp_in  #(cordic_seq_item, cordic_scoreboard) port_in;
  uvm_analysis_imp_out #(cordic_seq_item, cordic_scoreboard) port_out;

  typedef struct {
    bit ANG_MUL;
    bit signed [15:0] product;
    bit signed [15:0] cos_val;
    bit signed [15:0] sin_val;
  } exp_item;
  exp_item exp_q[$];
  
  function new(string name="cordic_scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port_in  = new("port_in", this);
    port_out = new("port_out", this);
  endfunction

  virtual function void write_in(cordic_seq_item tx);
    exp_item exp_tx;
    exp_tx.ANG_MUL = tx.ANG_MUL;
    if (tx.ANG_MUL == 1'b1) begin
      calc_ang(tx.payload_in, exp_tx.cos_val, exp_tx.sin_val);
    end else begin
      calc_mul(tx.payload_in, exp_tx.product);
    end  
    exp_q.push_back(exp_tx);
  endfunction

  virtual function void write_out(cordic_seq_item tx);
    exp_item exp_tx;
    bit signed [15:0] act_product, act_cos, act_sin;
    int cos_diff, sin_diff;
    if (exp_q.size() == 0) begin
      `uvm_error("SCB", "Received output but expected queue is empty!")
      return;
    end
    exp_tx = exp_q.pop_front();
    if (exp_tx.ANG_MUL == 1'b1) begin
      act_cos = tx.payload_out[15:0];
      act_sin = tx.payload_out[31:16];
      cos_diff = (act_cos > exp_tx.cos_val) ? (act_cos - exp_tx.cos_val) : (exp_tx.cos_val - act_cos);
      sin_diff = (act_sin > exp_tx.sin_val) ? (act_sin - exp_tx.sin_val) : (exp_tx.sin_val - act_sin);
      if (cos_diff <= 5 && sin_diff <= 5) begin
        `uvm_info("SCB_PASS", $sformatf("ANGLE: Cos(Exp:%0d, Act:%0d) Sin(Exp:%0d, Act:%0d)", 
                  exp_tx.cos_val,act_cos,exp_tx.sin_val,act_sin), UVM_LOW)
      end else begin
        `uvm_error("SCB_FAIL", $sformatf("ANGLE TOLERANCE EXCEEDED! Cos Diff: %0d, Sin Diff: %0d", cos_diff, sin_diff))
      end
    end else begin
      act_product = tx.payload_out[15:0];
      if (exp_tx.product !== act_product) begin
        `uvm_error("SCB_FAIL", $sformatf("MULT MISMATCH: Exp: %0d, Act: %0d", exp_tx.product, act_product))
      end else begin
        `uvm_info("SCB_PASS", $sformatf("MULT MATCH: %0d", act_product), UVM_LOW)
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
