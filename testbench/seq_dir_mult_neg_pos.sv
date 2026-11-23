class seq_dir_mult_neg_pos extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_neg_pos)

  cordic_seq_item req;

  function new(string name="seq_dir_mult_neg_pos");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==16'h7F80;});
      finish_item(req);
    end
  endtask
  
endclass
