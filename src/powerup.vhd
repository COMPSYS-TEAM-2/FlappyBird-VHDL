library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;
use work.Constantvalues.all;

entity powerup is
    port (
        I_V_SYNC : in std_logic;
        I_BIRD : in T_RECT;
        I_POWERUP : in T_RECT;
        I_POWERUP_TYPE : in std_logic_vector(5 downto 0);
        O_ADD_LIFE : out std_logic;
        O_SLOW_TIME : out std_logic;
        O_SHEILD : out std_logic;
        O_COLLISION : out std_logic
    );
end entity powerup;

architecture behaviour of powerup is
    signal L_ADD_LIFE : std_logic := '0';
    signal L_SLOW_TIME : std_logic := '0';
    signal L_SHEILD : std_logic := '0';
    signal L_COLLISION : std_logic := '0';
begin
    process (I_V_SYNC)
    begin
        if (rising_edge(I_V_SYNC)) then
            if (checkCollision(I_BIRD, I_POWERUP) = '1') then
                if (I_POWERUP_TYPE = HEART_POWERUP) then
                    L_ADD_LIFE <= '1';
                elsif (I_POWERUP_TYPE = CLOCK_POWERUP) then
                    L_SLOW_TIME <= '1';
                elsif (I_POWERUP_TYPE = SHEILD_POWERUP) then
                    L_SHEILD <= '1';
                end if;
                L_COLLISION <= '1';
            else
                L_ADD_LIFE <= '0';
                L_SLOW_TIME <= '0';
                L_SHEILD <= '0';
                L_COLLISION <= '0';
            end if;
        end if;
    end process;
    O_ADD_LIFE <= L_ADD_LIFE;
    O_SLOW_TIME <= L_SLOW_TIME;
    O_SHEILD <= L_SHEILD;
    O_COLLISION <= L_COLLISION;
end architecture;