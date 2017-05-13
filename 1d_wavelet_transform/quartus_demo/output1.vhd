library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity output1 is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(width-1 downto 0); readdata: out std_logic_vector(width-1 downto 0);
address : in std_logic_vector(address_bus_width-1 downto 0)
);
end output1;

architecture ram_arch of output1 is

--type mem64x8 is array(0 to 63) of std_logic_vector(7 downto 0);

type ram_type is array (0 to ram_size)
        of std_logic_vector (7 downto 0);
    
   signal tram: ram_type := (others => (others => '0'));

	
	--attribute syn_ram_init_file : string;
	--attribute syn_ram_init_file of tram: signal is "init.mif";
begin
process(clk)
variable pulse_count : std_logic := '0';
begin
if clk'event and clk='1' then
	if pulse_count = '1' then
		if write = '1' then 
		tram(to_integer(unsigned(address))) <= writedata(7 downto 0);
		end if;
	end if;
	pulse_count := not(pulse_count);
	if read = '1' then
		readdata <= tram(to_integer(unsigned(address)));
	end if;
		
end if;
end process;
	
end architecture ram_arch;