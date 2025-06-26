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
  `uvm_object_utils(single_packet_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "", UVM_LOW);
    `uvm_do_with(req, {addr == 1;})
  endtask

endclass: yapp_1_seq

class yapp_012 extends yapp_base_seq;
  `uvm_object_utils(yapp_012)

  function new(string name = "yapp_012");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "", UVM_LOW)
    `uvm_do_with(req, {addr == 1;})
    `uvm_do_with(req, {addr == 0;})
    `uvm_do_with(req, {addr == 2;})
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
    int prev_addr;
    task body();
      `uvm_info(get_type_name(), "" , UVM_LOW)
      start_item(req);
      req.randomize() with {addr != 3;};
      prev_addr = req.addr;
      finish_item(req);
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
      yapp_packet = pkt;
      `uvm_create(pkt)
      if(!pkt.randomize()) begin
        `uvm_error(get_type_name(), "Randomization Failed")
        return;
      end
      pkt.payload = new[pkt.length];
      foreach (pkt.payload[i])
        pkt.payload[i] = i ;

      pkt.set_parity();
      `uvm_send(pkt)
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

    task body();
      `uvm_info(get_type_name(), "" , UVM_LOW)
      `uvm_do(ysa1)
      `uvm_do(ysa2)
      `uvm_do(ysa3)
      `uvm_do(ysa4)
      `uvm_do(ysa5)
    endtask

endclass

