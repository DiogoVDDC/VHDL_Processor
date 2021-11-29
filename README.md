# VHDL Processor

Implemented CPU to be programmed on FPGA board. 

The CPU followed the following finite state machine:

![alt text](https://github.com/DiogoVDDC/VHDL_Processor/blob/master/CPU_FSM.png)

During FETCH1 and FETCH2, the CPU reads the next instruction to execute. 

During DECODE, the CPU identifies the instruction and determine the next state.

There exist multiple different execute stages depending on the instruction type:

LOAD: For a load instruction
STORE: For a store instruction
I-OP: For a I-type instruction (instruction which uses an immediate value as one of it's operands)
R-OP: For a R-type instruction (instruction which uses only registers value as it's operands)
BREAK: Simply stops the CPU
