library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
	component ROM_block 
		port(
		address	: in std_logic_vector (9 downto 0);
		clock	: in std_logic;
		q	: out std_logic_vector (31 downto 0));
	end component ROM_block;

	signal s_q 	    : std_logic_vector(31 downto 0):= (others => '0');
	signal s_read, s_cs : std_logic := '0';

begin
	romBlock : ROM_block
	port map(address => address,
		 clock 	 => clk,
		 q 	 => s_q);
	
	process(clk) is
	begin 
		if rising_edge(clk) then
			if(read = '1' and cs = '1') then 
				s_read <= '1';
				s_cs <= '1';
			else 
				s_read <= '0';
				s_cs <= '0';
			end if;
		end if;
	end process;
	rddata <= s_q when s_read = '1' and s_cs = '1' else 
		(others => 'Z');

end synth;
