library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_signed.all;
use work.Rectangle.all;

entity menubutton is
    generic (
        RECT : T_RECT;
        COLOUR : std_logic_vector(11 downto 0) := x"F00"
    );
    port (
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;

        I_M_LEFT : in std_logic;
        I_CURSOR : in T_RECT;

        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic;
        O_CLICK : out std_logic
    );
end menubutton;

architecture behavior of menubutton is
    signal L_CLICK : std_logic;
begin
    click : process (I_V_SYNC)
    begin
        if rising_edge(I_V_SYNC) then
            if I_M_LEFT = '1' then
                if CheckCollision(RECT, I_CURSOR) = '1' then
                    L_CLICK <= '1';
                else
                    L_CLICK <= '0';
                end if;
            else
                L_CLICK <= '0';
            end if;
        end if;
    end process;

    O_CLICK <= L_CLICK;
    O_ON <= CheckCollision(RECT, I_PIXEL);
    O_RGB <= COLOUR when L_CLICK = '0' else
        COLOUR + x"111";
end architecture;