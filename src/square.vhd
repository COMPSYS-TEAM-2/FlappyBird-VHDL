library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity square is
	port (
		I_PB1, I_PB2, I_V_SYNC, I_CLICK : in std_logic;
		I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
		O_RED, O_GREEN, O_BLUE : out std_logic);
end square;

architecture behavior of square is
	constant GRAVITY : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(1, 10);
	constant SIZE : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(8, 10);

	signal L_ON : std_logic;

	signal L_X_POS : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(200, 11);
	signal L_Y_POS : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10) - SIZE;

begin
	Move_Ball : process (I_V_SYNC)
		variable Y_POS : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10) - SIZE;
		variable Y_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);
	begin
		-- Move square once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (I_CLICK = '1' and Y_VEL >= CONV_STD_LOGIC_VECTOR(2, 10)) then
				Y_VEL := - CONV_STD_LOGIC_VECTOR(12, 10);
			else
				Y_VEL := Y_VEL + gravity;
				if (Y_VEL > gravity(5 downto 0) & "0000") then
					Y_VEL := gravity(5 downto 0) & "0000";
				end if;
			end if;

			Y_POS := L_Y_POS + Y_VEL;
			if (Y_POS >= CONV_STD_LOGIC_VECTOR(479, 10) - SIZE) then
				Y_POS := CONV_STD_LOGIC_VECTOR(479, 10) - SIZE;
			elsif (Y_POS <= CONV_STD_LOGIC_VECTOR(0, 10) + SIZE) then
				Y_POS := CONV_STD_LOGIC_VECTOR(0, 10) + SIZE;
			end if;
			L_Y_POS <= Y_POS;
		end if;
	end process Move_Ball;

	-- click : process (I_CLICK)
	-- begin
	-- 	if (rising_edge(I_CLICK)) then
	-- 		L_CLICK <= '1';
	-- 	end if;
	-- end process;

	L_ON <= '1' when (('0' & L_X_POS <= '0' & I_PIXEL_COL + SIZE) and ('0' & I_PIXEL_COL <= '0' & L_X_POS + SIZE) -- x_pos - size <= pixel_column <= x_pos + size
		and ('0' & L_Y_POS <= I_PIXEL_ROW + SIZE) and ('0' & I_PIXEL_ROW <= L_Y_POS + SIZE)) else -- y_pos - size <= pixel_row <= y_pos + size
		'0';
	-- Colours for pixel data on video signal
	-- Changing the background and ball colour by pushbuttons
	O_RED <= L_ON;
	O_GREEN <= L_ON;
	O_BLUE <= not L_ON;

end behavior;