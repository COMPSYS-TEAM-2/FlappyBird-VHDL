library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.rectangle.all;
use work.constantvalues.all;
use work.RGBValues.all;

entity bird is
	port (
		I_CLK : in STD_LOGIC;
		I_V_SYNC, I_CLICK : in STD_LOGIC;
		I_RST, I_ENABLE : in STD_LOGIC;
		I_PIXEL : in T_RECT;
		I_GRAVITY : in STD_LOGIC;
		O_BIRD : out T_RECT;
		O_RGB : out STD_LOGIC_VECTOR(11 downto 0);
		O_ON : out STD_LOGIC
	);
end bird;

architecture behavior of bird is
	signal L_BIRD : T_RECT := CreateRect(200, 150, PLAYER_SIZE, PLAYER_SIZE - 4);
	signal L_BIRD_ON : STD_LOGIC;
	signal L_BIRD_EYE_ON : STD_LOGIC;
	signal L_BIRD_BEAK_ON : STD_LOGIC;

begin
	spriteBird : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_BIRD.X,
			I_Y => L_BIRD.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => o"50",
			O_ON => L_BIRD_ON
		);

	spriteEye : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_BIRD.X,
			I_Y => L_BIRD.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => o"51",
			O_ON => L_BIRD_EYE_ON
		);

	spriteBeak : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_BIRD.X,
			I_Y => L_BIRD.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => o"52",
			O_ON => L_BIRD_BEAK_ON
		);
	move_bird : process (I_V_SYNC)
		variable Y_POS : STD_LOGIC_VECTOR(9 downto 0) := L_BIRD.Y;
		variable Y_VEL : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);
	begin
		-- Move square once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (I_RST = '1') then
				Y_POS := CONV_STD_LOGIC_VECTOR(150, 10);
			elsif (I_ENABLE = '1') then
				if (I_CLICK = '1' and Y_VEL >= CONV_STD_LOGIC_VECTOR(2, 10)and I_GRAVITY = '0') then
					Y_VEL := - CONV_STD_LOGIC_VECTOR(12, 10);
				else
					if (I_CLICK = '1' and Y_VEL >= CONV_STD_LOGIC_VECTOR(2, 10) and I_GRAVITY = '1') then
						Y_VEL := - CONV_STD_LOGIC_VECTOR(12, 10);
					else
						if (I_GRAVITY = '0') then
							Y_VEL := Y_VEL + GRAVITY;
							if (Y_VEL > GRAVITY(5 downto 0) & "0000") then
								Y_VEL := GRAVITY(5 downto 0) & "0000";
							end if;

						else
							if (I_GRAVITY = '1') then
								Y_VEL := Y_VEL - GRAVITY;
								if (Y_VEL <- (GRAVITY(5 downto 0) & "0000")) then
									Y_VEL := GRAVITY(5 downto 0) & "0000";
								end if;

							end if;
						end if;
						Y_POS := L_BIRD.Y + Y_VEL;
						if (Y_POS >= CONV_STD_LOGIC_VECTOR(479, 10) - L_BIRD.Height) then
							Y_POS := CONV_STD_LOGIC_VECTOR(479, 10) - L_BIRD.Height;
						elsif (Y_POS <= CONV_STD_LOGIC_VECTOR(0, 10)) then
							Y_POS := CONV_STD_LOGIC_VECTOR(0, 10);
						end if;
					end if;
				end if;
			end if;
			L_BIRD.Y <= Y_POS;
		end if;
	end process move_bird;
	O_BIRD <= L_BIRD;

	O_ON <= L_BIRD_ON or L_BIRD_EYE_ON or L_BIRD_BEAK_ON;

	-- Colours for pixel data on video signal
	-- Changing the background and ball colour by pushbuttons
	O_RGB <= BIRD_RGB when (L_BIRD_ON = '1') else
		BIRD_EYE_RGB when (L_BIRD_EYE_ON = '1') else
		BIRD_BEAK_RGB when (L_BIRD_BEAK_ON = '1') else
		(others => '0');

end behavior;