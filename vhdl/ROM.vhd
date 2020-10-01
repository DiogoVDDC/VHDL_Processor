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
signal s_q  : std_logic_vector(31 downto 0);
signal s_address : std_logic_vector(9 downto 0);

begin

ROM_BLOCK : ENTITY work.rom_block port map(
            	address	=> address,
		clock	=> clk,	
		q => s_q
        );

process(clk) is
begin
	if(rising_edge(clk)) then 
		if(read = '1' and cs = '1') then 
			 rddata <= s_q;
		else
			 rddata <= (OTHERS => 'Z');
		end if;
		
	end if;
end process;

end synth;
