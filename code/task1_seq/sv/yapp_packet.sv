// Define your enumerated type(s) here
typedef enum bit {GOOD_PARITY, BAD_PARITY  } parity_type_e;
class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:

  // Define protocol data
  rand bit [5:0] length;
  rand bit [1:0] addr;
  rand bit [7:0] payload[];
  bit [7:0] parity;
  rand parity_type_e parity_type;
  rand int packet_delay;

  `uvm_object_utils_begin(yapp_packet)
  `uvm_field_array_int(payload, UVM_ALL_ON)
  `uvm_field_int(parity, UVM_ALL_ON + UVM_BIN)
  `uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON)
  `uvm_field_int(packet_delay, UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new(string name = "yapp_packet");
    super.new(name);
  endfunction

  
  // Define control knobs

  function void set_parity();
    if(parity_type == GOOD_PARITY) begin
        parity = calc_parity();
    end
    else
      parity = ~(parity);
  endfunction
  // Enable automation of the packet's fields

  // Define packet constraints
  constraint rand_addr {addr inside {[0:2]};}
  constraint pakt_length {length inside {[1:63]};}
  constraint size_eq_length { payload.size() == length;}
  constraint p_type { parity_type dist { GOOD_PARITY:=5, BAD_PARITY:=1 };}
  constraint delay { packet_delay inside {[1:20]};}
  // Add methods for parity calculation and class construction
  function bit [7:0] calc_parity();
    parity = 8'b00;
    foreach(payload[i]) begin
      parity ^= payload[i];
    end
    return parity;
  endfunction

  function void post_randomization();
    set_parity();
  endfunction


endclass: yapp_packet


class short_yapp_packet extends yapp_packet;
  `uvm_object_utils(short_yapp_packet)

  function new(string name = "short_yapp_packet");
    super.new(name);
  endfunction

  constraint leng {length < 15;}
  constraint no2 {addr != 2; }


endclass: short_yapp_packet
