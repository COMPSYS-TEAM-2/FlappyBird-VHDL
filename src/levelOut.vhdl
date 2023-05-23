library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity levelTrig is
    port (
        I_CLK : in STD_LOGIC;
        I_LEVEL : in STD_LOGIC_VECTOR(1 downto 0);
        O_REV_GRAVITY : out STD_LOGIC
    );
end levelTrig;
architecture a of levelTrig is
begin

    levelTrig : process (I_LEVEL)
        variable G_TRIG : STD_LOGIC := '0';
    begin
        case I_LEVEL is

            when "00" => -- score 1-10
					G_TRIG := '0';

            when "01" => -- score 10-20
                G_TRIG := '1';

            when "10" => -- score 20-30
            when "11" => -- score 30-40
            when others => -- score 40+

        end case;

        O_REV_GRAVITY <= G_TRIG;
    end process;
end architecture;