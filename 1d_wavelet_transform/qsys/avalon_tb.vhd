library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_tb is
end entity avalon_tb;

architecture simple of avalon_tb is

component avalon_interface is
   port (
      clk, reset    : in  std_logic;
      address       : in  std_logic_vector (5 downto 0);
      read          : in  std_logic;
      readdata      : out std_logic_vector (31 downto 0);
      write         : in  std_logic;
      writedata     : in  std_logic_vector (31 downto 0)
   );
end component;

  signal clk, reset, read, write : std_logic := '0' ;
  signal address                 : std_logic_vector (5 downto 0);
  signal readdata, writedata     : std_logic_vector (31 downto 0);

  procedure iowrite (signal write           : out std_logic;
                     signal writedata       : out std_logic_vector (31 downto 0);
                     signal address         : out std_logic_vector (5 downto 0);
                            address_value   :     std_logic_vector (5 downto 0);
                            data            :     std_logic_vector (31 downto 0)) is
  begin
    wait for 80 ns;
    address   <= address_value;
    writedata <= data;
    write     <= '1';
    wait for 0 ns;
    report "iowrite : address [" & integer'image (to_integer (unsigned (address_value))) & "], "
                 & "writedata [" & integer'image (to_integer (unsigned (data))) & "]";
    wait for 40 ns;
    write     <= '0';
    wait for 0 ns;
  end procedure;

  procedure ioread  (signal read            : out std_logic;
                     signal readdata        : in  std_logic_vector (31 downto 0);
                     signal address         : out std_logic_vector (5 downto 0);
                            address_value   : in  std_logic_vector (5 downto 0);
                            readdata_value  : out std_logic_vector (31 downto 0)) is
  begin
    wait for 80 ns;
    address   <= address_value;
    read      <= '1';
    wait for 0 ns;
    wait for 41 ns;
    report "ioread : address [" & integer'image (to_integer (unsigned (address_value))) & "], "
                  & "readdata [" & integer'image (to_integer (unsigned (readdata(7 downto 0)))) & "]"
	 & "readdata [" & integer'image (to_integer (unsigned (readdata(15 downto 8)))) & "]";
    readdata_value := readdata;
    read     <= '0';
    wait for 39 ns;
  end procedure;

begin
  uut : avalon_interface port map (clk=>clk, reset=>reset, address=>address, read=>read, readdata => readdata, write=>write, writedata=>writedata);

  clk   <= not clk after 20 ns ;
  reset <= '1' after 0 ns , '0' after 80 ns;

  process
    variable readdata_value : std_logic_vector (31 downto 0);
  begin
    
 
    loop 
        ioread (read, readdata, address, "000001", readdata_value);
        exit when readdata_value(15 downto 0) /= x"0000";
    end loop;

    -- 4. read and display output values
    for i in 1 to 8 loop
        ioread (read, readdata, address, std_logic_vector (to_unsigned (i, 6)), readdata_value);
    end loop;
    wait ;
  end process ;
  
end architecture simple;