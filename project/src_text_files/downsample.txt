library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity downsample is
    Generic (factor : Integer);
    Port ( signal_in : in SIGNED (9 downto 0);
           signal_out : out SIGNED (9 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           valid_out : out STD_LOGIC);
end downsample;

architecture Behavioral of downsample is
signal count : Integer := 1;
begin
    process(clk)
    begin
       if(clk = '1') then
            signal_out <= signal_in;
            if (count = factor) and (enable = '1') then
                valid_out <= '1';
                count <= 1;
            elsif (enable = '1') then
                valid_out <= '0';
                count <= count + 1;
            else
                valid_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;