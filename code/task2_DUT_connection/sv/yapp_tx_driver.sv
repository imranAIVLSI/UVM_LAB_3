class yapp_tx_driver extends uvm_driver #(yapp_packet);
    `uvm_component_utils(yapp_tx_driver)

    virtual yapp_if vif;
    int num_sent;

    function new(string name = "yapp_tx_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fork
            get_and_drive();
            reset_signals();
        join
    endtask

    task get_and_drive();
        @(posedge vif.reset);
        @(negedge vif.reset);
        `uvm_info(get_type_name(), "Reset Dropped", UVM_MEDIUM)
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
            fork
                begin
                    foreach (req.payload[i])
                    vif.payload_mem[i] = req.payload[i];
                    vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
                end
                @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
            join
        end_tr(req);
        num_sent++;
        seq_item_port.item_done();
        end
    endtask

    task reset_signals();
        forever
            vif.yapp_reset();
    endtask

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Running Simulation...", UVM_HIGH)
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: YAPP TX Driver send %0d Packets", num_sent), UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        if(!yapp_vif_config::get(this, "" ,"vif", vif))
        `uvm_error("NOVIF", "vif not set")
    endfunction

endclass