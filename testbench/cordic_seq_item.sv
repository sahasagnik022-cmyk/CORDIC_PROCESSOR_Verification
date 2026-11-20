class cordic_seq_item extends uvm_sequence_item;
  `uvm_object_utils(cordic_seq_item)
  rand bit [15:0] payload_in;
  rand bit ANG_MUL;
  rand bit [3:0] delay_start;
  bit [31:0] payload_out;
  bit is_reset;
  
  function new(string name="cordic_seq_item");
    super.new(name);
  endfunction
  
  virtual function void do_copy(uvm_object rhs);
    cordic_seq_item rhs_;
    if(!$cast(rhs_, rhs)) begin
      `uvm_fatal("SEQ_ITEM", "Cast unsuccessful - Wrong object type");
    end
    super.do_copy(rhs);
    this.payload_in  = rhs_.payload_in;
    this.ANG_MUL     = rhs_.ANG_MUL;
    this.payload_out = rhs_.payload_out;
    this.delay_start = rhs_.delay_start;
    this.is_reset = rhs_.is_reset;
  endfunction

  constraint start_delay{
   soft delay_start inside {[4'd0:4'd15]};
  }
  
endclass
