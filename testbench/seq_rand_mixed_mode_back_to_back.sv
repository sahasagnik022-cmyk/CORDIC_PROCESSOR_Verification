class seq_rand_mixed_mode_back_to_back extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_rand_mixed_mode_back_to_back)

  cordic_seq_item req;

  function new(string name="seq_rand_mixed_mode_back_to_back");
    super.new(name);
    endfunction

  task body();
      repeat(20) begin
        req = cordic_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
      end
  endtask

endclass
