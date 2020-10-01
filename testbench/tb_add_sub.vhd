library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_add_sub is
end tb_add_sub;

architecture testbench of tb_add_sub is
	constant TIME_DELTA : time := 100 ns;
	signal a, b, r : std_logic_vector(31 downto 0);
	signal sub_mode, carry, zero : std_logic;	
	
	
begin


	dut: ENTITY work.add_sub
	port map(
		a => a,
		b => b,
		sub_mode => sub_mode,
		carry => carry,
		zero => zero,
		r => r);

	
	test : process
		procedure check(constant in1 	: in integer;
				constant in2 	: in integer;
				constant sm 	: in integer;
				constant expctd : in integer) is
			variable res : integer;
		begin
			a <= std_logic_vector(to_unsigned(in1, a'length));
			b <= std_logic_vector(to_unsigned(in2, b'length));
			if(sm = 1) then
				sub_mode <= '1';
			else 
				sub_mode <= '0'; 
			end if;			 
		
			wait for TIME_DELTA;

			res := to_integer(signed(r));
			assert res = expctd;
			report  "Unexpected result: " &
				"a = " & integer'image(in1) & "; " &
				"b = " & integer'image(in2) & "; " &
				"submode= " & integer'image(sm) & "; " &
				"SUM = " & integer'image(res) & "; " &
				"SUM_expected = " & integer'image(expctd)
			severity error;

			if res = to_unsigned(0, 32) then 
				assert zero = '1'
				report "zero not raised"
				severity error;
			end if;

		end procedure;	
	begin
		check(54, 23, 0, 77);
		check(34, 34, 1, 0);
		check(543, 65489, 0, 66032);
		check(0, 1, 1, -1);
		
		--check(	"00010000000000000000000000000000", 
		--"11110000000000000000000000000000",
		--'0',
		--"100000000000000000000000000000000");
		wait;
	end process test;

end testbench;
