library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity levelTrig is
    port (
        I_CLK : in std_logic;
        I_TRAINING : in std_logic;
        I_LEVEL : in std_logic_vector(1 downto 0);
        O_REV_GRAVITY : out std_logic;
        O_S_PIPE : out std_logic
    );
end levelTrig;
architecture a of levelTrig is
begin

    levelTrig : process (I_LEVEL)
        variable G_TRIG : std_logic := '0';
        variable P_TRIG : std_logic := '0';
    begin
        if (I_TRAINING = '1') then
            G_TRIG := '0';
            P_TRIG := '0';
        else
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
        end if;
        O_REV_GRAVITY <= G_TRIG;
        O_S_PIPE <= P_TRIG;

    end process;
end architecture;