library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
	signal s_b : std_logic_vector(32 downto 0) := (others => '0');
	signal s_a : std_logic_vector(32 downto 0) := (others => '0');
	signal s_R : std_logic_vector(32 downto 0) := (others => '0');
begin
	s_a <= "0" & a;
	
	inverse_s_b :
	for i in 0 to 31 generate
		s_b(i) <= (b(i) xor sub_mode);
	end generate inverse_s_b;
	
	s_r <= std_logic_vector(unsigned(s_a) + unsigned(s_b) + 1) when sub_mode = '1' else
			    std_logic_vector(unsigned(a) + unsigned(s_b));
	
	zero <= '1' when unsigned(s_r(31 downto 0)) = to_unsigned(0, 32) else '0';
	carry <= '1' when s_r(32) = '1' else '0';
	r <= s_r(31 downto 0);
end synth;
