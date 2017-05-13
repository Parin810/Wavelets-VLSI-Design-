library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity control_fsm is
port (clk,start,reset : in std_logic; status,data_stored: in std_logic; ready,read_row,out_clear : out std_logic; state : out smstate);
end control_fsm;


architecture main_arch of control_fsm is
signal next_state, present_state : smstate := idle;

begin

--fsm synchronous
process(clk,reset)
begin
if reset='1' then
	present_state <= idle;
	out_clear <= '1';
elsif clk'event and clk='1' then
	present_state <= next_state;
	out_clear <= '0';
end if;
end process;

state <= present_state;


--fsm combinational
Process(present_state,status,start)
begin
case present_state is
when idle => ready <= '0'; read_row <= '0'; if start = '1' then next_state <= compute; else next_state <= idle; end if;

when compute => 
	--out_clear<='0';
	read_row <= '0';
	ready <= '0';
	if status = '1' then
		next_state <= row_done;
	else
		next_state <= compute;
	end if;
	
when row_done =>
	ready <= '1'; 
	read_row <= '1';
	next_state <= idle;
	
when others => next_state <= idle;

end case;

end process;

end architecture main_arch;

	
	
 







