library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

--This is the upfirdn module
entity upfirdn is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           signal_in : in SIGNED (9 downto 0);
           signal_out : out SIGNED (9 downto 0));
end upfirdn;

architecture Behavioral of upfirdn is
--Wires for connecting the three (up, fir, dn) entities together 
signal w1_signal : SIGNED(9 downto 0);
signal w2_signal : SIGNED(9 downto 0);
signal w1_valid  : STD_LOGIC;
signal w2_valid  : STD_LOGIC;

begin

--upsample
up : entity work.upsample
     Generic Map(factor=>1)
     Port Map(clk => clk, 
              signal_in  => signal_in, 
              signal_out => w1_signal,
              enable     => enable,
              valid_out  => w1_valid);
              
--filter                   
fir : entity work.firfilter
      Generic Map(n=>49, m=>10)
      Port Map(clk=>clk,
               signal_in=>signal_in,
               signal_out=>w2_signal,
               enable=>enable,
               valid_out=>w2_valid);
--downsample
down : entity work.downsample
       Generic Map(factor=>5)
       Port Map(clk => clk,
                signal_in => w2_signal,
                signal_out => signal_out,
                enable => w2_valid,
                valid_out => valid_out);

end Behavioral;