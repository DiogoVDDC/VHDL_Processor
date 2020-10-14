library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
signal current_addr : unsigned(31 downto 0);

begin

	addr(31 downto 0) <= std_logic_vector(current_addr(31 downto 2) & "00");

	clock: process(clk, reset_n)
	begin	
		if (reset_n = '0') then 
			current_addr <= (others => '0');
		elsif(rising_edge(clk)) then
			if(reset_n = '0') then 
				current_addr <= (OTHERS => '0');
			elsif(en = '1') then
				current_addr <= current_addr + 4;
			end if;
		end if;
	end process;


end synth;
