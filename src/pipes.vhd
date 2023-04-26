library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity pipes is
	port (
		I_V_SYNC : in std_logic;
		I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic
	);
end pipes;

architecture behavior of pipes is
    constant PIPE_GAP : std_logic_vector(9 downto 0) := conv_std_logic_vector(100, 10);
    constant PIPE_GAP_POSITION : std_logic_vector(9 downto 0) := conv_std_logic_vector(220, 10);
    constant PIPE_WIDTH : std_logic_vector(9 downto 0) := conv_std_logic_vector(20, 10);
    -- constant ACCELLERATION : std_logic_vector(9 downto 0) := conv_std_logic_vector(0, 0);

	signal L_X_POS : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(639, 11);
	signal L_Y_POS : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);

begin
	Move_pipes : process (I_V_SYNC)
		variable X_POS : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(639, 11);
		variable X_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(1, 10);
	begin
		-- Move pipe once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			X_POS := L_X_POS - X_VEL;
            if (X_POS <= 0) then
                X_POS := CONV_STD_LOGIC_VECTOR(639, 11);
            end if;
			L_X_POS <= X_POS;
		end if;
	end process Move_pipes;

	O_ON <= '1' when (('0' & L_X_POS <= '0' & I_PIXEL_COL + PIPE_WIDTH) and ('0' & I_PIXEL_COL <= '0' & L_X_POS + PIPE_WIDTH) -- x_pos - size <= pixel_column <= x_pos + size
		and (('0' & I_PIXEL_ROW <= PIPE_GAP_POSITION - PIPE_GAP) or  ('0' & I_PIXEL_ROW >= PIPE_GAP_POSITION + PIPE_GAP))) else -- y_pos - size <= pixel_row <= y_pos + size
		'0';

	O_RGB <= x"5E2";

end behavior;