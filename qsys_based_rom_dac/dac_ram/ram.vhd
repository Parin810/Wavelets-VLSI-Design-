library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(31 downto 0); readdata : out std_logic_vector(7 downto 0)
);
end ram;

architecture ram_arch of ram is
--type mem64x8 is array(0 to 63) of std_logic_vector(7 downto 0);

type ram_type is array (0 to 8)
        of std_logic_vector (7 downto 0);
   -- sinusoidal LUT
   -- for symmetry, 0x8000 (i.e., -1) is replaced by 0x8001
   constant SIN_LUT: ram_type:=(  -- 2^8-by-16
      x"00",x"01",x"02",x"03",x"0F",x"FF",x"0F",x"00",x"09");       
   signal tram: ram_type:=SIN_LUT;
begin
process(clk)
begin
if clk'event and clk='1' then
	if write = '0' then 
	tram(to_integer(unsigned(writedata(31 downto 8)))) <= writedata(7 downto 0);
	end if;
	
end if;

end process;

readdata <= tram(to_integer(unsigned(writedata(31 downto 8)))) when read='0' else (others=>'Z');
		
end architecture ram_arch;

