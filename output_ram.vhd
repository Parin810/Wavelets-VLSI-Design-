library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;


entity output_ram is
port(clk : in std_logic;
we,re: in std_logic; 
readdata : out unsigned(7 downto 0);
writedata : in unsigned(7 downto 0);
reset : in std_logic;
address : in unsigned(7 downto 0)
);
end entity;


architecture output_ram_arch of output_ram is
type ram_type is array(0 to 8) of unsigned(7 downto 0);
signal tram : ram_type := (others => (others => '0'));
signal address_w,address_r : unsigned(3 downto 0);
begin
address_r <= address(3 downto 0);
address_w <= address(7 downto 4);
Process(clk)
begin
if (clk'event and clk='1') then
	if we='1' then
		tram(address_w) <= writedata;
	end if;
	if re='0' then
		readdata <= tram(address_r);
	end if;
end process;

end architecture output_ram_arch;

