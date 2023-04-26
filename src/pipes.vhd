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
    -- constant COLOR : std_logic_vector(12 downto 0) := conv_std_logic_vector(1506, 12);
	constant PIPE_HEIGHT : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);
    constant PIPE_WIDTH : std_logic_vector(9 downto 0) := conv_std_logic_vector(20, 10);
    -- constant ACCELLERATION : std_logic_vector(9 downto 0) := conv_std_logic_vector(0, 0);

	signal L_X_POS : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(639, 11);
	signal L_Y_POS : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10) - PIPE_HEIGHT;

begin
	Move_pipes : process (I_V_SYNC)
		variable X_POS : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(639, 11);
		variable X_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(10, 10);
	begin
		-- Move square once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			X_POS := L_X_POS - X_VEL;
			L_X_POS <= X_POS;
		end if;
	end process Move_pipes;

	O_ON <= '1' when (('0' & L_X_POS <= '0' & I_PIXEL_COL + PIPE_WIDTH) and ('0' & I_PIXEL_COL <= '0' & L_X_POS + PIPE_WIDTH) -- x_pos - size <= pixel_column <= x_pos + size
		and ('0' & L_Y_POS <= I_PIXEL_ROW + PIPE_HEIGHT) and ('0' & I_PIXEL_ROW <= L_Y_POS + PIPE_HEIGHT)) else -- y_pos - size <= pixel_row <= y_pos + size
		'0';

	-- Colours for pixel data on video signal
	-- Changing the background and ball colour by pushbuttons
	O_RGB <= x"5E2";

end behavior;