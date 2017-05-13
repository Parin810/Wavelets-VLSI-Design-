library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity avalon_interface is
   port (
      clk, reset    : in  std_logic;
      address       : in  std_logic_vector (5 downto 0);
      read          : in  std_logic;
      readdata      : out std_logic_vector (31 downto 0);
      write         : in  std_logic;
      writedata     : in  std_logic_vector (31 downto 0)
   );
end avalon_interface;

architecture avalon_arch of avalon_interface is

signal start : std_logic;
signal clk_write : std_logic := '0';
signal ca,ch : std_logic_vector(7 downto 0) := (others => '0');
signal from_wavelet : std_logic_vector(15 downto 0) := (others => '0');
component top is
port (clk,start : in std_logic; ca,ch: out std_logic_vector(7 downto 0);
read_in:in std_logic;
address_in : in std_logic_vector(5 downto 0);
readdata1 : out std_logic_vector(15 downto 0);
writedata1 : in std_logic_vector(7 downto 0);
clk_write : out std_logic;ready: out std_logic);
end component;

begin

top_wavelet :component top port map (clk,start,ca,ch,read,address,from_wavelet(15 downto 0),writedata(7 downto 0),clk_write);
start <= '1';
readdata <= x"0000" & from_wavelet;
end architecture avalon_arch;
 