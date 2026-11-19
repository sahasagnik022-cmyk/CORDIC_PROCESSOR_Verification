class seq_dir_mult_pos_neg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_pos_neg)

  cordic_seq_item req;

  function new(string name="seq_dir_mult_pos_neg");
    super.new(name);
  endfunction
  
  task body();
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==16'h807F;});
      finish_item(req);
  endtask
  
endclass
