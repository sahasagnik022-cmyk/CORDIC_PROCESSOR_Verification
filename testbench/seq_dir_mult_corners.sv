class seq_dir_mult_corners extends uvm_sequence#(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_corners)

  function new(string name="seq_dir_mult_corners");
    super.new(name);
  endfunction

  task body();
    req = cordic_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { ANG_MUL == 1'b0; payload_in[7:0] == 8'h00; payload_in[15:8] == 8'h7F; });
    finish_item(req);
    req = cordic_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { ANG_MUL == 1'b0; payload_in[7:0] == 8'h00; payload_in[15:8] == 8'h80; });
    finish_item(req);
    req = cordic_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { ANG_MUL == 1'b0; payload_in[7:0] == 8'h7F; payload_in[15:8] == 8'h7F; });
    finish_item(req);
    req=cordic_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { ANG_MUL == 1'b0; payload_in[7:0] == 8'h80;payload_in[15:8] == 8'h7F;});
    finish_item(req);
  endtask
endclass
