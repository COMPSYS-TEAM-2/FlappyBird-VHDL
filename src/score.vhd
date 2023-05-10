library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_SIGNED.all;

entity score is
    port (
        i_pipePassed : in STD_LOGIC; -- INPUT FROM PIPE BEING PASSED
        i_collision : in STD_LOGIC;
        o_screenScore : out STD_LOGIC_VECTOR(5 downto 0) -- OUTPUT FOR DISPLAYSCORE.VHD
    );
end entity score;


architecture behavioral of score is
    signal L_SCORE : STD_LOGIC_VECTOR(5 downto 0) := conv_std_logic_vector(0, 6);
	 
begin
    -- PROCESS TO UPDATE THE SCORE
    updateScore_collision : process (i_collision, i_pipePassed)
    begin
        if (i_pipePassed = '1') then
            L_SCORE <= L_SCORE + conv_std_logic_vector(1, 6);
        elsif ((i_collision = '1') and (L_SCORE > conv_std_logic_vector(0, 6))) then
            L_SCORE <= L_SCORE - conv_std_logic_vector(1, 6);
        end if;
    end process updateScore_collision;

    o_screenScore <= L_SCORE;

end architecture;