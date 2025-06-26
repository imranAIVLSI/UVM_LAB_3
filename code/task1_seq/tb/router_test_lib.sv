class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    function new (string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    router_tb tb;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(this, "*", "recording_detail", 1);
         uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());
        // tb = new("tb", this);
        tb = router_tb::type_id::create("tb", this);
        `uvm_info("BUILD_PHASE", "Build Phase of Testbench is being executed", UVM_HIGH);
    endfunction

    function void check_phase(uvm_phase phase);
        super.connect_phase(phase);
        check_config_usage();
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass

class test2 extends base_test;
    `uvm_component_utils(test2)

    function new(string name = "test2", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new(string name = "short_packet_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        super.build_phase(phase);
    endfunction

endclass: short_packet_test

class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new(string name = "set_config_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        // uvm_config_int::set(this,"tb.YAPP.agent", "is_active", UVM_PASSIVE);
        super.build_phase(phase);
    endfunction
endclass: set_config_test