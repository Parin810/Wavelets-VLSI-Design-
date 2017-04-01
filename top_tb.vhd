library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity test1 is
end entity;

architecture test_arch of test1 is

component top_wavelet 
port
( clk : in std_logic;
in_data : in unsigned (7 downto 0);
out_data_1 : out unsigned (7 downto 0);
out_data_2 : out unsigned (7 downto 0);
input_length : integer range 0 to length 
);
end component;


signal clk: std_logic;
signal in_data,out_data_1,out_data_2 : unsigned(7 downto 0);
signal input_length : integer := 0;


begin

uut: component top_wavelet port map( clk,in_data,out_data_1,out_data_2,input_length);

process
begin
clk <= '1'; wait for 10 ns;
clk <= '0'; wait for 10 ns;
end process;

process
begin
in_data<= to_unsigned(2,8);
wait for 20 ns;
in_data <= to_unsigned(2,8);
wait for 20 ns;
in_data <= to_unsigned(0,8);
wait;
end process;

end test_arch;