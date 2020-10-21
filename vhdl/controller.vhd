library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is

	type states is (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, LOAD2, I_OP, UI_OP, RI_OP, BRANCH, CALL, CALLR, JMP, JMPI);
	signal state, nextState : states;
begin

	process(clk, reset_n) is
	begin
		if reset_n = '0' then 
			state <= FETCH1;
		elsif rising_edge(clk) then
			case state is 
				when FETCH1 =>
					state <= FETCH2;
				when FETCH2 =>
					state <= DECODE;
				when DECODE =>
					case op is
						when "111010" => -- op = 3A
							case opx is
								when "001110" => -- opx = 0E
									state <= R_OP; 
								when "011011" => -- opx = 1B
									state <= R_OP;
								when "110100" => -- opx = 34
									state <= BREAK;
								when "011101" => -- opx = 1D
									state <= CALLR;
								when "000101" => -- opx = 05
									state <= JMP;
								when "001101" => -- opx = 0D
									state <= JMP;
								when "000110" => -- opx = 06
									state <= R_OP;
								when "001000" => -- opx = 08
									state <= R_OP;
								when "110001" => -- opx = 31	
									state <= R_OP; 
								when "111001" => -- opx = 39
									state <= R_OP;
								when "010000" => -- opx = 10
									state <= R_OP;
								when "010110" => -- opx = 16
									state <= R_OP;
								when "011110" => -- opx = 1E
									state <= R_OP;
								when "010011" => -- opx = 13
									state <= R_OP;
								when "111011" => -- opx = 3B
									state <= R_OP;
								when "000011" => -- opx = 03
									state <= R_OP;
								when "001011" => -- opx = 0B
									state <= R_OP;  
								when "011000" => -- opx = 18
									state <= R_OP;
								when "100000" => -- opx = 20
									state <= R_OP;
								when "101000" => -- opx = 28
									state <= R_OP;
								when "110000" => -- opx = 30
									state <= R_OP;
								when "000010" => -- opx = 02
									state <= RI_OP;
								when "010010" => -- opx = 12
									state <= RI_OP;
								when "011010" => -- opx = 1A
									state <= RI_OP;
								when "111010" => -- opx = 3A
									state <= RI_OP;
								when others =>
									state <= BREAK;
							end case;
						when "000100" => -- op = 04
							state <= I_OP;
						when "010111" => -- op = 17
							state <= LOAD1;
						when "010101" => -- op  = 15
							state <= STORE;
						when "001110" => -- op = 0E
							state <= BRANCH;
						when "010110" => -- op = 16
							state <= BRANCH;
						when "011110" => -- op = 1E
							state <= BRANCH;
						when "100110" => -- op = 26
							state <= BRANCH;
						when "101110" => -- op = 2E
							state <= BRANCH;
						when "110110" => -- op = 36
							state <= BRANCH;
						when "000000" => -- op = 00
							state <= CALL;
						when "000001" => -- op = 01
							state <= JMPI;
						when "001100" => -- op = 0C
						 	state <= UI_OP;
						when "010100" => -- op = 14
							state <= UI_OP; 
						when "011100" => -- op = 1C			
							state <= UI_OP; 
						when "001000" => -- op = 08
							state <= I_OP; 
						when "010000" => -- op = 10
							state <= I_OP; 
						when "011000" => -- op = 18
							state <= I_OP; 
						when "100000" => -- op = 20
							state <= I_OP; 
						when "101000" => -- op = 28
							state <= UI_OP; 
						when "110000" => -- op = 30
							state <= UI_OP; 
						when "000110" => -- op = 06
							state <= BRANCH;
						when others =>	state <= BREAK;
					end case;	

				when I_OP =>	
					state <= FETCH1;
				when UI_OP =>
					state <= FETCH1;					
				when R_OP =>
					state <= FETCH1;
				when STORE =>
					state <= FETCH1;
				when BREAK =>
					state <= BREAK;
				when LOAD1 =>
					state <= LOAD2;
				when LOAD2 =>
					state <= FETCH1;
				when BRANCH =>
					state <= FETCH1;
				when CALL =>
					state <= FETCH1;
				when CALLR =>
					state <= FETCH1;
				when JMP =>
					state <= FETCH1;
				when JMPI =>
					state <= FETCH1;
				when RI_OP =>
					state <= FETCH1;
				when others =>
					state <= BREAK;
			end case;
		end if;
	end process;

	read <= '1' when state = FETCH1 or state = FETCH2 or state = LOAD1 else '0';
	write <= '1' when state = STORE else '0';
	ir_en <= '1' when state = FETCH2 else '0';
	imm_signed <= '1' when state = STORE or state = I_OP or state = LOAD1 else '0';
	sel_b <= '1' when state = R_OP or state = BRANCH else '0';
	sel_rC <= '1' when state = R_OP or state = RI_OP else '0';
	sel_ra <= '1' when state = CALL or state = CALLR else '0';
	sel_pc <= '1' when state = CALL or state = CALLR else '0';
	rf_wren <= '1' when state = R_OP or state = LOAD2 or state = I_OP or state = CALL or state = CALLR or state = RI_OP or state = UI_OP else '0';
	
	pc_en <= '1' when state = FETCH2 or state = CALL or state = CALLR or state = JMP or state = JMPI else '0';
	pc_sel_imm <= '1' when state = CALL or state = JMPI else '0';
 	pc_sel_a <= '1' when state = CALLR or state = JMP else '0';
	sel_addr <= '1' when state = LOAD1 or state = STORE else '0';
	
	sel_mem <= '1' when state = LOAD2 else '0';

	branch_op <= '1' when state = BRANCH else '0';
	pc_add_imm <= '1' when state = BRANCH else '0';

	process(op, opx) is
	begin
		case op is
			when "111010" =>
				case opx is
					when "001110" =>
						op_alu <= "100001";
					when "011011" =>
						op_alu <= "110011";
					when "000110" =>
						op_alu <= "100000";
					when "001000" =>
						op_alu <= "011001";
					when "000011" =>
						op_alu <= "110000";
					when "001011" =>
						op_alu <= "110001";
					when "010000" => -- opx = 10
						op_alu <= "011010";
					when "010011" => -- opx = 13
						op_alu <= "110010";
					when "010110" => -- opx = 16
						op_alu <= "100010";
					when "011000" => -- opx = 18
						op_alu <= "011011";
					when "011110" => -- opx = 1E
						op_alu <= "100011";
					when "100000" => -- opx = 20
						op_alu <= "011100";
					when "101000" => -- opx = 28
						op_alu <= "011101";
					when "110000" => -- opx = 30
						op_alu <= "011110";
					when "111001" => -- opx = 39
						op_alu <= "001000";
					when "111011" => -- opx = 3B
						op_alu <= "110111";
					when "000010" => -- opx = =02
						op_alu <= "110000";
					when "010010" => -- opx = 12
						op_alu <= "110010";
					when "011010" => -- opx = 1A
						op_alu <= "110011";
					when "111010" => -- opx = 3A
						op_alu <= "110111";
					when others =>
						op_alu <= "000000";
				end case;
			when "000100" => -- op = 4
				op_alu <= "000000";
			when "010111" => -- op = 17
				op_alu <= "000000";
			when "010101" => -- op = 15		
				op_alu <= "000000";
			when "001110" => -- op = 0E
				op_alu <= "011001";
			when "010110" => -- op = 16
				op_alu <= "011010";
			when "011110" => -- op = 1E
				op_alu <= "011011";
			when "100110" => -- op = 26
				op_alu <= "011100";
			when "101110" => -- op = 2E
				op_alu <= "011101";
			when "110110" => -- op = 36
				op_alu <= "011110";
			when "001000" => -- op = 08
				op_alu <= "011001";
			when "010000" => -- op = 10
				op_alu <= "011010";
			when "011000" => -- op = 18
				op_alu <= "011011";
			when "100000" => -- op = 20 
				op_alu <= "011100";
			when "001100" => -- op = 0C
				op_alu <= "100001";
			when "010100" => -- op = 14
				op_alu <= "100010";
			when "011100" => -- op = 1C
				op_alu <= "100011";
			when "101000" => -- op = 28
				op_alu <= "011101";
			when "110000" => -- op = 30
				op_alu <= "011110";
			when others =>	
				op_alu <= "000000";
		end case;
	end process;
end synth;
