// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d
-timescale 1ns/1ns
// include directories
//*** add incdir include directories here
// -uvmhome $UVMHOME
-incdir ../sv 
-incdir .
// compile files

../sv/yapp_pkg.sv
// ../sv/yapp_packet.sv
../sv/yapp_if.sv
clkgen.sv
yapp_router.sv
hw_top_no_dut.sv
tb_top.sv
+UVM_TESTNAME=new_test012
+UVM_VERBOSITY=UVM_HIGH
+SVSEED=random
//*** add compile files here

