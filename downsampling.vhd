library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity down_sampler is
port (clk : in std_logic; 
in_lp : in unsigned(7 downto 0);
in_hp: in unsigned(7 downto 0);
out_lp: out unsigned(7 downto 0);
out_hp : out unsigned(7 downto 0)
);
end entity;

architecture down_sampler_arch of down_sampler is
signal count : unsigned(3 downto 0) := x"0";
begin
process (clk)
begin
if clk'event and clk='1' then
	if (count(0) = '0') then
		out_hp <= in_hp;
		out_lp <= in_lp;
	end if;
	count <= count + 1;
end if;
end process;

end architecture down_sampler_arch;

--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end entity;

architecture test_arch of test is

component down_sampler
port (clk : in std_logic; 
in_lp : in unsigned(7 downto 0);
in_hp: in unsigned(7 downto 0);
out_lp: out unsigned(7 downto 0);
out_hp : out unsigned(7 downto 0)
);
end component;

signal clk : std_logic;
signal in_hp,in_lp,out_hp,out_lp : unsigned(7 downto 0);

begin

uut : component down_sampler port map(clk,in_lp,in_hp,out_lp,out_hp);

process
begin
clk <= '1'; wait for 10 ns;
clk <= '0'; wait for 10 ns;
end process;

process
begin
in_hp <=to_unsigned(7,8); in_lp <= to_unsigned(7,8);
wait for 20 ns;
in_hp <=to_unsigned(1,8); in_lp <= to_unsigned(1,8);
wait for 20 ns;
in_hp <=to_unsigned(4,8); in_lp <= to_unsigned(4,8);
wait for 20 ns;
in_hp <=to_unsigned(2,8); in_lp <= to_unsigned(2,8);
wait for 20 ns;
in_hp <=to_unsigned(6,8); in_lp <= to_unsigned(6,8);
wait for 20 ns; 
wait;
end process;

end architecture test_arch;


