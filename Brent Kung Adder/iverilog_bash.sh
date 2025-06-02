iverilog -g2012 -o bk_32b.vvp bk_32b_testbench.sv bk_adder_32b.sv
vvp bk_32b.vvp
gtkwave bk_32b_test.vcd
#gtkwave -T add_all.tcl
