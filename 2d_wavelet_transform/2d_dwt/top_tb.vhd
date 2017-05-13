library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;
use std.textio.all;

entity test is
end test;


architecture test_arch of test is

component top is
port (clk,start : in std_logic; ca,ch,cv,cd : out std_logic_vector(7 downto 0));
end component;

signal clk,start : std_logic := '0';
signal ca,ch,cv,cd: std_logic_vector(7 downto 0) := (others=>'0');

begin

uut: component top port map (clk,start,ca,ch,cv,cd);

clk<= not(clk) after 20 ns;

process
begin
start <= '0';
wait for 40 ns;
start <= '1';
wait;
end process;

end architecture test_arch;