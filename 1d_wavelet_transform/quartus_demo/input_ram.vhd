library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity input_ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(address_bus_width -1 downto 0); readdata : out std_logic_vector(address_bus_width -1 downto 0);
address : in std_logic_vector(address_bus_width-1 downto 0)
);
end input_ram;

architecture ram_arch of input_ram is

type ram_type is array (0 to ram_size)
        of std_logic_vector (7 downto 0);
    
--initialising ram with sample row
  signal tram: ram_type := (x"00",x"01",x"02",x"03",x"04",x"05",x"06",
x"07",x"08",x"09",x"0A",x"0B",x"0C",x"0D",x"0E",x"0F");

begin

process(clk)
begin
if clk'event and clk='1' then
	if write = '1' then 
	tram(to_integer(unsigned(address))) <= writedata(7 downto 0);
	end if;
end if;
end process;
readdata <= tram(to_integer(unsigned(address))) when read='1' else (others => 'Z');		
end architecture ram_arch;