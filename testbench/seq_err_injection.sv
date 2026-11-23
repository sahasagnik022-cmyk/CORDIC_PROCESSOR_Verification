class seq_err_injection extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_err_injection)

  cordic_seq_item req;

  function new(string name="seq_err_injection");
    super.new(name);
  endfunction

  task body();
      repeat(10) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {payload_in inside {[16'h1111:16'h2222]}; delay_start inside {[1:15]};});
      finish_item(req);
      end
  endtask

endclass
