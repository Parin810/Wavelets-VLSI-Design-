
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package defs is
constant length : integer:= 4;
constant max_length : integer := 7;
constant sample_length : integer := 4;
constant size : integer := 16;
constant width : integer := 8;
--type ram_type is array (0 to size-1)
       -- of std_logic_vector (width-1 downto 0);

--constant Mem_init:ram_type := (x"00",x"01",x"02",x"03",x"04",x"05",x"06",
--x"07",x"08",x"09",x"0A",x"0B",x"0C",x"0D",x"0E",x"0F");

end defs;

