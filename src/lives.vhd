library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity lives is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        I_PipePassed : in std_logic;
        I_Collision : in std_logic;
        I_ADD_LIFE : in std_logic;
        I_SHEILD : in std_logic;
        O_LIVES : out std_logic_vector(17 downto 0);
        O_GAME_OVER : out std_logic
    );
end entity lives;

architecture behavior of lives is
    constant LIVE_INDEX : std_logic_vector(5 downto 0) := o"47";
    constant EMPTY_INDEX : std_logic_vector(5 downto 0) := o"44";

    signal L_LIVES : std_logic_vector(1 downto 0) := "11";
begin
    process (I_CLK)
        variable COLLIDED : std_logic := '0';
    begin
        if (rising_edge(I_CLK)) then
            if (I_RST = '1') then
                L_LIVES <= "11";
                COLLIDED := '0';
            elsif (I_ADD_LIFE = '1') then
                if (L_LIVES /= "11") then
                    L_LIVES <= L_LIVES + 1;
                end if;
            else
                if (I_Collision = '1' and COLLIDED = '0' and I_SHEILD = '0') then
                    if (L_LIVES /= "00") then
                        L_LIVES <= L_LIVES - 1;
                    end if;
                    COLLIDED := '1';
                elsif (I_PipePassed = '1') then
                    COLLIDED := '0';
                end if;
            end if;
        end if;
    end process;

    O_LIVES(17 downto 12) <= LIVE_INDEX when (L_LIVES >= 1) else
    EMPTY_INDEX;
    O_LIVES(11 downto 6) <= LIVE_INDEX when (L_LIVES >= 2) else
    EMPTY_INDEX;
    O_LIVES(5 downto 0) <= LIVE_INDEX when (L_LIVES >= 3) else
    EMPTY_INDEX;

    O_GAME_OVER <= '1' when L_LIVES = "00" else
        '0';
end architecture;