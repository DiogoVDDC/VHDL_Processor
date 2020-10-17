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

	type states is (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, LOAD2, I_OP);
	signal state, nextState : states;
begin

	pc_add_imm <= '0';
	pc_sel_imm <= '0';
 	pc_sel_a <= '0';
	branch_op <= '0';
	imm_signed <= '0';
	sel_pc <= '0';
	sel_ra <= '0';

	process(state) is
	begin
		if state = DECODE then
	end process;

	process(clk, reset_n) is
	begin
		if (reset_n = '0') then
			nextState <= FETCH1;
		end if;
		
		if rising_edge(clk) then
			state <= nextState;
					
				when others =>
			end case;
			case nextState is
				when FETCH1 =>
					read <= '1';
					nextState <= FETCH2;
				when FETCH2 =>
					nextState <= DECODE;
				when DECODE =>
					
				when I_OP =>
					nextState <= FETCH1;
				when R_OP =>
					nextState <= FETCH1;
				when LOAD1 =>
					nextState <= LOAD2;
				when LOAD2 =>
					nextState <= FETCH1;
				when STORE =>
					nextState <= FETCH1;
				when BREAK =>
					nextState <= BREAK;
				when others => 
					nextState <= BREAK;
			end case;
		end if;
			
--			state <= nextState;
--			if nextState = FETCH1 then
--				ir_en <= '1';
--				read <= '1';
--				nextState <= FETCH2;
--			elsif nextState = FETCH2 then
--				nextState <= DECODE;
--			elsif nextState = DECODE then

--			elsif nextState = I_OP then
--				nextState <= FETCH1;
--			elsif nextState = R_OP then
--				nextState <= FETCH1;
--			elsif nextState = LOAD1 then
--				nextState <= LOAD2;
--			elsif nextState = LOAD2 then
--				nextState <= FETCH1;
--			elsif nextState = STORE then
--				nextState <= FETCH1;
--			elsif nextState = BREAK then 
--				nextState <= BREAK;
--			end if;
--		end if;
	end process;	
	
	pc_en <= '1' when state = FETCH2 else '0';
	ir_en <= '1' when state = FETCH2 else '0';

	sel_mem <= '1' when state = LOAD2 else '0';
	sel_addr <= '1' when state = LOAD1 or state = STORE else '0';
	rf_wren <= '1' when state = R_OP else '0';

	sel_b <= '1' when state = R_OP else '0';
	sel_rC <= '1' when state = R_OP else '0';

	--read <= '1' when state = LOAD1 or state = LOAD2 or state = FETCH1 else
	--	'0';
	write <= '1' when state = STORE else
		'0';

	process(op, opx) is
	begin
		if op = "111010" then
			if opx = "001110" then
				op_alu <= "100001";
			elsif opx = "011011" then
				op_alu <= "110011";
			end if;
		elsif op = "000100" then
			op_alu <= "000000";
		elsif op = "010111" or op = "010101" then
			op_alu <= "000000";
		else 
			op_alu <= "000000";
		end if;
	end process;

	














end synth;
