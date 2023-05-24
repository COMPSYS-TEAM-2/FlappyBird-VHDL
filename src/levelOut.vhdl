library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity levelTrig is
    port (
        I_CLK : in STD_LOGIC;
        I_LEVEL : in STD_LOGIC_VECTOR(1 downto 0);
        O_REV_GRAVITY : out STD_LOGIC;
        O_S_PIPE : out STD_LOGIC
    );
end levelTrig;
architecture a of levelTrig is
begin

    levelTrig : process (I_LEVEL)
        variable G_TRIG : STD_LOGIC := '0';
        variable P_TRIG : STD_LOGIC := '0';
    begin
        case I_LEVEL is

            when "00" => -- score 1-10
                G_TRIG := '0';
                P_TRIG := '0';

            when "01" => -- score 10-20
                G_TRIG := '1';
                P_TRIG := '0';

            when "10" => -- score 20-30
                G_TRIG := '0';
                P_TRIG := '1';

            when others => -- score 30-40
                G_TRIG := '1';
                P_TRIG := '1';

        end case;

        O_REV_GRAVITY <= G_TRIG;
        O_S_PIPE <= P_TRIG;

    end process;
end architecture;