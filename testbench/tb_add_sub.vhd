library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_add_sub is
end tb_add_sub;

architecture testbench of tb_add_sub is

	constant TIME_DELTA : time := 100 ns;

	signal a, b, r : std_logic_vector(31 downto 0);
	signal sub_mode, carry, zero : std_logic;	
	
	component add_sub is
   	port(
        	a        : in  std_logic_vector(31 downto 0);
        	b        : in  std_logic_vector(31 downto 0);
        	sub_mode : in  std_logic;
        	carry    : out std_logic;
        	zero     : out std_logic;
        	r        : out std_logic_vector(31 downto 0)
    	);
	end component;
begin
	add_sub_0 : add_sub 
	port map(
		a => a,
		b => b,
		sub_mode => sub_mode,
		carry => carry,
		zero => zero,
		r => r);

	
	test : process
		procedure check(constant in1 	: in unsigned;
				constant in2 	: in unsigned;
				constant sm 	: in std_logic;
				constant expctd : in unsigned) is
			variable res : unsigned(31 downto 0);
		begin
			a <= std_logic_vector(in1);
			b <= std_logic_vector(in2);
			sub_mode <= sm;
		
			wait for TIME_DELTA;

			res := unsigned(r);
			assert res = expctd;
			report "error"
			severity error;

			if res = to_unsigned(0, 32) then 
				assert zero = '1'
				report "zero not raised"
				severity error;
			end if;

		end procedure;	
	begin
		--check(54, 23, '0', 77);
		--check(34, 34, '1', 0);
		--check(543, 65489, '0', 66032);
		--check(0, 1, '1', -1);
		
		check(	"00010000000000000000000000000000", 
			"11110000000000000000000000000000",
			'0',
			"100000000000000000000000000000000");
		wait;
	end process;

end testbench;
