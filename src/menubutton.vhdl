library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_signed.all;
use work.Rectangle.all;
use work.RGBValues.MENU_BUTTON_ONCLICK_RGB;

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
    signal L_STATE : std_logic_vector(1 downto 0) := "00";
    signal L_M_UP : std_logic := '0';
    signal L_M_DOWN : std_logic := '0';
begin
    click : process (I_V_SYNC)
    begin
        if (rising_edge(I_V_SYNC)) then
            case L_STATE is
                when "00" => -- Default
                    L_M_UP <= '0';
                    L_M_DOWN <= '0';
                    if (I_M_LEFT = '1' and CheckCollision(RECT, I_CURSOR) = '1') then
                        L_STATE <= "01";
                    end if;
                when "01" => -- Mouse Down and Over Button
                    L_M_UP <= '0';
                    L_M_DOWN <= '1';
                    if (I_M_LEFT = '0' and CheckCollision(RECT, I_CURSOR) = '1') then
                        L_STATE <= "10";
                    elsif (CheckCollision(RECT, I_CURSOR) = '0') then
                        L_STATE <= "00";
                    end if;
                when "10" => -- Mouse Up and Over Button
                    L_M_UP <= '1';
                    L_M_DOWN <= '0';
                    L_STATE <= "00";
                when others =>
                    L_M_UP <= '0';
                    L_M_DOWN <= '0';
                    L_STATE <= "00";
            end case;
        end if;
    end process;
    O_CLICK <= L_M_UP;
    O_ON <= CheckCollision(RECT, I_PIXEL);
    O_RGB <= COLOUR when L_M_DOWN = '0' else
        (MENU_BUTTON_ONCLICK_RGB);
end architecture;