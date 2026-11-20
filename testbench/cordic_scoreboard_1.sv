
class cordic_scoreboard_1 extends uvm_scoreboard;
  `uvm_component_utils(cordic_scoreboard_1)

  uvm_analysis_imp_in  #(cordic_seq_item, cordic_scoreboard_1) port_in;
  uvm_analysis_imp_out #(cordic_seq_item, cordic_scoreboard_1) port_out;

  cordic_seq_item eq[$];

  bit [7:0] input_byte_queue[$];
  int byte_count = -1;
  bit input_mode;

  bit [7:0] output_byte_queue[$];
  int out_byte_count = 0;


  function new(string name = "cordic_scoreboard_1",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    port_in  = new("port_in", this);
    port_out = new("port_out", this);
  endfunction



  virtual function void write_in(cordic_seq_item tx);

    cordic_seq_item exp_tx;
    bit [15:0] data_in;

    // Detect START and capture mode
    if (tx.START == 1'b1) begin

      input_byte_queue.delete();
      byte_count = 0;
      input_mode = tx.ANG_MUL;

      return;
    end

    if (byte_count >= 0 && byte_count < 2) begin

      input_byte_queue.push_back(tx.DATA_IN);
      byte_count++;


      if (byte_count == 2) begin

        data_in = {input_byte_queue[1],
                   input_byte_queue[0]};

        // Clone the monitor transaction
        if (!$cast(exp_tx, tx.clone()))
          `uvm_fatal("SCB", "Transaction cloning failed")

        exp_tx.ANG_MUL = input_mode;
        exp_tx.payload_in = data_in;
        exp_tx.payload_out = '0;

        if (input_mode == 1'b1) begin

          calc_ang(
            exp_tx.payload_in,
            exp_tx.payload_out[15:0],
            exp_tx.payload_out[31:16]
          );

        end
        else begin

          calc_mul(
            exp_tx.payload_in,
            exp_tx.payload_out[15:0]
          );

        end

        eq.push_back(exp_tx);
        byte_count = -1;

      end
    end

  endfunction


  virtual function void write_out(cordic_seq_item tx);

    cordic_seq_item exp_tx;

    bit signed [15:0] act_product;
    bit signed [15:0] act_cos;
    bit signed [15:0] act_sin;

    int cos_diff;
    int sin_diff;
    int required_bytes;

    if (tx.DONE == 1'b0) begin

      output_byte_queue.delete();
      out_byte_count = 0;

      return;
    end

    // Check expected queue
    if (eq.size() == 0) begin

      if (out_byte_count == 0)
        `uvm_error("SCB",
          "Output received but expected queue is empty!")

      return;
    end

    if (eq[0].ANG_MUL == 1'b1)
      required_bytes = 4;
    else
      required_bytes = 2;

    if (out_byte_count < required_bytes) begin

      output_byte_queue.push_back(tx.DATA_OUT);
      out_byte_count++;

      if (out_byte_count == required_bytes) begin

        exp_tx = eq.pop_front();

        // -----------------------------------------------
        // ANGLE MODE
        // -----------------------------------------------

        if (exp_tx.ANG_MUL == 1'b1) begin

          act_cos = {output_byte_queue[1],
                     output_byte_queue[0]};

          act_sin = {output_byte_queue[3],
                     output_byte_queue[2]};

          // Calculate differences
          cos_diff = int'($signed(act_cos)) -
                     int'($signed(exp_tx.payload_out[15:0]));

          sin_diff = int'($signed(act_sin)) -
                     int'($signed(exp_tx.payload_out[31:16]));

          if (cos_diff < 0)
            cos_diff = -cos_diff;

          if (sin_diff < 0)
            sin_diff = -sin_diff;

          `uvm_info("SCB_COMPARE",
            $sformatf(
              "COS: EXP=%0d ACT=%0d DIFF=%0d | SIN: EXP=%0d ACT=%0d DIFF=%0d",
              $signed(exp_tx.payload_out[15:0]),
              act_cos,
              cos_diff,
              $signed(exp_tx.payload_out[31:16]),
              act_sin,
              sin_diff
            ),
            UVM_LOW)

          if (cos_diff <= 11 && sin_diff <= 11) begin

            `uvm_info("SCB_PASS",
              "ANGLE OUTPUT MATCHED",
              UVM_LOW)

          end
          else begin

            `uvm_error("SCB_FAIL",
              $sformatf(
                "ANGLE MISMATCH | COS DIFF=%0d SIN DIFF=%0d",
                cos_diff, sin_diff
              ))

          end

        end

        // -----------------------------------------------
        // MULTIPLICATION MODE
        // -----------------------------------------------

        else begin

          act_product = {output_byte_queue[1],
                         output_byte_queue[0]};

          if (exp_tx.payload_out[15:0] !== act_product) begin

            `uvm_error("SCB_FAIL",
              $sformatf(
                "MULT MISMATCH | OPA=%0d OPB=%0d EXP=%0d ACT=%0d",
                $signed(exp_tx.payload_in[7:0]),
                $signed(exp_tx.payload_in[15:8]),
                $signed(exp_tx.payload_out[15:0]),
                act_product
              ))

          end
          else begin

            `uvm_info("SCB_PASS",
              $sformatf(
                "MULT MATCH | OPA=%0d OPB=%0d RESULT=%0d",
                $signed(exp_tx.payload_in[7:0]),
                $signed(exp_tx.payload_in[15:8]),
                act_product
              ),
              UVM_LOW)

          end

        end

      end
    end

  endfunction


  // --------------------------------------------------------
  // MULTIPLICATION CALCULATION
  // --------------------------------------------------------

  function void calc_mul(
    input bit [15:0] data_in,
    output bit signed [15:0] data_out
  );

    bit signed [7:0] opa;
    bit signed [7:0] opb;

    opa = data_in[7:0];
    opb = data_in[15:8];
    data_out = opa * opb;

  endfunction


  // --------------------------------------------------------
  // ANGLE CALCULATION
  // --------------------------------------------------------

  function void calc_ang(
    input bit [15:0] data_in,
    output bit signed [15:0] cos_out,
    output bit signed [15:0] sin_out
  );

    real pi = $acos(-1.0);
    real angle_radians;
    real ideal_cos;
    real ideal_sin;

    // Convert angle to radians
    angle_radians = (real'(data_in) / 65536.0) *
                    2.0 * pi;

    // Calculate ideal cosine and sine
    ideal_cos = $cos(angle_radians);
    ideal_sin = $sin(angle_radians);

    // Convert to signed Q1.14
    cos_out = $rtoi(ideal_cos * 16384.0);
    sin_out = $rtoi(ideal_sin * 16384.0);

  endfunction

endclass
