class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

class yapp_1_seq extends yapp_base_seq ;
  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "", UVM_LOW);
    `uvm_do_with(req, {addr == 1;})
  endtask

endclass: yapp_1_seq

class yapp_012_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction

  task body();
    int ok;
    `uvm_info(get_type_name(), "", UVM_LOW)
    `uvm_do_with(req, {addr == 0;})
    `uvm_do_with(req, {addr == 1;})
    start_item(req);
    req.sel = 1;
    ok = req.randomize() with {addr == 2;};
    finish_item(req);
    // `uvm_do_with(req, {addr == 2;})
  endtask
endclass: yapp_012_seq

class yapp_111_seq extends yapp_base_seq;
    `uvm_object_utils(yapp_111_seq)

    function new(string name = "yapp_111_seq");
      super.new(name);
    endfunction

    yapp_1_seq ysa;

    task body();
    `uvm_info(get_type_name, "", UVM_LOW)
    `uvm_do(ysa)
    `uvm_do(ysa)
    `uvm_do(ysa)
    endtask

endclass: yapp_111_seq

class yapp_repeat_addr_seq extends yapp_base_seq;
    `uvm_object_utils(yapp_repeat_addr_seq)

    function new(string name = "yapp_repeat_addr_seq");
      super.new(name);
    endfunction

    task body();
      int prev_addr;
      // int ok;
      `uvm_info(get_type_name(), "" , UVM_LOW)
      `uvm_do_with(req, {addr != 3;})
      // start_item(req);
      // ok = req.randomize() with {addr != 3;};
      prev_addr = req.addr;
      // finish_item(req);
      `uvm_do_with(req, {addr == prev_addr;})
    endtask

endclass: yapp_repeat_addr_seq

class yapp_incr_payload_seq extends yapp_base_seq;
    `uvm_object_utils(yapp_incr_payload_seq)

    function new(string name = "yapp_incr_payload_seq");
      super.new(name);
    endfunction

    task body();
      `uvm_info(get_type_name(), "" , UVM_LOW)
      // yapp_packet pkt;
      `uvm_create(req)
      if(!req.randomize()) begin
        `uvm_error(get_type_name(), "Randomization Failed")
        return;
      end
      req.payload = new[req.length];
      foreach (req.payload[i])
        req.payload[i] = i ;

      req.set_parity();
      `uvm_send(req)
    endtask

endclass: yapp_incr_payload_seq


class yapp_rnd_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_rnd_seq)

  function new(string name = "yapp_rnd_seq");
    super.new(name);
  endfunction

  rand int count;
  // constraint cont {
  //   count inside {[1:10]};
  // }
  task body();
    int ok;
    `uvm_info(get_type_name(), "" , UVM_LOW)
    ok = randomize() with {count inside {[1:10]};};
    `uvm_info("count", $sformatf("count value is %0d", count), UVM_HIGH)
    repeat(count) begin
      `uvm_do(req)
    end
  endtask
endclass: yapp_rnd_seq

class six_yapp_seq extends yapp_base_seq;
  `uvm_object_utils(six_yapp_seq)

  function new(string name = "six_yapp_seq");
    super.new(name);
  endfunction

  yapp_rnd_seq rand_seq;

  task body();
    `uvm_info(get_type_name(), "" , UVM_LOW)
    `uvm_do_with(rand_seq, {count == 6;})
  endtask

endclass

class yapp_exhaustive_seq extends yapp_base_seq;
    `uvm_object_utils(yapp_exhaustive_seq)

    function new(string name = "yapp_exhaustive_seq");
      super.new(name);
    endfunction
    yapp_1_seq ysa1;
    yapp_012_seq ysa2;
    yapp_111_seq ysa3;
    yapp_repeat_addr_seq ysa4;
    yapp_incr_payload_seq ysa5;
    yapp_rnd_seq ysa6;
    six_yapp_seq ysa7;

    task body();
      `uvm_info(get_type_name(), "yapp_exhaustive_seq running....." , UVM_LOW)
      `uvm_do(ysa1)
      `uvm_do(ysa2)
      `uvm_do(ysa3)
      `uvm_do(ysa4)
      `uvm_do(ysa5)
      `uvm_do(ysa6)
      `uvm_do(ysa7)
    endtask

endclass: yapp_exhaustive_seq



