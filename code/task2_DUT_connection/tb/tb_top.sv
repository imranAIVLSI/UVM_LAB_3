module tb_top;
// import the UVM library
// include the UVM macros
import uvm_pkg::*;
`include "uvm_macros.svh"
// import the YAPP package
import yapp_pkg::*;
`include "router_tb.sv"
`include "router_test_lib.sv"
// generate 5 random packets and use the print method
// to display the results

initial begin
   yapp_vif_config::set(null, "uvm_test_top.tb.YAPP.*", "vif", hw_top.in0);
   run_test();
   end
// experiment with the copy, clone and compare UVM method
endmodule : top
