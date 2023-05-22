library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;

entity sprite is
    port (
        I_CLK : in std_logic;
        I_X : in std_logic_vector(10 downto 0);
        I_Y : in std_logic_vector(9 downto 0);
        I_PIXEL_ROW : in std_logic_vector(9 downto 0);
        I_PIXEL_COL : in std_logic_vector(10 downto 0);
        I_INDEX : in std_logic_vector(5 downto 0);
        O_ON : out std_logic
    );
end sprite;

architecture behavior of sprite is
    -- Default size of the sprite
    constant spriteSize : integer := 32;
    --640 x 480
    signal font_row : std_logic_vector(2 downto 0); -- row signal 
    signal font_col : std_logic_vector(2 downto 0); -- column signal 
    signal rom_mux_output : std_logic; -- output signal 
    signal L_ON : std_logic;
begin

    char_rom : entity work.char_rom
        port map(
            character_address => I_INDEX,
            font_row => font_row,
            font_col => font_col,
            clock => I_CLK,
            rom_mux_output => rom_mux_output
        );

    get_int_score : process (I_CLK)
        variable temp_col : std_logic_vector(10 downto 0);
        variable temp_row : std_logic_vector(9 downto 0);
    begin
        temp_col := (others => '0');
        temp_row := (others => '0');

        if rising_edge(I_CLK) then
            if ((I_PIXEL_COL >= I_X) and
                (I_PIXEL_COL <= I_X + conv_std_logic_vector(spriteSize, 11))) and
                ((I_PIXEL_ROW >= I_Y) and
                (I_PIXEL_ROW < I_Y + conv_std_logic_vector(spriteSize, 10))) then

                temp_col := (I_PIXEL_COL - I_X - '1');
                font_col <= temp_col(4 downto 2);
                temp_row := (I_PIXEL_ROW - I_Y);
                font_row <= temp_row(4 downto 2);
                L_ON <= '1';
            else
                font_col <= (others => '0');
                font_row <= (others => '0');
                L_ON <= '0';
            end if;
        end if;
    end process;

    O_ON <= rom_mux_output and L_ON;

end architecture;