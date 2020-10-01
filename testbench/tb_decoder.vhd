library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decoder is
end;

architecture testBench of tb_decoder is
	signal address : std_logic_vector(15 downto 0);
	signal cs_LEDS, cs_ROM, cs_RAM : std_logic;

	signal add : std_logic_vector(2 downto 0);
	constant TIME_DELTA : time := 100 ns;
begin
	
	decoder : entity work.decoder
	port map(address => address,
	        cs_LEDS => cs_LEDS,
        	cs_RAM => cs_RAM,
        	cs_ROM => cs_ROM);

	-- Init

	process 

		

		procedure test(	
			constant add : 	in std_logic_vector(15 downto 0);
			constant xpctd : 	in std_logic_vector(2 downto 0)
			) is
		begin
			address <= add;
			wait for TIME_DELTA;
			assert (cs_LEDS = xpctd(2))
			report "Error on leds, val : " & std_logic'image(cs_LEDS)
			severity error;
			 
			assert (cs_RAM = xpctd(1))
			report "Error on ram, val :" & std_logic'image(cs_RAM)
			severity error;

			assert (cs_ROM = xpctd(0))
			report "Error on rom, val : " & std_logic'image(cs_ROM)
			severity error;
		end procedure;
	begin
		test(x"0000", "001");
		test(x"0FFC", "001");
		test(x"1000", "010");
		test(x"1FFC", "010");
		test(x"2000", "100");
		test(x"200C", "100");
		test(x"2010", "000");
		test(x"FFFC", "000");
		wait;
	end process;

end testBench;
