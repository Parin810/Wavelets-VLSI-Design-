library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.defs.all;

entity test_top is
end entity;


architecture main of test_top is

signal clk,start,clk_write : std_logic := '0';
signal ca,ch : std_logic_vector(7 downto 0);
signal read1,write1: std_logic;
signal address1 : std_logic_vector(5 downto 0);
signal readdata1 : std_logic_vector(15 downto 0);
signal writedata1 : std_logic_vector(7 downto 0);
signal ready :  std_logic;
signal data_out : std_logic_vector(7 downto 0);

--signal clk_write : std_logic;
component top is
port (clk,start : in std_logic; ca,ch: out std_logic_vector(7 downto 0);
read_in:in std_logic;
address_in : in std_logic_vector(5 downto 0);
readdata1 : out std_logic_vector(15 downto 0);
writedata1 : in std_logic_vector(7 downto 0);
clk_write : out std_logic;ready : out std_logic);
end component;

begin

uut6: component top port map (clk,start,ca,ch,read1,address1,readdata1,writedata1,clk_write,ready);

clk <= not clk after 20 ns;

Process
begin
wait for 40 ns;
start <= '1';
wait;
end process;
	
Process(clk,ready)
variable address : integer range 0 to 7;
begin
if clk'event and clk='1' then
	if ready='1' then
		address1 <= std_logic_vector(to_unsigned(address,6));
		read1 <= '1';
	end if;
end if;
end process;



end architecture main;

