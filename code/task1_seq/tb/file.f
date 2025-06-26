// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d

// include directories
//*** add incdir include directories here
// -uvmhome $UVMHOME
-incdir ../sv 
-incdir .
// compile files

../sv/yapp_pkg.sv
// ../sv/yapp_packet.sv
top.sv
+UVM_TESTNAME=set_config_test
+UVM_VERBOSITY=UVM_HIGH
//*** add compile files here

