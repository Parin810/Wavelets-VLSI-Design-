library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;
use std.textio.all;

entity top is
port (clk,start : in std_logic; ca,ch,cv,cd : out std_logic_vector(7 downto 0));
end top;


architecture top_arch of top is

component test_algo is
port (clk,start: in std_logic;out_1,out_2,out_3,out_4: out unsigned(7 downto 0);clk_write_out : out std_logic);
end component;

signal start_1,clk_write : std_logic;
signal out_1,out_2,out_3,out_4 : unsigned(7 downto 0);

begin

uut: component test_algo port map ( clk,start_1,out_1,out_2,out_3,out_4,clk_write);

ca <= std_logic_vector(out_1);
ch <= std_logic_vector(out_2);
cv <= std_logic_vector(out_3);
cd <= std_logic_vector(out_4);
start_1 <= start;
	
		
	writeca: process (clk_write)
		file ramOutFile: TEXT open WRITE_MODE is "ca.txt";
		variable myLine : LINE;
		variable myOutputLine : LINE;
		variable sample_count : unsigned(3 downto 0) := x"0";
	begin
			if falling_edge(clk_write) then
					--sample_count := sample_count + 1;
					write(myOutputLine, to_integer(out_1));
					writeline(ramOutFile, myOutputLine);
				end if;
	end process;
	
	writech: process (clk_write)
		file ramOutFile: TEXT open WRITE_MODE is "ch.txt";
		variable myLine : LINE;
		variable myOutputLine : LINE;
		variable sample_count : unsigned(3 downto 0) := x"0";
	begin
			if falling_edge(clk_write) then
					--sample_count := sample_count + 1;
					write(myOutputLine, to_integer((unsigned(out_2))));
					writeline(ramOutFile, myOutputLine);
				end if;
	end process;
	
	writecv: process (clk_write)
		file ramOutFile: TEXT open WRITE_MODE is "cv.txt";
		variable myLine : LINE;
		variable myOutputLine : LINE;
		variable sample_count : unsigned(3 downto 0) := x"0";
	begin
			if falling_edge(clk_write) then
					--sample_count := sample_count + 1;
					write(myOutputLine, to_integer((unsigned(out_3))));
					writeline(ramOutFile, myOutputLine);
				end if;
	end process;
		
		
	writecd: process (clk_write)
		file ramOutFile: TEXT open WRITE_MODE is "cd.txt";
		variable myLine : LINE;
		variable myOutputLine : LINE;
		variable sample_count : unsigned(3 downto 0) := x"0";
	begin
			if falling_edge(clk_write) then
					--sample_count := sample_count + 1;
					write(myOutputLine, to_integer((unsigned(out_4))));
					writeline(ramOutFile, myOutputLine);
				end if;
	end process;	
	
	
	end architecture top_arch;
	
	
	
	
	