

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.defs.all;

entity fifomemory is
	generic( fifodepth : integer := 4;
			fifodata_width : integer := 8);
    port (
        clk: in std_logic;
        reset: in std_logic;
		  we: in std_logic;
        dataIn: in std_logic_vector(7 downto 0);
		  dataOutFirst: out std_logic_vector(7 downto 0);
        dataOutLast: out std_logic_vector(7 downto 0)
    );
end fifomemory;

architecture RTL of fifomemory is
	type ramtype is array(0 to (fifodepth - 1)) of std_logic_vector((fifodata_width - 1) downto 0);    

	signal ram : ramtype := (others => (others => '0'));

begin
	process (clk, reset)
	begin
		if reset = '1' then
			ram <= (others => (others => '0'));
		elsif falling_edge(clk) then
			if we = '1' then
				ram(0) <= dataIn;
				ram (1 to (fifodepth -1)) <= ram(0 to (fifodepth - 2));
				--ram <= dataIn & ram(0 to (fifodepth - 2));
			end if;
		end if;
	end process;
	
	dataOutFirst <= ram(0);
	dataOutLast <= ram(fifodepth - 1);
end RTL;
