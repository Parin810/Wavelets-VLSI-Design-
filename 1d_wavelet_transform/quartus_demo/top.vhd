library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;


entity top is
port (clk,start : in std_logic; ca,ch: out std_logic_vector(7 downto 0);
read_in:in std_logic;
address_in : in std_logic_vector(5 downto 0);
readdata1 : out std_logic_vector(15 downto 0);
writedata1 : in std_logic_vector(7 downto 0);
clk_write : out std_logic;ready: out std_logic);
end top;


architecture top_arch of top is


signal dout_hp,dout_lp,ca1,ch1,cv1,cd1: unsigned(7 downto 0);
signal out_hp_1,out_lp_1,din : unsigned(7 downto 0);
signal delayed_clk : std_logic;
signal data_in : std_logic_vector(7 downto 0);

component controlunit is
port (clk,start: in std_logic; state : in smstate; read_row: in std_logic;
address_in : in std_logic_vector(5 downto 0);data : out std_logic_vector(15 downto 0); 
status: out std_logic);
end component;

component control_fsm is
port (clk,start,reset : in std_logic; status,data_stored: in std_logic; ready,read_row,out_clear : out std_logic; state: out smstate);
end component;

component filter is
port ( clk : in std_logic;
din : in unsigned (7 downto 0);
dout_lp : out unsigned (7 downto 0);
dout_hp : out unsigned (7 downto 0)
);
end component;

signal reset,read_row,data_stored : std_logic;
signal out_clear, status: std_logic;
signal state_pass : smstate;
signal ready1,clk_out : std_logic;

begin

reset <= '0';
din <= unsigned(data_in);
ready <= status;

data_controller :component controlunit port map (clk,start, state_pass,read_row,address_in,readdata1,status);

fsm : component control_fsm port map (clk, start, reset, status, data_stored, ready1, read_row,out_clear, state_pass);


end architecture top_arch;












