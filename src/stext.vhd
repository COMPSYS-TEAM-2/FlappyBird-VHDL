library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;

entity stext is
    generic (
        X : integer;
        Y : integer;
        SCALE : integer;
        NUM_CHARS : integer
    );
    port (
        I_CLK : in std_logic;
        I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
        I_CHARS : in std_logic_vector((6 * NUM_CHARS - 1) downto 0);
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic
    );
end stext;

architecture behavior of stext is

    --640 x 480
    constant DEFAULT_SIZE : integer := 8;
    constant SCALED_SIZE : integer := DEFAULT_SIZE * (2 ** (SCALE - 1));
    signal font_row : std_logic_vector(2 downto 0); -- row signal 
    signal font_col : std_logic_vector(2 downto 0); -- column signal 
    signal rom_mux_output : std_logic; -- output signal 
    signal L_CHAR : std_logic_vector(5 downto 0);

begin

    char_rom : entity work.char_rom
        port map(
            character_address => L_CHAR,
            font_row => font_row,
            font_col => font_col,
            clock => I_CLK,
            rom_mux_output => rom_mux_output
        );

    get_int_score : process (I_CLK)
        variable temp_col : std_logic_vector(10 downto 0);
        variable temp_row : std_logic_vector(9 downto 0);
    begin
        if rising_edge(I_CLK) then

            for i in 0 to NUM_CHARS - 1 loop
                if ((I_PIXEL_COL >= conv_std_logic_vector(X + (SCALED_SIZE * i), 11)) and
                    (I_PIXEL_COL < conv_std_logic_vector(X + (SCALED_SIZE * (i + 1)), 11))) and
                    ((I_PIXEL_ROW >= conv_std_logic_vector(Y, 10)) and
                    (I_PIXEL_ROW < conv_std_logic_vector(Y + SCALED_SIZE, 10))) then

                    temp_col := (I_PIXEL_COL - conv_std_logic_vector(X, 11));
                    font_col <= temp_col((SCALE + 1) downto (SCALE - 1));
                    temp_row := (I_PIXEL_ROW - conv_std_logic_vector(Y, 10));
                    font_row <= temp_row((SCALE + 1) downto (SCALE - 1));

                    L_CHAR <= I_CHARS((6 * (NUM_CHARS - i) - 1) downto (6 * (NUM_CHARS - i - 1)));
                end if;
            end loop;
        end if;
    end process;

    O_RGB <= x"fff";
    O_ON <= rom_mux_output;

end architecture;