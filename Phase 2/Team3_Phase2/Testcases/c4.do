vsim -gui work.pdp
mem load -i {c4.mem} /pdp/RAM_PORTMAP/ram
add wave  \
-radix binary sim:/pdp/CLK \
sim:/pdp/RST \
-radix hexadecimal sim:/pdp/PDP_BUS \
sim:/pdp/Z \
sim:/pdp/Y \
sim:/pdp/R0 \
sim:/pdp/R1 \
sim:/pdp/R2 \
sim:/pdp/R3 \
sim:/pdp/R4 \
sim:/pdp/R5 \
sim:/pdp/SP \
sim:/pdp/PC \
sim:/pdp/IR \
sim:/pdp/MAR \
sim:/pdp/MDR \
sim:/pdp/TEMP \
-radix octal sim:/pdp/DECODER_PORTMAP/PLA/MICRO_PC \
-radix binary sim:/pdp/FLAG\
sim:/pdp/GENERAL_REGISTERS_IN \
sim:/pdp/GENERAL_REGISTERS_OUT\
sim:/pdp/PC_OUT \
sim:/pdp/MDR_OUT \
sim:/pdp/Z_OUT \
sim:/pdp/TEMP_OUT \
sim:/pdp/PC_IN \
sim:/pdp/Z_IN \
sim:/pdp/TEMP_IN \
sim:/pdp/MDR_IN \
sim:/pdp/MAR_IN \
sim:/pdp/Y_IN \
sim:/pdp/IR_IN \
sim:/pdp/READ_MEM \
sim:/pdp/WRITE_MEM \
sim:/pdp/CLEAR_Y\
sim:/pdp/RAM_TO_MDR\
sim:/pdp/MDR_SELECTOR\
sim:/pdp/ALU_OPERATION



force -freeze Clk 0 0, 1 {50 ps} -r 100

force Rst 1
run 30

force Rst 0

run 20000
