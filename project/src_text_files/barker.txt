
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.math_real."floor";

entity barker is
    Generic(n: INTEGER; m: INTEGER);
    Port ( signal_in : in SIGNED (m-1 downto 0);
           signal_out : out SIGNED (m-1 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           valid_out : out STD_LOGIC);
end barker;

architecture Behavioral of barker is
    type registers is array (n-2 downto 0) of signed(m-1 downto 0);
    type coeffecients is array (n-1 downto 0) of signed(m-1 downto 0);
    
    signal reg: registers;
    
    --Coeffecients, divided by two and scaled by 2^12
    --Resulting data is then multiplied by two and divded by 2^12 later in matlab
--    constant coef: coeffecients := (
--conv_signed(1,m),
--conv_signed(-1,m),
--conv_signed(1,m),
--conv_signed(-1,m),
--conv_signed(1,m),
--conv_signed(1,m),
--conv_signed(-1,m),
--conv_signed(-1,m),
--conv_signed(1,m),
--conv_signed(1,m),
--conv_signed(1,m),
--conv_signed(1,m),
--conv_signed(1,m));

    constant coef: coeffecients := (
conv_signed(1,m),
conv_signed(1,m),
conv_signed(1,m),
conv_signed(1,m),
conv_signed(1,m),
conv_signed(-1,m),
conv_signed(-1,m),
conv_signed(1,m),
conv_signed(1,m),
conv_signed(-1,m),
conv_signed(1,m),
conv_signed(-1,m),
conv_signed(1,m));
begin
    process(clk)
        variable acc, prod: signed(2*m-1 downto 0) := (others=>'0');
        variable sign: STD_LOGIC;
        variable counter: INTEGER:= 0;
    begin
        if(clk = '1') and (enable = '1') then
            if(counter > n-2) then
                valid_out <= '1';
            else
                valid_out <= '0';
            end if;
            
            if(counter < n-1) then
                counter := counter + 1;
            end if;
            
            --valid_out <= '1';
            acc := coef(0)*signal_in;
            for i in 1 to n-1 loop
                sign := acc(2*m-1);
                prod := coef(i)*reg(n-1-i);
                acc  := acc + prod;
                --ovefflow check?---
                if sign = (prod(prod'left)) and (acc(acc'left) /= sign) then
                    acc := (acc'left => sign, others => not sign);
                end if;
             end loop;
             reg <= signal_in & reg(n-2 downto 1);
         elsif(enable = '0') and (clk = '1') then
            valid_out <= '0';
         end if;
         signal_out <= acc(m-1 downto 0);
     end process;
            
end Behavioral;