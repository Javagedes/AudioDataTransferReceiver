library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity abs_approx is
    Port ( signal_i : in SIGNED (9 downto 0);
           signal_q : in SIGNED (9 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           output : out SIGNED (9 downto 0));
end abs_approx;

architecture Behavioral of abs_approx is
    constant Alpha : SIGNED(13 downto 0) := conv_signed(7767, 14);
    constant Beta  : SIGNED(13 downto 0) := conv_signed(3217, 14);
    signal   A     : SIGNED(23 downto 0);
    signal   B     : SIGNED(23 downto 0);
    signal   O     : SIGNED(23 downto 0);
    signal   I     : SIGNED (9 downto 0);
    signal   Q     : SIGNED (9 downto 0);
    
begin

    process(clk) begin
        I <= abs(signal_i);
        Q <= abs(signal_q);
        if (clk = '1') and (enable = '1') then          
            
            if(I > Q) then
                A <= Alpha*I;
                B <= Beta*Q;
                O <= A + B;
            else
                A <= Alpha*Q;
                B <= Beta*I;
                O <= A + B;
            end if;
            valid_out <= '1';
            output <= O(23 downto 14);
        elsif (clk='1') and (enable = '0') then
            valid_out <= '0';
        end if;
    end process;

end Behavioral;
