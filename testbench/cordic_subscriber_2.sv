class cordic_subscriber_2 extends uvm_subscriber #(cordic_seq_item);
  `uvm_component_utils(cordic_subscriber_2)

  cordic_seq_item req;
  int byte_count = 0;
  bit [15:0] assembled_payload;
  bit current_ang_mul;

  covergroup in_cg;
    option.per_instance = 1;

    cp_angle_quadrants: coverpoint req.payload_in[15:14] iff(req.ANG_MUL){
      bins quadrants[]={2'b00,2'b01,2'b10,2'b11};
    }

    cp_angle_boundaries: coverpoint req.payload_in iff(req.ANG_MUL){
      bins angle_zero={16'h0000};
      bins angle_ninety={16'h4000};
      bins angle_one_eighty={16'h8000};
      bins angle_two_seventy={16'hC000};
      bins angle_max={16'hFFFF};
    }

    cp_operand_a: coverpoint req.payload_in[7:0] iff(!req.ANG_MUL){
      bins opa_zero={8'h00};
      bins opa_more_zero={[8'h01:8'h7F]};
      bins opa_less_than_zero={[8'h80:8'hFF]};
      bins opa_neg_max={8'h80};
      bins opa_pos_max={8'h7F};
    }

    cp_operand_b: coverpoint req.payload_in[15:8] iff(!req.ANG_MUL){
      bins opb_zero={8'h00};
      bins opb_more_zero={[8'h01:8'h7F]};
      bins opb_less_than_zero={[8'h80:8'hFF]};
      bins opb_neg_max={8'h80};
      bins opb_pos_max={8'h7F};
    }

    cp_ang_mul_mode: coverpoint req.ANG_MUL{
      bins angle_mode={1};
      bins mul_mode={0};
    }

    cross_op_sign_ab: cross cp_operand_a, cp_operand_b iff(!req.ANG_MUL){
      bins pos_pos=binsof(cp_operand_a.opa_more_zero) && binsof(cp_operand_b.opb_more_zero);
      bins pos_neg=binsof(cp_operand_a.opa_more_zero) && binsof(cp_operand_b.opb_less_than_zero);
      bins neg_pos=binsof(cp_operand_a.opa_less_than_zero) && binsof(cp_operand_b.opb_more_zero);
      bins neg_neg=binsof(cp_operand_a.opa_less_than_zero) && binsof(cp_operand_b.opb_less_than_zero);
    }
  endgroup

  function new(string name="cordic_subscriber", uvm_component parent=null);
    super.new(name,parent);
    in_cg = new();
    req = cordic_seq_item::type_id::create("req");
  endfunction

  function void write(cordic_seq_item t);
    if (t.is_reset) begin
      byte_count = 0;
      return;
    end

    if (t.START == 1'b1) begin
      byte_count = 1;
      current_ang_mul = t.ANG_MUL;
    end
    else if (byte_count == 1) begin
      assembled_payload[7:0] = t.DATA_IN;
      byte_count = 2;
    end
    else if (byte_count == 2) begin
      assembled_payload[15:8] = t.DATA_IN;
      byte_count = 0;

      this.req.payload_in = assembled_payload;
      this.req.ANG_MUL = current_ang_mul;
      in_cg.sample();
    end
  endfunction

endclass
