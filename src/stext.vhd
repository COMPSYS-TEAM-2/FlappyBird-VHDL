library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;

entity stext is
    port (
        I_CLK : in STD_LOGIC;
        I_PIXEL_ROW, I_PIXEL_COL : in STD_LOGIC_VECTOR(9 downto 0);
        I_SCORE : in STD_LOGIC_VECTOR(5 downto 0);
        O_RGB : out STD_LOGIC_VECTOR(11 downto 0);
        O_ON : out STD_LOGIC
    );
end stext;
architecture behavior of stext is
    --640 x 480
    component char_rom
        port (
            character_address : in STD_LOGIC_VECTOR (5 downto 0);
            font_row, font_col : in STD_LOGIC_VECTOR (2 downto 0);
            clock : in STD_LOGIC;
            rom_mux_output : out STD_LOGIC
        );
    end component;

    signal font_row : STD_LOGIC_VECTOR(2 downto 0); -- row signal 
    signal font_col : STD_LOGIC_VECTOR(2 downto 0); -- column signal 
    signal character_address : STD_LOGIC_VECTOR(5 downto 0); -- address from MIF 
    signal CHAR_ON : STD_LOGIC; -- Character to be written signal 
    signal rom_mux_output : STD_LOGIC; -- output signal 
    -- signal L_SCORE : STD_LOGIC_VECTOR(7 downto 0) := I_SCORE;
    -- Initialise as zero so score starts at 000.
    signal L_digit_one : STD_LOGIC_VECTOR(5 downto 0);
    --signal L_digit_two : STD_LOGIC_VECTOR(7 downto 0);
    --signal L_digit_three : STD_LOGIC_VECTOR(7 downto 0);
    -- Initialise as address for 0 which is 37 
    signal L_digit_one_address : STD_LOGIC_VECTOR(5 downto 0) ;
    --signal L_digit_two_address : STD_LOGIC_VECTOR(7 downto 0) := conv_std_logic_vector(37, 8);
    --signal L_digit_three_address : STD_LOGIC_VECTOR(7 downto 0) := conv_std_logic_vector(37, 8);

begin

    char : char_rom port map(
        character_address => character_address,
        font_row => font_row,
        font_col => font_col,
        clock => I_CLK,
        rom_mux_output => rom_mux_output
    );

    get_int_score : process (I_SCORE)
    begin

        --L_digit_one <= (L_SCORE_INT /100);
        --L_digit_two <=  ((L_SCORE_INT - ((L_SCORE_INT /100)*100)) /10);
        --L_digit_three <= L_SCORE_INT - (((L_SCORE_INT /100) * 100) + ((L_SCORE_INT - (((L_SCORE_INT /100) * 100))) /10) * 10);
        --L_digit_three <= L_digit_three + conv_std_logic_vector(L_SCORE_INT mod 10, 8);
        --L_digit_two <= L_digit_two + conv_std_logic_vector(((L_SCORE_INT / 10)) mod 10, 8);
        --L_digit_one <= L_digit_one + conv_std_logic_vector((L_SCORE_INT / 100), 8);
          
          if (I_SCORE = "000001") then
					L_digit_one_address <= conv_std_logic_vector(38 , 6);
            elsif (I_SCORE = "000010") then 
					L_digit_one_address <= conv_std_logic_vector(39 , 6);
            end if;
			
        --L_digit_two_address <= L_digit_two_address + L_digit_two;
        --L_digit_three_address <= L_digit_three_address + L_digit_three;

        -- If the pixel cols and rows are within the region we want them displaying in.
        if (((I_PIXEL_ROW >= conv_std_logic_vector(100, 10)) and (I_PIXEL_ROW < conv_std_logic_vector(300, 10))) and
            ((I_PIXEL_COL >= conv_std_logic_vector(50, 10)) and (I_PIXEL_COL < conv_std_logic_vector(300, 10)))) then
            font_col <= I_PIXEL_COL(2 downto 0);
            font_row <= I_PIXEL_ROW(2 downto 0);

            if (((I_PIXEL_ROW >= conv_std_logic_vector(40, 10)) and (I_PIXEL_ROW < conv_std_logic_vector(60, 10))) and
                ((I_PIXEL_COL >= conv_std_logic_vector(20, 10)) and (I_PIXEL_COL < conv_std_logic_vector(40, 10)))) then

                character_address <= L_digit_one_address; -- First digit (hundreds digit)
                CHAR_ON <= '1';

            end if;
        end if;
    end process;

    O_RGB <= x"fff";
    O_ON <= '1' when (CHAR_ON = '1');

end architecture;