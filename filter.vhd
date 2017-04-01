library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lowpassfilter is
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end entity;

architecture low_arch of lowpassfilter is
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

dout_lp <= data_pipe(0) + data_pipe(1);
dout_hp <= data_pipe(1) - data_pipe(0);
end architecture low_arch;

--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end entity;

architecture test_arch of test is
component lowpassfilter
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end component;
signal clk : std_logic;
signal din,dout_hp,dout_lp : unsigned(7 downto 0);

begin

uut: component lowpassfilter port map( clk, din ,dout_lp,dout_hp);

process
begin
clk <= '1'; wait for 10 ns;
clk <= '0'; wait for 10 ns;
end process;

process
begin
din <= to_unsigned(2,8);
wait for 20 ns;
din <= to_unsigned(2,8);
wait for 20 ns;
din <= to_unsigned(0,8);
wait;
end process;

end test_arch;





	
