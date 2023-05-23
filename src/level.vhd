library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity level is
    port (
        I_CLK : in STD_LOGIC;
        I_SCORE : in STD_LOGIC_VECTOR(5 downto 0);
        O_LEVEL : out STD_LOGIC
    );
end level;
architecture a of level is

begin
    getlevel : process (I_SCORE)
        variable V_LEVEL : STD_LOGIC := '0';
    begin
        case I_SCORE is
            when "000001" =>
                V_LEVEL := '1';

            when others =>
                V_LEVEL := '0';
        end case;
        O_LEVEL <= V_LEVEL;
    end process;
end architecture;