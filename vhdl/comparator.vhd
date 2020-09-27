library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port(
        a_31    : in  std_logic;	-- signed bit of A
        b_31    : in  std_logic;	-- signed bit of B
        diff_31 : in  std_logic;	-- signed bit of the difference
        carry   : in  std_logic;
        zero    : in  std_logic;
        op      : in  std_logic_vector(2 downto 0);
        r       : out std_logic
    );
end comparator;

architecture synth of comparator is

signal unsigned_less_equal, unsigned_greater, signed_less_equal, signed_greater : std_logic;

begin

unsigned_less_equal <= '1' when carry = '0' or zero = '1' else '0';

unsigned_greater <= not(unsigned_less_equal);

signed_less_equal <= '1' when (a_31 = '1' and b_31 = '0' )
	or (((a_31 = '1' and b_31 = '1') or (a_31 = '0' and b_31 = '0'))
	and (zero = '1' or diff_31 = '1')) else '0';

signed_greater <= not(signed_less_equal);
	

r <= not(zero) when op = "011" else
	zero when op = "100" else
	unsigned_less_equal when op = "101" else
	unsigned_greater when op = "110" else
	signed_less_equal when op = "001" else
	signed_greater when op = "010" else
	zero;


end synth;
