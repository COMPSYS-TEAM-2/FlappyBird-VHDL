library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity pipe_passed is
    port (
        I_VSYNC : in STD_LOGIC;
        I_S_X_POS : in STD_LOGIC_VECTOR(10 downto 0);
        I_P_X_A_POS, I_P_X_B_POS : in STD_LOGIC_VECTOR(10 downto 0);
        I_PIPE_WIDTH : in STD_LOGIC_VECTOR(9 downto 0);
        O_PIPE_PASSED : out STD_LOGIC
    );
end pipe_passed;

architecture behaviour of pipe_passed is
    signal L_PIPE_PASS : STD_LOGIC := '0';
begin
    checkpipe_passed : process (I_VSYNC) is
    begin

        if ((I_S_X_POS = I_P_X_A_POS + I_PIPE_WIDTH)) or ((I_S_X_POS <= I_P_X_B_POS + I_PIPE_WIDTH)) then
            L_PIPE_PASS <= '1';
        else
            L_PIPE_PASS <= '0';
        end if;
    end process;
    O_PIPE_PASSED <= L_PIPE_PASS;
end architecture;