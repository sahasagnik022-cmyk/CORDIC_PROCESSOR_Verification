class seq_dir_mult_zero extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_zero)

  cordic_seq_item req;

  function new(string name="seq_dir_mult_zero");
    super.new(name);
  endfunction
  
  task body();
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==16'h0000;});
      finish_item(req);
  endtask
  
endclass
