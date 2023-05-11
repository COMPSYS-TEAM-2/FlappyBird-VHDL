library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.rectangle.all;
use work.constantvalues.all;
use work.RGBValues.BIRD_RGB;

entity bird is
	port (
		I_V_SYNC, I_CLICK : in std_logic;
		I_PIXEL : in T_RECT;
		O_BIRD : out T_RECT;
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic
	);
end bird;

architecture behavior of bird is
	signal L_BIRD : T_RECT := CreateRect(200, 150, PLAYER_SIZE, PLAYER_SIZE);

begin
	move_bird : process (I_V_SYNC)
		variable Y_POS : std_logic_vector(9 downto 0) := L_BIRD.Y;
		variable Y_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);
	begin
		-- Move square once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (I_CLICK = '1' and Y_VEL >= CONV_STD_LOGIC_VECTOR(2, 10)) then
				Y_VEL := - CONV_STD_LOGIC_VECTOR(12, 10);
			else
				Y_VEL := Y_VEL + GRAVITY;
				if (Y_VEL > GRAVITY(5 downto 0) & "0000") then
					Y_VEL := GRAVITY(5 downto 0) & "0000";
				end if;
			end if;

			Y_POS := L_BIRD.Y + Y_VEL;
			if (Y_POS >= CONV_STD_LOGIC_VECTOR(479, 10) - L_BIRD.Height) then
				Y_POS := CONV_STD_LOGIC_VECTOR(479, 10) - L_BIRD.Height;
			elsif (Y_POS <= CONV_STD_LOGIC_VECTOR(0, 10)) then
				Y_POS := CONV_STD_LOGIC_VECTOR(0, 10);
			end if;
			L_BIRD.Y <= Y_POS;
		end if;
	end process move_bird;

	O_BIRD <= L_BIRD;

	O_ON <= CheckCollision(I_PIXEL, L_BIRD);

	-- Colours for pixel data on video signal
	-- Changing the background and ball colour by pushbuttons
	O_RGB <= BIRD_RGB;

end behavior;