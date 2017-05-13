library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(31 downto 0); readdata : out std_logic_vector(7 downto 0)
);
end ram;

architecture ram_arch of ram is
--type mem64x8 is array(0 to 63) of std_logic_vector(7 downto 0);
signal address : std_logic_vector(31 downto 0);
--signal address_r,data_in : std_logic_vector(7 downto 0);
--signal address_w : std_logic_vector(15 downto 0);
type ram_type is array (0 to 62)
        of std_logic_vector (7 downto 0);
   -- sinusoidal LUT
   -- for symmetry, 0x8000 (i.e., -1) is replaced by 0x8001
   constant SIN_LUT: ram_type:=( 
	
	x"28", x"2A", x"2C", x"2E", x"30", x"32", x"33", x"35", x"36", x"38", 
	x"39", x"3A", x"3B", x"3B", x"3C", x"3C", x"3C", x"3C", x"3C", x"3B", x"3A", 
	x"39", x"38", x"37", x"36", x"34", x"32", x"31", x"2F", x"2D", x"2B", x"29",
	x"27", x"25", x"23", x"21", x"1F", x"1E", x"1C", x"1A", x"19", x"18", x"17",
	x"16", x"15", x"15", x"14", x"14", x"14", x"14", x"15", x"15", x"16", x"17", 
	x"18", x"1A", x"1B", x"1D", x"1E", 
	x"20", x"22", x"24", x"26"

	
	
	
	);       
   signal tram: ram_type:=SIN_LUT;
begin
process(clk)
begin
if clk'event and clk='1' then
	if write = '1' then 
		address <= writedata;
	--tram(to_integer(unsigned(address_w))) <=data_in;
	end if;
	--
	--end if;
	
end if;

end process;

--data_in <= writedata(7 downto 0);
--address_r <= writedata(15 downto 8);
--address_w <= writedata(31 downto 16);

readdata <= tram(to_integer(unsigned(address))) when read='0' else (others=>'Z');
		
end architecture ram_arch;

