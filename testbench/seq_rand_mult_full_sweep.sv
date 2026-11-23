class seq_rand_mult_full_sweep extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_rand_mult_full_sweep)

  cordic_seq_item req;

  function new(string name="seq_rand_mult_full_sweep");
    super.new(name);
  endfunction
  
  task body();
    for(int i=0;i<1000;i++) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==i;});
      finish_item(req);
    end
  endtask
  
endclass
