library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity top_wavelet is
port
( clk : in std_logic;
in_data : in unsigned (7 downto 0);
out_data_1 : out unsigned (7 downto 0);
out_data_2 : out unsigned (7 downto 0);
input_length : integer range 0 to length 
);
end entity;

architecture top_wavelet_arch of top_wavelet is
signal dout_lp,dout_hp,out_hp,out_lp : unsigned (7 downto 0);
signal clock_divide_2 : std_logic;
signal counter : unsigned(1 downto 0) := (others => '0');
signal data_ready : std_logic := '0';
signal delayed_clk,clk_1 : std_logic:='0';

component lowpassfilter
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end component;

component down_sampler 
port (clk : in std_logic; 
in_lp : in unsigned(7 downto 0);
in_hp: in unsigned(7 downto 0);
out_lp: out unsigned(7 downto 0);
out_hp : out unsigned(7 downto 0)
);
end component;

--component output_ram 
--port ( clk : in std_logic;
--read : in std_logic;
--write : in std_logic;
--writedata : in unsigned(7 downto 0);
--readdata : out unsigned(7 downto 0);
--address : in unsigned(7 downto 0)
--);

begin

filter : component  lowpassfilter port map( clk, in_data, dout_lp, dout_hp);



downsample: component  down_sampler port map (delayed_clk,dout_lp,dout_hp,out_lp,out_hp);

process(delayed_clk)  --divide clock
begin
if (delayed_clk'event and delayed_clk='1') then
	counter <= counter + 1;
end if;
end process;

clock_divide_2 <= counter(0);


process(clk)
begin
if (clk'event) then
	clk_1 <= clk;
	delayed_clk <= clk_1;
	
end if;
end process;
	

	
process(clk) --count convolution length
variable length_count : integer;
begin
if (clk'event and clk='1') then
		length_count := length_count + 1;
		if (length_count = max_length) then
			data_ready <= '1';
		else
			data_ready <= '0';
		end if;
end if;
end process;


end architecture top_wavelet_arch;





