# VHDL Processor

Implemented CPU to be programmed on FPGA board. 

The CPU followed the following finite state machine:

![alt text](https://github.com/DiogoVDDC/VHDL_Processor/blob/master/CPU_FSM.png)

During FETCH1 and FETCH2, the CPU reads the next instruction to execute. 
During DECODE, the CPU identifies the instruction and determine the next state.

