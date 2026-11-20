`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class cordic_scoreboard_1 extends uvm_scoreboard;
    `uvm_component_utils(cordic_scoreboard_1)

    uvm_analysis_imp_in  #(cordic_seq_item, cordic_scoreboard_1) port_in;
    uvm_analysis_imp_out #(cordic_seq_item, cordic_scoreboard_1) port_out;

    cordic_seq_item eq[$];

    int byte_count = 0;
    int out_byte_count = 0;

    function new(string name="cordic_scoreboard_1", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port_in = new("port_in",this);
        port_out = new("port_out",this);
    endfunction

    // INPUT MONITOR
    virtual function void write_in(cordic_seq_item tx);

        cordic_seq_item exp_tx;

        if(tx.START == 1'b1) begin
            if(!$cast(exp_tx,tx.clone()))
                `uvm_fatal("SCB","Cloning failed")

            exp_tx.payload_in  = '0;
            exp_tx.payload_out = '0;
            eq.push_back(exp_tx);
            byte_count = 1;

        end

        else if(byte_count == 1) begin
            eq[$].payload_in[7:0] = tx.DATA_IN;
            byte_count = 2;
        end

        else if(byte_count == 2) begin
            eq[$].payload_in[15:8] = tx.DATA_IN;
            byte_count = 0;
        end
    endfunction


    // OUTPUT MONITOR
    virtual function void write_out(cordic_seq_item tx);
        int required_bytes;
        int cos_diff;
        int sin_diff;
        bit signed [15:0] exp_product;
        bit signed [15:0] exp_cos;
        bit signed [15:0] exp_sin;
        bit signed [15:0] act_product;
        bit signed [15:0] act_cos;
        bit signed [15:0] act_sin;

        if(tx.DONE == 1'b0) begin
            out_byte_count = 0;
            return;
        end

        if(eq.size() == 0) begin
            `uvm_error("SCB","Received output but expected queue is empty")
            return;
        end

        if(eq[0].ANG_MUL == 1'b1)
            required_bytes = 4;
        else
            required_bytes = 2;

        // COLLECT OUTPUT BYTES
        if(out_byte_count == 0)
            eq[0].payload_out[7:0] = tx.DATA_OUT;

        else if(out_byte_count == 1)
            eq[0].payload_out[15:8] = tx.DATA_OUT;

        else if(out_byte_count == 2)
            eq[0].payload_out[23:16] = tx.DATA_OUT;

        else if(out_byte_count == 3)
            eq[0].payload_out[31:24] = tx.DATA_OUT;

        out_byte_count++;


        if(out_byte_count == required_bytes) begin
          
            // ANGLE MODE
            if(eq[0].ANG_MUL == 1'b1) begin
                calc_ang(eq[0].payload_in,exp_cos,exp_sin);
                act_cos = eq[0].payload_out[15:0];
                act_sin = eq[0].payload_out[31:16];
              
                cos_diff = (int'(act_cos) > int'(exp_cos)) ?
                           (int'(act_cos) - int'(exp_cos)) :
                           (int'(exp_cos) - int'(act_cos));

                sin_diff = (int'(act_sin) > int'(exp_sin)) ?
                           (int'(act_sin) - int'(exp_sin)) :
                           (int'(exp_sin) - int'(act_sin));


                if(cos_diff <= 11 && sin_diff <= 11) begin
                    `uvm_info("SCB_PASS",
                        $sformatf("ANGLE MATCH: COS(Exp:%0d, Act:%0d) SIN(Exp:%0d, Act:%0d)",
                        exp_cos,act_cos,exp_sin,act_sin),UVM_LOW)
                end
                else begin
                    `uvm_error("SCB_FAIL",
                        $sformatf("ANGLE MISMATCH: COS(Exp:%0d, Act:%0d, Diff:%0d) SIN(Exp:%0d, Act:%0d, Diff:%0d)",
                        exp_cos,act_cos,cos_diff,exp_sin,act_sin,sin_diff))
                end
            end

            // MULTIPLICATION MODE

            else begin
                calc_mul(eq[0].payload_in,exp_product);
                act_product = eq[0].payload_out[15:0];
              
                if(exp_product !== act_product) begin
                    `uvm_error("SCB_FAIL",
                        $sformatf("MULT MISMATCH (OPA=%0d) x (OPB=%0d): Exp:%0d, Act:%0d",
                        $signed(eq[0].payload_in[7:0]),
                        $signed(eq[0].payload_in[15:8]),
                        exp_product,act_product))
                end

                else begin
                    `uvm_info("SCB_PASS",
                        $sformatf("MULT MATCH (OPA=%0d) x (OPB=%0d): %0d",
                        $signed(eq[0].payload_in[7:0]),
                        $signed(eq[0].payload_in[15:8]),
                        act_product),UVM_LOW)
                end
            end

            eq.pop_front();
            out_byte_count = 0;
        end
    endfunction


    // MULTIPLICATION CALCULATION
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


    // ANGLE CALCULATION
    function void calc_ang(
        input bit [15:0] data_in,
        output bit signed [15:0] cos_out,
        output bit signed [15:0] sin_out
    );

        real pi = $acos(-1.0);
        real angle_radians;
        real ideal_cos;
        real ideal_sin;

        angle_radians = (real'(data_in) / 65536.0) * 2.0 * pi;

        ideal_cos = $cos(angle_radians);
        ideal_sin = $sin(angle_radians);
      
        cos_out = $rtoi(ideal_cos * 16384.0);
        sin_out = $rtoi(ideal_sin * 16384.0);

    endfunction

endclass
