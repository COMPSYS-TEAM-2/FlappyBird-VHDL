library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;

entity stext is
    port (
        I_CLK : in std_logic;
        I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
        I_SCORE : in std_logic_vector(5 downto 0);
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic
    );
end stext;
architecture behavior of stext is
    --640 x 480

    signal font_row : std_logic_vector(2 downto 0); -- row signal 
    signal font_col : std_logic_vector(2 downto 0); -- column signal 
    signal character_address : std_logic_vector(5 downto 0); -- address from MIF 
    signal CHAR_ON : std_logic; -- Character to be written signal 
    signal rom_mux_output : std_logic; -- output signal 
    -- signal L_SCORE : STD_LOGIC_VECTOR(7 downto 0) := I_SCORE;
    -- Initialise as zero so score starts at 000.
    signal L_digit_one : std_logic_vector(5 downto 0);
    --signal L_digit_two : STD_LOGIC_VECTOR(7 downto 0);
    --signal L_digit_three : STD_LOGIC_VECTOR(7 downto 0);
    -- Initialise as address for 0 which is 37 
    signal L_digit_one_address : std_logic_vector(5 downto 0);
    --signal L_digit_two_address : STD_LOGIC_VECTOR(7 downto 0) := conv_std_logic_vector(37, 8);
    --signal L_digit_three_address : STD_LOGIC_VECTOR(7 downto 0) := conv_std_logic_vector(37, 8);

begin

    char_rom : entity work.char_rom
        port map(
            character_address => character_address,
            font_row => font_row,
            font_col => font_col,
            clock => I_CLK,
            rom_mux_output => rom_mux_output
        );

    get_int_score : process (I_CLK)
    begin

        --L_digit_one <= (L_SCORE_INT /100);
        --L_digit_two <=  ((L_SCORE_INT - ((L_SCORE_INT /100)*100)) /10);
        --L_digit_three <= L_SCORE_INT - (((L_SCORE_INT /100) * 100) + ((L_SCORE_INT - (((L_SCORE_INT /100) * 100))) /10) * 10);
        --L_digit_three <= L_digit_three + conv_std_logic_vector(L_SCORE_INT mod 10, 8);
        --L_digit_two <= L_digit_two + conv_std_logic_vector(((L_SCORE_INT / 10)) mod 10, 8);
        --L_digit_one <= L_digit_one + conv_std_logic_vector((L_SCORE_INT / 100), 8);
        if rising_edge(I_CLK) then
            -- if (I_SCORE = "000001") then
            --     L_digit_one_address <= conv_std_logic_vector(38, 6);
            -- elsif (I_SCORE = "000010") then
            --     L_digit_one_address <= conv_std_logic_vector(39, 6);
            -- end if;

            --L_digit_two_address <= L_digit_two_address + L_digit_two;
            --L_digit_three_address <= L_digit_three_address + L_digit_three;

            -- If the pixel cols and rows are within the region we want them displaying in.
            if (((I_PIXEL_ROW >= conv_std_logic_vector(100, 10)) and (I_PIXEL_ROW < conv_std_logic_vector(300, 10))) and
                ((I_PIXEL_COL >= conv_std_logic_vector(48, 10)) and (I_PIXEL_COL < conv_std_logic_vector(300, 10)))) then
                font_col <= I_PIXEL_COL(3 downto 1);
                font_row <= I_PIXEL_ROW(3 downto 1);

                if (((I_PIXEL_ROW >= conv_std_logic_vector(112, 10)) and (I_PIXEL_ROW < conv_std_logic_vector(124, 10))) and
                    ((I_PIXEL_COL >= conv_std_logic_vector(52, 10)) and (I_PIXEL_COL < conv_std_logic_vector(64, 10)))) then

                    character_address <= conv_std_logic_vector(48, 6); -- First digit (hundreds digit)

                    CHAR_ON <= '1';
                else
                    CHAR_ON <= '0';
                end if;
            else
                CHAR_ON <= '0';
            end if;
        end if;
    end process;

    O_RGB <= x"fff";
    O_ON <= rom_mux_output and CHAR_ON;

end architecture;