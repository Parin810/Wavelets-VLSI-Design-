library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity controlunit is
port (clk,start: in std_logic; state : in smstate; read_row: in std_logic;

address_in : in std_logic_vector(5 downto 0);data : out std_logic_vector(15 downto 0); status: out std_logic);
end controlunit;


architecture controlunit_arch of controlunit is

signal address2,address,address3 : std_logic_vector(address_bus_width-1 downto 0) := (others => '0');
signal readdata,writedata,readdata2,writedata2,readdata3,writedata3 : std_logic_vector(width-1 downto 0) := (others => '0');
signal read_en,read2,read3,write3,write2,write_en,reset : std_logic := '0';
signal counter,counter1,delay : unsigned(3 downto 0) := (others=>'0');
signal dout_hp,dout_lp,data_in : unsigned(7 downto 0);
signal switch,in_process : std_logic:='0';
signal row_pixel_count: unsigned (3 downto 0) := (others=> '0');
signal total_pixel_count: unsigned(3 downto 0) := (others=> '0');


component input_ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(width-1 downto 0); readdata : out std_logic_vector(width-1 downto 0);
address : in std_logic_vector(address_bus_width-1 downto 0)
);
end component;

component filter is
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end component;


component output1 is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(width-1 downto 0); readdata: out std_logic_vector(width-1 downto 0);
address : in std_logic_vector(address_bus_width-1 downto 0)
);
end component;

begin

ram: component input_ram port map (clk,read_en,write_en,writedata,readdata,address);

filter_1 : component filter port map (clk,data_in,dout_lp,dout_hp);

outputram1 : component output1 port map (clk,read2,write2,writedata2,readdata2,address2);
outputram2 : component output1 port map (clk,read3,write3,writedata3,readdata3,address3);


read2 <= read_row;
read3 <= read_row;

--address2,read2,write2,writedata2,readdata2 for outputram1 i.e. downsampled low pass output.
--address3,read3,write3,writedata3,readdata3 for outputram2 i.e. downsampled high pass output.

--controls data flow from the input ram
Process(clk,state,read_row)
variable row : std_logic := '0';
variable pulse_count : unsigned(3 downto 0) := "0000";
begin
if state=compute then
	if clk'event and clk='1' then
		if row='0'  then
			read_en <= '1';
			counter <= counter + 1;  --start reading from ram counter= input ram address
			row_pixel_count <= row_pixel_count + 1; --incremenr pixel count
			pulse_count := pulse_count + 1; --pulse count as output becomes valid of filter 
													  --becmoes valid after two clock cycles				
		end if;
		
	if start = '1' and pulse_count="0010" then
	
		in_process <= '1';--triggers storing of output values in the two output rams
		--row_pixel_count <= (others=>'0');
	end if;	
	if start = '1' and row_pixel_count="1111" then
		row := '1';
		--we <= '1';
		read_en <= '0';  --stop after entire input ram is read
		counter <= counter; --retain address value
	end if;
	
end if;
end if;
end process;


--stores the two output streams into the two rams

Process(clk,state,in_process)
begin
if state=compute then
	if clk'event and clk='1' then
		if in_process = '1' and switch ='0' then
			delay <= counter1;
			counter1 <= delay + 1; --address value is strecthed to two clock cycles
										  --as every other sample is ignored by output rams (downsampling)
			write2 <= '1';
			write3 <= '1';
			report "address values : " & integer'image( to_integer(counter1));
			report "data in output ram1:" & integer'image(to_integer(unsigned(writedata2)));
			report "data in output ram2:" & integer'image(to_integer(unsigned(writedata3)));
		end if;
		if counter1 = "1000" then --"1000" since there are eightoutputs 
			write2 <= '0';
			write3 <= '0';
			switch <= '1';
			status <= switch;  --signal to fsm that row outputs have been written to output rams.
			counter1 <= "0000";  --clear counter (counter acts as address for the two output rams)
			report "outputs stored";
		end if;
			
	end if;
end if;
end process;
			

	
writedata2 <= std_logic_vector(dout_lp);
writedata3 <= std_logic_vector(dout_hp);
data_in <= unsigned(readdata) when readdata /= "ZZZZZZZZ" else x"00";
address <= "0000" & std_logic_vector(counter);  
address2 <= "0000" & std_logic_vector(counter1) when switch='0' else "00" & std_logic_vector(address_in);  --addressing output rams foe writing and when switch
																											-- is '1' the NIOS II can access the outputs using address_in
address3 <= "0000" & std_logic_vector(counter1) when switch='0' else "00" & std_logic_vector(address_in);
data <= readdata2 & readdata3 when switch = '1' else (others => '0');
end architecture controlunit_arch;





