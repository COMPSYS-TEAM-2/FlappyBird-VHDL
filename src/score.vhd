library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_unsigned.all;

entity score is
    port (
        I_CLK : in std_logic;
        I_PipePassed : in std_logic; -- INPUT FROM PIPE BEING PASSED
        I_Collision : in std_logic;
        O_ONES : out std_logic_vector(5 downto 0); -- OUTPUT FOR DISPLAYSCORE.VHD
        O_TENS : out std_logic_vector(5 downto 0) -- OUTPUT FOR DISPLAYSCORE.VHD
    );
end entity score;
architecture behavioral of score is
    signal L_ONES : std_logic_vector(3 downto 0) := conv_std_logic_vector(0, 4);
    signal L_TENS : std_logic_vector(3 downto 0) := conv_std_logic_vector(0, 4);

begin
    -- PROCESS TO UPDATE THE SCORE
    process (I_CLK)
        variable L_COLLIDED : std_logic := '0';
        variable L_INCREMENTED : std_logic := '0';
    begin
        if (rising_edge(I_CLK)) then
            if (I_PipePassed = '1') then
                if (L_INCREMENTED = '0') then
                    L_ONES <= L_ONES + 1;
                end if;
                L_INCREMENTED := '1';
            else
                L_INCREMENTED := '0';
            end if;
        end if;
    end process;

    O_ONES <= o"60" + L_ONES;
    O_TENS <= o"60" + L_TENS;
end architecture;