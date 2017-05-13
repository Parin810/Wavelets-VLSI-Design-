library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_signed.all;

entity filter is
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end entity;

architecture arch of filter is
--signal x_minus_0, x_minus_1 : unsigned(7 downto 0);
type tram is array(0 to 1) of unsigned(7 downto 0);

signal data_pipe: tram := (others => (others => '0'));
begin
process(clk)
begin
	if clk'event and clk='1' then
		data_pipe(1) <= din;
		data_pipe(0) <= data_pipe(1);
	end if;
end process;

dout_lp <= (data_pipe(0) + data_pipe(1));
dout_hp <= (data_pipe(1) - data_pipe(0));
end architecture arch;






	
