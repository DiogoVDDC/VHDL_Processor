library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is
	type memory_type is array (0 to 1023) of std_logic_vector(31 downto 0); -- (4KB and words of 4B = 32 bit)
	signal memory: memory_type;
	signal s_read, s_cs    :   std_logic;
	signal s_rd_data : std_logic_vector(31 downto 0);
	signal s_address : std_logic_vector(9 downto 0);

begin

	
	process(clk) is	
	begin
		if(rising_edge(clk)) then 
			-- read 
			if(read = '1' and write = '0' and cs = '1') then 
				s_address <= address;
				s_read <= '1';
				s_cs <= '1';
			else 
				s_read <= '0';
				s_cs <= '0';
			end if;

			-- write 
			if(write = '1' and read = '0' and cs = '1') then 
				memory(to_integer(unsigned(address))) <= wrdata;
			end if;
		
		end if;
	end process;

	rddata <= memory(to_integer(unsigned(s_address))) when s_read = '1' and s_cs = '1' else
		(others => 'Z');
end synth;
