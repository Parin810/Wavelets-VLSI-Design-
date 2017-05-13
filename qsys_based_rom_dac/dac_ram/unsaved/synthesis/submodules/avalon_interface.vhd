LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY my_ram_avalon_interface IS
PORT ( clock, resetn :IN STD_LOGIC;
	read, write : IN STD_LOGIC;
	writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	--leds : out std_logic_vector(7 downto 0)
	--addr : in std_logic_vector(31 downto 0)
	);
END my_ram_avalon_interface; 

ARCHITECTURE Structure OF my_ram_avalon_interface IS
SIGNAL to_dac_ram : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL from_dac_ram : STD_LOGIC_VECTOR(7 DOWNTO 0);
Signal write_to_ram : std_logic_vector(7 downto 0);
COMPONENT ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(31 downto 0); readdata : out std_logic_vector(7 downto 0));
end component;

BEGIN
	--write_to_ram <= writedata(15 downto 8);
	ram_istance : ram port map(clk => clock, read => read, write => write,readdata => from_dac_ram, writedata=>writedata);
	--writedata(31 downto 16) <= x"0000";
	readdata <= x"000000" & from_dac_ram;
	--leds <= from_dac_ram;
	--writedata <= x"00000" & write_to_ram(7 downto 0);
END Structure;



