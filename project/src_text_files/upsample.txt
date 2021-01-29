library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity upsample is
    Generic (factor : Integer);
    Port ( signal_in : in SIGNED (9 downto 0);
           signal_out : out SIGNED (9 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           valid_out : out STD_LOGIC);
end upsample;

architecture Behavioral of upsample is
signal zeros : Integer;
begin
    process(clk)
    begin      
        if (clk = '1') then
            --If Enable is set true, push the signal through, then set zeros to the factor.
            if(enable = '1') then
                signal_out <= signal_in;
                valid_out <= '1';
                zeros <= factor - 1;
            --When zeros is not 0, it means we need to push zeros through. so push it through and decrease it by one. 
            elsif (zeros /= 0) then
                signal_out <= "0000000000";
                valid_out <= '1';
                zeros <= zeros - 1;
            --Any other time, set valid_out to zero so that future modules know the data is bad and to ignore it.
            else 
                valid_out <= '0';
                --signal_out <= signal_in;
            end if;        
        end if;
    end process;
end Behavioral;