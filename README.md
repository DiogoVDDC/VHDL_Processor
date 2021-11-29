# VHDL Processor

Done by Diogo Valdivieso Damasio Da Costa & Théo Houle

Implemented basic CPU (not pipelined) to be programmed on FPGA board. 

The CPU followed the following finite state machine:

![alt text](https://github.com/DiogoVDDC/VHDL_Processor/blob/master/CPU_FSM.png)

During FETCH1 and FETCH2, the CPU reads the next instruction to execute. 

During DECODE, the CPU identifies the instruction and determine the next state.

There exist multiple different execute stages depending on the instruction type:

1) LOAD: For a load instruction
2) STORE: For a store instruction
3) I-OP: For a I-type instruction (instruction which uses an immediate value as one of it's operands)
4) R-OP: For a R-type instruction (instruction which uses only registers value as it's operands)
5) BREAK: Simply stops the CPU

The main VHDL file follow the following structure:

![alt text](https://github.com/DiogoVDDC/VHDL_Processor/blob/master/CPU_Main_design.png)
