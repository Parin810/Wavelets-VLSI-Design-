library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;
use std.textio.all;

entity test_algo is
port (clk,start: in std_logic; out_1,out_2,out_3,out_4 : out unsigned(7 downto 0); clk_write_out : out std_logic);
end test_algo;


architecture arch of test_algo is

signal address,readdata,writedata,dataOutFirst : std_logic_vector(7 downto 0) := (others => '0');
signal read_en,write_en,data_in_valid,we,reset : std_logic := '0';
signal counter : unsigned(3 downto 0) := "1111";
signal delay : unsigned(3 downto 0 ) := "0000";
signal counter1: unsigned(3 downto 0) := "0000";
signal counter2: unsigned(3 downto 0) := "0000";
signal row_complete : std_logic := '0';
signal dout_hp,dout_lp,data_in : unsigned(7 downto 0);
signal out_lp,out_hp : unsigned(7 downto 0);
signal delayed_clk,in_process,alt : std_logic:='0';
signal din1,din2: unsigned(7 downto 0) := (others => '0');
signal pixel_count : unsigned(7 downto 0):= x"00";
signal row_count : unsigned(3 downto 0) := x"0";
signal column_count : unsigned(3 downto 0) := x"0";

signal address1,readdata1,writedata1 : std_logic_vector(7 downto 0) := (others => '0');
signal read1,write1,stop_write : std_logic := '0';

signal address2,readdata2,writedata2 : std_logic_vector(7 downto 0) := (others => '0');
signal read2,write2,clk_write : std_logic := '0';

component input_ram is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(7 downto 0); readdata : out std_logic_vector(7 downto 0);
address : in std_logic_vector(7 downto 0)
);
end component;

component filter is
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end component;

component down_sampler is
port (clk : in std_logic; 
in_lp : in unsigned(7 downto 0);
in_hp: in unsigned(7 downto 0);
out_lp: out unsigned(7 downto 0);
out_hp : out unsigned(7 downto 0)
);
end component;


component output1 is
port ( clk,read,write : in std_logic; writedata : in std_logic_vector(7 downto 0); readdata : out std_logic_vector(7 downto 0);
 address : in std_logic_vector(7 downto 0));
end component;

begin
inputram: component input_ram port map (clk,read_en,write_en,writedata,readdata,address);
filter_level_1 : component filter port map (clk,data_in,dout_lp,dout_hp);
outputram_1 : component output1 port map (clk,read1,write1,writedata1,readdata1,address1);
outputram_2 : component output1 port map (clk,read2,write2,writedata2,readdata2,address2);
filter1_level_2: component filter port map (clk,din1,out_1,out_2);
filter2_level_2 : component filter port map (clk,din2,out_3,out_4);



Read_from_input_ram :Process(clk,in_process)
begin
if clk'event and clk='1' then
	if start = '1' and row_complete='0'  then
		read_en <= '1';
		counter <= counter + 1;  --starting reading values from input ram
		pixel_count <= pixel_count + 1; --keep track of pixels or values
		report "address : " & integer'image(to_integer(counter)) & " value read :" & integer'image(to_integer(unsigned(readdata)));
	end if;
	if row_complete = '1' then  --when all values are read reset counter. counter acts are address for input ram
		
		counter <= "0000";
	end if;
		--address <= address + 1;
	if start = '1' and pixel_count=x"10" then  --16 pixels - 4 columns x"10" as it starts from 1 
		
		we <= '1';
		pixel_count <= x"00";  --reset pixel_count
		row_complete <= '1';  --generate row_complete
		read_en <= '0'; --stop reading
	end if;	
		
end if;

end process;


stop_writing:process(clk,row_complete)--stops storing of first level outputs
variable pulse_count : unsigned(7 downto 0) := x"00";
begin
if clk'event and clk='1' then
	if row_complete = '1' then
		pulse_count := pulse_count + 1;
		if pulse_count = x"02" then  --as soon as reading is complete all the outputs would have been stored after two more clock cycles
									-- since two tap filter is used.
			stop_write <= '1';
		end if;
		
		end if;
end if;
end process;


