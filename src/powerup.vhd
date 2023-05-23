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
        O_POWERUP : out T_RECT;
        O_ADD_LIFE : out std_logic
    );
end entity powerup;

architecture behaviour of powerup is
    signal L_ADD_LIFE : std_logic := '0';
    signal L_POWERUP : T_RECT := I_POWERUP;
begin
    process (I_V_SYNC)
    begin
        if (rising_edge(I_V_SYNC)) then
            if (checkCollision(I_BIRD, I_POWERUP) = '1') then
                if (I_POWERUP_TYPE = HEART_POWERUP) then
                    L_ADD_LIFE <= '1';
                    L_POWERUP.Y <= conv_std_logic_vector(500, 10);
                end if;
            else
                L_ADD_LIFE <= '0';
            end if;
        end if;
    end process;
    O_ADD_LIFE <= L_ADD_LIFE;
    O_POWERUP <= L_POWERUP;
end architecture;