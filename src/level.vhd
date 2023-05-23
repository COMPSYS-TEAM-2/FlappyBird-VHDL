library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity level is
    port (
        I_CLK : in STD_LOGIC;
        I_SCORE : in STD_LOGIC;
        O_LEVEL : out STD_LOGIC
    );
end level;
architecture a of level is

begin
    getlevel : process (I_CLK, I_SCORE)
        variable V_SCORE : INTEGER := 1;
        variable V_LEVEL : STD_LOGIC := '0';
    begin
        if rising_edge(I_CLK) then
            if I_SCORE = '1' then
                V_SCORE := V_SCORE + 1;
            end if;

            if V_SCORE = 5 then
                V_LEVEL := '1';
                V_SCORE := 0;
            else
                V_LEVEL := '0';
            end if;

            if V_SCORE = 1 then
                if V_LEVEL = '1' then
                    O_LEVEL <= '1';
                else
                    O_LEVEL <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;