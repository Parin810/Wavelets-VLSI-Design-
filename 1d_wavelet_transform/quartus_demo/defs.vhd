



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package defs is
type smstate is (idle,compute,row_done);
constant row_length : unsigned(7 downto 0):= x"04";
constant max_length : integer := 7;
constant sample_length : integer := 4;
constant ram_size : integer := 15;
constant width : integer := 8;
constant address_bus_width:integer := 8;

end defs;



