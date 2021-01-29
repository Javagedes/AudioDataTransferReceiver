library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity hilbert_transform is
    Generic(n: INTEGER; m: INTEGER);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           signal_in : in SIGNED (9 downto 0);
           signal_i : out SIGNED (9 downto 0);
           signal_q : out SIGNED (9 downto 0));
end hilbert_transform;

architecture Behavioral of hilbert_transform is
    type coeffecients is array (n-1 downto 0) of signed(m-1 downto 0);
    type registers is array (n-2 downto 0) of signed(m-1 downto 0);
    type shift_reg is array (14 downto 0) of signed(m-1 downto 0);
    signal reg: registers;
    signal shift: shift_reg;
    signal valid: STD_LOGIC;
    
    constant coef: coeffecients := (
conv_signed(-5,m),
conv_signed(0,m),
conv_signed(-4,m),
conv_signed(0,m),
conv_signed(-6,m),
conv_signed(-1,m),
conv_signed(-8,m),
conv_signed(0,m),
conv_signed(-11,m),
conv_signed(0,m),
conv_signed(-16,m),
conv_signed(0,m),
conv_signed(-24,m),
conv_signed(-1,m),
conv_signed(-42,m),
conv_signed(0,m),
conv_signed(-127,m),
conv_signed(0,m),
conv_signed(126,m),
conv_signed(-1,m),
conv_signed(41,m),
conv_signed(0,m),
conv_signed(23,m),
conv_signed(-1,m),
conv_signed(15,m),
conv_signed(-1,m),
conv_signed(10,m),
conv_signed(-1,m),
conv_signed(7,m),
conv_signed(0,m),
conv_signed(5,m),
conv_signed(-1,m),
conv_signed(3,m),
conv_signed(-1,m),
conv_signed(4,m));

begin
    --Shift Register for delay--
    process(clk)
    begin
        if(clk = '1') and (enable = '1') then
            shift <= signal_in & shift(14 downto 1);
        end if;
         signal_i <= shift(0);
    end process;
    
    --filter--
    process(clk)
        variable acc, prod: signed(2*m-1 downto 0) := (others=>'0');
        variable sign: STD_LOGIC;
        variable counter: INTEGER := 0;
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
         signal_q <= acc(2*m-3 downto m-2);
    end process;
     
    --determine if valid--
    --process(clk)
    --begin
    --    if(valid = '1') AND (counter >= 14) then
    --        valid_out <= '1';
    --    else
    --        valid_out <= '0';
    --    end if;
    --end process;
end Behavioral;