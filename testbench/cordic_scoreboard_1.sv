`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class cordic_scoreboard_1 extends uvm_scoreboard;
  `uvm_component_utils(cordic_scoreboard_1)
  uvm_analysis_imp_in  #(cordic_seq_item, cordic_scoreboard_1) port_in;
  uvm_analysis_imp_out #(cordic_seq_item, cordic_scoreboard_1) port_out;

 typedef struct {
  bit               ANG_MUL;
  bit signed [15:0] product;
  bit signed [15:0] cos_val;
  bit signed [15:0] sin_val;
} expected_item_s;

  expected_item_s exp_queue[$];

  bit [7:0] input_byte_queue[$];
  int byte_count = 0;
  bit input_mode;

  bit [7:0] output_byte_queue[$];
  int out_byte_count = 0;

  function new(string name="cordic_scoreboard_1", uvm_component parent=null);
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
  bit [15:0] data_in;

  // START: beginning of a new transaction
  if (tx.START == 1'b1) begin
    input_byte_queue.delete();
    byte_count = 0;
    input_mode = tx.ANG_MUL;
    return;
  end

  // Collect exactly two bytes
  if (byte_count < 2) begin

    input_byte_queue.push_back(tx.DATA_IN);
    byte_count++;

    if (byte_count == 2) begin

      // Reconstruct 16-bit payload: MSB:LSB
      data_in = {input_byte_queue[1], input_byte_queue[0]};

      exp_item.ANG_MUL = input_mode;

      if (input_mode)
        calc_ang(data_in, exp_item.cos_val, exp_item.sin_val);
      else
        calc_mul(data_in, exp_item.product);

      exp_queue.push_back(exp_item);

      `uvm_info("SCB_INPUT",
        $sformatf("MODE=%0b BYTE0=%02h BYTE1=%02h PAYLOAD=%04h",
        input_mode,
        input_byte_queue[0],
        input_byte_queue[1],
        data_in), UVM_LOW)

    end
  end

endfunction

  // --------------------------------------------------------
  // OUTPUT CHECKING (Compare against DUT)
  // --------------------------------------------------------
virtual function void write_out(cordic_seq_item tx);

  expected_item_s exp_item;

  bit signed [15:0] act_product;
  bit signed [15:0] act_cos, act_sin;

  int cos_diff, sin_diff;
  int required_bytes;

  if (tx.DONE == 1'b0) begin
    output_byte_queue.delete();
    out_byte_count = 0;
    return;
  end

  if (exp_queue.size() == 0) begin
    if (out_byte_count == 0)
      `uvm_error("SCB", "Output received but expected queue is empty!")
    return;
  end

  if (exp_queue[0].ANG_MUL)
    required_bytes = 4;
  else
    required_bytes = 2;

  if (out_byte_count < required_bytes) begin

    output_byte_queue.push_back(tx.DATA_OUT);
    out_byte_count++;

    if (out_byte_count == required_bytes) begin

      exp_item = exp_queue.pop_front();

      if (exp_item.ANG_MUL) begin

        act_cos = {output_byte_queue[1], output_byte_queue[0]};
        act_sin = {output_byte_queue[3], output_byte_queue[2]};

        cos_diff = int'($signed(act_cos)) -
                   int'($signed(exp_item.cos_val));

        sin_diff = int'($signed(act_sin)) -
                   int'($signed(exp_item.sin_val));

        if (cos_diff < 0)
          cos_diff = -cos_diff;

        if (sin_diff < 0)
          sin_diff = -sin_diff;

        `uvm_info("SCB_COMPARE",
          $sformatf(
            "COS: EXP=%0d ACT=%0d DIFF=%0d | SIN: EXP=%0d ACT=%0d DIFF=%0d",
            exp_item.cos_val, act_cos, cos_diff,
            exp_item.sin_val, act_sin, sin_diff), UVM_LOW)

        if (cos_diff <= 11 && sin_diff <= 11) begin
          `uvm_info("SCB_PASS",
            "ANGLE OUTPUT MATCHED", UVM_LOW)
        end
        else begin
          `uvm_error("SCB_FAIL",
            $sformatf("ANGLE MISMATCH! Cos Diff:%0d Sin Diff:%0d",
            cos_diff, sin_diff))
        end

      end
      else begin

        act_product = {output_byte_queue[1], output_byte_queue[0]};

        if (exp_item.product !== act_product)
          `uvm_error("SCB_FAIL",
            $sformatf("MULT MISMATCH: Exp:%0d Act:%0d",
            exp_item.product, act_product))
        else
          `uvm_info("SCB_PASS",
            $sformatf("MULT MATCH: %0d", act_product), UVM_LOW)

      end
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
    // 1. Convert 16-bit integer to Radians
    angle_radians = (real'(data_in) / 65536.0) * 2.0 * pi;
    // 2. Calculate ideal floating-point trigonometric values
    ideal_cos = $cos(angle_radians);
    ideal_sin = $sin(angle_radians);
    // 3. Convert to Q1.14 Fixed-Point (Multiply by 2^14 and cast to integer)
    cos_out = $rtoi(ideal_cos * 16384.0);
    sin_out = $rtoi(ideal_sin * 16384.0);
  endfunction
endclass
