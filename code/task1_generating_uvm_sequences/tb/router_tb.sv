class router_tb extends uvm_env;
    `uvm_component_utils(router_tb)
    yapp_env YAPP;

    function new(string name = "router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // YAPP = new("YAPP", this);
        YAPP = yapp_env::type_id::create("YAPP", this);
        `uvm_info("BUILD_PHASE", "Build phase of the testbench is being executed", UVM_HIGH)
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Running Simulation...", UVM_HIGH);
    endfunction

endclass