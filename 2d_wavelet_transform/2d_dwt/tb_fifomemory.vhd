library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.defs.all;


entity tb_fifomemmory is
end tb_fifomemmory;


architecture test_arch of tb_fifomemmory is

component fifomemory is
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
	end component;


signal clk,reset,we :std_logic:='0';
signal dataIn,dataOutFirst,dataOutLast : std_logic_vector(7 downto 0) := (others => '0');

begin

uut : fifomemory generic map ( fifodepth => 3, fifodata_width => 8 )
	  port map ( clk, reset,we,dataIn,dataOutFirst,dataOutLast);
	  
clk <= not clk after 20 ns;


Process
begin
for i in 0 to 2 loop
	we <= '1';
	dataIn <= std_logic_vector(to_unsigned(i,8));
	wait for 40 ns;
	we <= '1';
end loop;
wait for 80 ns;
wait;
end process;

end architecture test_arch;