storelevel_1outputs:Process (clk,stop_write)  --starts storing level 1 output streams to output rams
variable clk_count : unsigned(7 downto 0) := x"00";
variable gen_address : std_logic := '0';
begin
if clk'event and clk='1' then
	clk_count := clk_count + 1;
	if clk_count = x"04" then
		write1 <= '1';	
		write2 <= '1';
		gen_address := '1';
	end if;
	if gen_address = '1' then
		delay <= counter1;
		counter1 <= delay + 1;
	end if;
	if stop_write = '1' then ---stop when stop_write is '1'
		write1 <= '0';
		write2 <= '0';
		counter1 <= "0000";
	end if;
			
end if;

end process;



--once the outputs are stored, next 1d-dwt has to be performed columwise. Refer report for more details.
--this is done using offest addressing.
offsetaddressing : Process(clk,stop_write)
variable offset1,offset2 : std_logic := '0';
begin
if clk'event and clk='1' then
	if stop_write = '1' and offset1 = '0' then
		counter2<="0001";    --start with value at address 1
		read1 <= '1';
		read2 <= '1';
		row_count <= row_count +1;
	end if;
	if row_count /= "0000" and offset2='0' then 
		counter2 <= counter2 + 2;  --now go to address 3
		offset1 := '1';
		read1 <= '1';
		read2 <= '1';
		column_count <= column_count + 1; --take data from address 3,5,7.
	end if;
	if column_count = "0011" then  --once a column stream is given i.e four values again go to address 2
		offset2 := '1';
		counter2 <= "0010";
		read1 <= '1';
		read2 <= '1';
		alt <= '1';
	end if;
	if offset2 = '1' and alt='1' then --take data from address 4,6,8
		counter2 <= counter2 + 2;
		read1 <= '1';
		read2 <= '1';
	end if;
		
end if;
end process;
		
--generates clock pulses of appropriate delay to store the output values file	
Process(clk,stop_write)
variable generate_clk,pulse_count,stop : std_logic := '0';
variable output_count : unsigned(7 downto 0) := x"00";
begin
if clk'event and clk='0' then
	if stop_write = '1' and stop='0' then
		output_count := output_count + 1;
		if output_count = x"03" then
			generate_clk := '1';
		end if;
		if generate_clk = '1' then
			if pulse_count = '0' then
				clk_write <= '1';
			else
				clk_write <= '0';
			end if;
		end if;
		pulse_count := not(pulse_count);  --downsampling by 2 the clk implies indirectly
		if (output_count = x"0B") then  --after 12 output counts stop since clk started at 3, total 4 output values 
			clk_write <= '0';
			stop := '1';
		end if;
	end if;
end if;
end process;
	
			

clk_write_out <= clk_write;
writedata1 <= std_logic_vector(dout_lp);
address1 <="0000" &  std_logic_vector(counter1) when stop_write='0' else "0000" & std_logic_vector(counter2); --switching between reading and writing
writedata2 <= std_logic_vector(dout_hp);
address2 <="0000" &  std_logic_vector(counter1) when stop_write='0' else "0000" & std_logic_vector(counter2);


data_in <= unsigned(readdata) when readdata /= "ZZZZZZZZ" else x"00";
din1<= unsigned(readdata1) when readdata1 /= "ZZZZZZZZ" else x"00";
din2 <= unsigned(readdata2) when readdata2 /= "ZZZZZZZZ" else x"00";

address <= "0000" & std_logic_vector(counter);


end architecture arch;




-------

-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- --library work;
-- --use work.defs.all;

-- entity test1 is
-- end entity;


-- architecture test1_arch of test1 is


-- component test_algo is
-- port (clk,start: in std_logic;ca,ch,cv,cd : out std_logic_vector(7 downto 0));
-- end component;


-- signal clk,start : std_logic:='0';
-- signal ca,ch,cv,cd: std_logic_vector(7 downto 0) := (others=>'0');
-- signal delayed_clk : std_logic := '0';
-- signal counter : unsigned(1 downto 0) := "00";

-- begin

-- uut: component test_algo port map (clk,start,ca,ch,cv,cd);

-- clk<= not(clk) after 20 ns;

-- process
-- begin
-- start <= '0';
-- wait for 40 ns;
-- start <= '1';
-- wait;
-- end process;

-- end architecture test1_arch;