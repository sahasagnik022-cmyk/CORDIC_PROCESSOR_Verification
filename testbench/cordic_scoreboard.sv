
`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)
 
class cordic_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cordic_scoreboard)
  uvm_analysis_imp_in  #(cordic_seq_item, cordic_scoreboard) port_in;
  uvm_analysis_imp_out #(cordic_seq_item, cordic_scoreboard) port_out;
 
  // Unified expected struct to keep mode and data synchronized
  typedef struct {
    bit               ANG_MUL;
    bit signed [15:0] product;
    bit signed [15:0] cos_val;
    bit signed [15:0] sin_val;
  } expected_item_s;
  expected_item_s exp_queue[$];
  
  function new(string name="cordic_scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Corrected spelling of port instantiations
    port_in  = new("port_in", this);
    port_out = new("port_out", this);
  endfunction
  
  // --------------------------------------------------------
  // INPUT TRACKING (Calculate Golden Reference)
  // --------------------------------------------------------
  virtual function void write_in(cordic_seq_item tx);
    expected_item_s exp_item;
    exp_item.ANG_MUL = tx.ANG_MUL;
    if (tx.ANG_MUL == 1'b1) begin
      calc_ang(tx.payload_in, exp_item.cos_val, exp_item.sin_val);
    end else begin
      calc_mul(tx.payload_in, exp_item.product);
    end  
    // Push the complete expected transaction into our synchronous queue
    exp_queue.push_back(exp_item);
  endfunction
  
  // --------------------------------------------------------
  // OUTPUT CHECKING (Compare against DUT)
  // --------------------------------------------------------
  virtual function void write_out(cordic_seq_item tx);
    expected_item_s exp_item;
    bit signed [15:0] act_product, act_cos, act_sin;
    int cos_diff, sin_diff;
    if (exp_queue.size() == 0) begin
      `uvm_error("SCB", "Received output but expected queue is empty!")
      return;
    end
    // Pop the golden reference
    exp_item = exp_queue.pop_front();
    if (exp_item.ANG_MUL == 1'b1) begin
      // Extract from the 32-bit output payload
      act_cos = tx.payload_out[15:0];
      act_sin = tx.payload_out[31:16];
      // Calculate absolute difference
      cos_diff = (act_cos > exp_item.cos_val) ? (act_cos - exp_item.cos_val) : (exp_item.cos_val - act_cos);
      sin_diff = (act_sin > exp_item.sin_val) ? (act_sin - exp_item.sin_val) : (exp_item.sin_val - act_sin);
      if (cos_diff <= 5 && sin_diff <= 5) begin
        `uvm_info("SCB_PASS", $sformatf("ANGLE: Cos(Exp:%0d, Act:%0d) Sin(Exp:%0d, Act:%0d)", 
                  exp_item.cos_val, act_cos, exp_item.sin_val, act_sin), UVM_LOW)
      end else begin
        `uvm_error("SCB_FAIL", $sformatf("ANGLE TOLERANCE EXCEEDED! Cos Diff: %0d, Sin Diff: %0d", cos_diff, sin_diff))
      end
    end else begin
      // Extract the 16-bit product
      act_product = tx.payload_out[15:0];
      if (exp_item.product !== act_product) begin
        `uvm_error("SCB_FAIL", $sformatf("MULT MISMATCH: Exp: %0d, Act: %0d", exp_item.product, act_product))
      end else begin
        `uvm_info("SCB_PASS", $sformatf("MULT MATCH: %0d", act_product), UVM_LOW)
      end
    end
  endfunction

  // --------------------------------------------------------
  // MATHEMATICAL FUNCTIONS (Changed from 'task' to 'function void')
  // --------------------------------------------------------
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
    // 1. Convert 16-bit BAM integer to Radians
    angle_radians = (real'(data_in) / 65536.0) * 2.0 * pi;
    // 2. Calculate ideal floating-point trigonometric values
    ideal_cos = $cos(angle_radians);
    ideal_sin = $sin(angle_radians);
    // 3. Convert to Q1.14 Fixed-Point (Multiply by 2^14 and cast to integer)
    cos_out = $rtoi(ideal_cos * 16384.0);
    sin_out = $rtoi(ideal_sin * 16384.0);
  endfunction
endclass
