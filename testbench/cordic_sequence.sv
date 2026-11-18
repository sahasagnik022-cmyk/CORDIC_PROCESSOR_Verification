class cordic_sequence extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(cordic_sequence)

  cordic_seq_item req;

  function new(string name="cordic_sequence");
    super.new(name);
    endfunction
  
  task body();
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
    assert(req.randomize() with {payload_in inside {16'h0001};});
      finish_item(req);
  endtask
  
endclass



//ANGLE MODE SANITY SEQUENCE
class seq_angle_mode extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_angle_mode)

  cordic_seq_item req;

  function new(string name="seq_angle_mode");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1;});
      finish_item(req);
    end
  endtask
  
endclass


//MUL MODE SANITY
class seq_mult_mode extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_mult_mode)

  cordic_seq_item req;

  function new(string name="seq_mult_mode");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0;});
      finish_item(req);
    end
  endtask
  
endclass


//ANGLE 0 DIRECTED
class seq_dir_angle_0_deg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_angle_0_deg)

  cordic_seq_item req;

  function new(string name="seq_dir_angle_0_deg");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1; payload_in==16'h0000;});
      finish_item(req);
    end
  endtask
  
endclass


//ANGLE 90 DIRECTED
class seq_dir_angle_90_deg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_angle_90_deg)

  cordic_seq_item req;

  function new(string name="seq_dir_angle_90_deg");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1; payload_in==16'h4000;});
      finish_item(req);
    end
  endtask
  
endclass


//ANGLE 180 DIRECTED
class seq_dir_angle_180_deg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_angle_180_deg)

  cordic_seq_item req;

  function new(string name="seq_dir_angle_180_deg");
    super.new(name);
  endfunction

  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1; payload_in==16'h8000;});
      finish_item(req);
    end
  endtask

endclass


//ANGLE 270 DIRECTED
class seq_dir_angle_270_deg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_angle_270_deg)

  cordic_seq_item req;

  function new(string name="seq_dir_angle_270_deg");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1; payload_in==16'hC000;});
      finish_item(req);
    end
  endtask
  
endclass


//ANGLE MAX DIRECTED
class seq_dir_angle_max_value extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_angle_max_value)

  cordic_seq_item req;

  function new(string name="seq_dir_angle_max_value");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1; payload_in==16'hFFFF;});
      finish_item(req);
    end
  endtask
  
endclass


//MUL NEG NEG DIRECTED
class seq_dir_mult_neg_neg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_neg_neg)

  cordic_seq_item req;

  function new(string name="seq_dir_mult_neg_neg");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==16'h4000;});
      finish_item(req);
    end
  endtask
  
endclass


//MUL POS NEG DIRECTED
class seq_dir_mult_pos_neg extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_pos_neg)

  cordic_seq_item req;

  function new(string name="seq_dir_mult_pos_neg");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==16'h807F;});
      finish_item(req);
    end
  endtask
  
endclass


//MUL ZERO DIRECTED
class seq_dir_mult_zero extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_dir_mult_zero)

  cordic_seq_item req;

  function new(string name="seq_dir_mult_zero");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in==16'h0000;});
      finish_item(req);
    end
  endtask
  
endclass


//RAND ANGLE MODE FULL SWEEP
class seq_rand_angle_full_sweep extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_rand_angle_full_sweep)

  cordic_seq_item req;

  function new(string name="seq_rand_angle_full_sweep");
    super.new(name);
  endfunction
  
  task body();
    repeat(2000) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==1; payload_in inside {[16'h0000:16'hFFFF]};});
      finish_item(req);
    end
  endtask
  
endclass


//RAND MULT MODE FULL SWEEP
class seq_rand_mult_full_sweep extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_rand_mult_full_sweep)

  cordic_seq_item req;

  function new(string name="seq_rand_mult_full_sweep");
    super.new(name);
  endfunction
  
  task body();
    repeat(5) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {ANG_MUL==0; payload_in inside {[16'h0000:16'hFFFF]};});
      finish_item(req);
    end
  endtask
  
endclass


//RAND MIXED MODE BACK TO BACK
class seq_rand_mixed_mode_back_to_back extends uvm_sequence #(cordic_seq_item);
  `uvm_object_utils(seq_rand_mixed_mode_back_to_back)

  cordic_seq_item req;

  function new(string name="seq_rand_mixed_mode_back_to_back");
    super.new(name);
    endfunction
  
  task body();
    repeat(10) begin
      req = cordic_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {payload_in inside {[16'h0000:16'hFFFF]};});
      finish_item(req);
    end
  endtask
  
endclass

