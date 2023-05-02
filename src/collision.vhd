library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity collision is
    port (
        I_VSYNC : in std_logic;
        I_S_X_POS, I_S_Y_POS : in std_logic_vector(10 downto 0);
        I_S_SIZE : in std_logic_vector(9 downto 0);
        I_P_X_A_POS, I_P_X_B_POS : in std_logic_vector(10 downto 0);
        I_A_PIPE_GAP_POS, I_B_PIPE_GAP_POS : in std_logic_vector(9 downto 0);
        I_PIPE_GAP, I_PIPE_WIDTH : in std_logic_vector(9 downto 0);
        O_COL : out std_logic
    );
end collision;

architecture behaviour of collision is

begin
    checkCollision : process (I_VSYNC) is
    variable counter : std_logic_vector(4 downto 0);
        begin
    end process;
end architecture;