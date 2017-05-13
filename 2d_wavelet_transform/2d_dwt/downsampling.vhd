library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity down_sampler is
port (clk : in std_logic; 
in_lp : in unsigned(7 downto 0);
in_hp: in unsigned(7 downto 0);
out_lp: out unsigned(7 downto 0);
out_hp : out unsigned(7 downto 0)
);
end entity;

architecture down_sampler_arch of down_sampler is
--signal count : std_logic := '0';
begin
process (clk)
variable count : std_logic := '1';
begin
if clk'event and clk='1' then
	if (count = '0') then
		out_hp <= in_hp;
		out_lp <= in_lp;
	else
		out_hp <= x"00";
		out_lp <= x"00";
	end if;
	count := not(count);
end if;
end process;

end architecture down_sampler_arch;



