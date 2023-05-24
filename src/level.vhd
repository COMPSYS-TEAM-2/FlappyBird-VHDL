library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity level is
    port (
        I_CLK : in STD_LOGIC;
        I_SCORE : in STD_LOGIC_VECTOR(5 downto 0);
        O_LEVEL : out STD_LOGIC_VECTOR(1 downto 0)
    );
end level;
architecture a of level is

begin
    getlevel : process (I_SCORE)
        variable V_LEVEL : STD_LOGIC_VECTOR(1 downto 0) := "00";
    begin
        case I_SCORE is

            when "000000" =>
                V_LEVEL := "00";

            when "000001" =>
                V_LEVEL := "01";

            when "000010" =>
                V_LEVEL := "10";

            when "000011" =>
                V_LEVEL := "11";

            when others =>
                V_LEVEL := "11";
        end case;
        O_LEVEL <= V_LEVEL;

    end process;
end architecture;