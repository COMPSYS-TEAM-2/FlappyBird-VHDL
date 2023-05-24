library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.rectangle.all;
use work.constantvalues.all;
use work.RGBValues.all;

entity bird is
	port (
		I_CLK : in std_logic;
		I_V_SYNC, I_CLICK : in std_logic;
		I_RST, I_ENABLE, I_DEAD : in std_logic;
		I_PIXEL : in T_RECT;
		I_GRAVITY : in std_logic;
		I_SHEILD : in std_logic;
		O_BIRD : out T_RECT;
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic
	);
end bird;

architecture behavior of bird is
	signal L_BIRD : T_RECT := CreateRect(200, 150, PLAYER_SIZE, PLAYER_SIZE - 4);
	signal L_BIRD_ON : std_logic;
	signal L_BIRD_EYE_ON : std_logic;
	signal L_BIRD_BEAK_ON : std_logic;
	signal L_BIRD_SPRITE : std_logic_vector(5 downto 0);
	signal L_EYE_SPRITE : std_logic_vector(5 downto 0);
	signal L_BEAK_SPRITE : std_logic_vector(5 downto 0);
	signal L_GRAVITY : std_logic;

begin
	spriteBird : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_BIRD.X,
			I_Y => L_BIRD.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => L_BIRD_SPRITE,
			O_ON => L_BIRD_ON
		);

	spriteEye : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_BIRD.X,
			I_Y => L_BIRD.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => L_EYE_SPRITE,
			O_ON => L_BIRD_EYE_ON
		);

	spriteBeak : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_BIRD.X,
			I_Y => L_BIRD.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => L_BEAK_SPRITE,
			O_ON => L_BIRD_BEAK_ON
		);
	move_bird : process (I_V_SYNC)
		variable Y_POS : std_logic_vector(9 downto 0) := L_BIRD.Y;
		variable Y_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);
	begin
		-- Move square once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (I_RST = '1') then
				Y_POS := CONV_STD_LOGIC_VECTOR(150, 10);
			elsif (I_ENABLE = '1') then
				if (I_CLICK = '1' and Y_VEL >= CONV_STD_LOGIC_VECTOR(2, 10) and L_GRAVITY = '0') then
					Y_VEL := - CONV_STD_LOGIC_VECTOR(12, 10);
				elsif (I_CLICK = '1' and Y_VEL <= CONV_STD_LOGIC_VECTOR(-2, 10) and L_GRAVITY = '1') then
					Y_VEL := CONV_STD_LOGIC_VECTOR(12, 10);
				else
					if (L_GRAVITY = '0') then
						Y_VEL := Y_VEL + GRAVITY;
						if (Y_VEL > GRAVITY(5 downto 0) & "0000") then
							Y_VEL := GRAVITY(5 downto 0) & "0000";
						end if;

					else
						if (L_GRAVITY = '1') then
							Y_VEL := Y_VEL - GRAVITY;
							if (Y_VEL <- (GRAVITY(5 downto 0) & "0000")) then
								Y_VEL := - GRAVITY(5 downto 0) & "0000";
							end if;

						end if;
					end if;
					if L_GRAVITY = '0' then
						Y_POS := L_BIRD.Y + Y_VEL;
						if (Y_POS >= CONV_STD_LOGIC_VECTOR(479 - GROUND_HEIGHT, 10) - L_BIRD.Height) then
							Y_POS := CONV_STD_LOGIC_VECTOR(479 - GROUND_HEIGHT, 10) - L_BIRD.Height;
						elsif (Y_POS <= CONV_STD_LOGIC_VECTOR(0, 10)) then
							Y_POS := CONV_STD_LOGIC_VECTOR(0, 10);
						end if;
					else
						if L_GRAVITY = '1' then
							Y_POS := L_BIRD.Y + Y_VEL;
							if (Y_POS >= CONV_STD_LOGIC_VECTOR(479, 10) - L_BIRD.Height) then
								Y_POS := CONV_STD_LOGIC_VECTOR(479, 10) - L_BIRD.Height;
							elsif (Y_POS <= CONV_STD_LOGIC_VECTOR(0, 10)) then
								Y_POS := CONV_STD_LOGIC_VECTOR(0, 10);
							end if;
						end if;
					end if;
				end if;
			end if;
			L_BIRD.Y <= Y_POS;
		end if;
	end process move_bird;

	L_BIRD_SPRITE <= o"50" when I_DEAD /= '1' else
		o"53";
	L_EYE_SPRITE <= o"51" when I_DEAD /= '1' else
		o"54";
	L_BEAK_SPRITE <= o"52" when I_DEAD /= '1' else
		o"55";

	O_BIRD <= L_BIRD;

	L_GRAVITY <= I_GRAVITY and not I_DEAD;

	O_ON <= L_BIRD_ON or L_BIRD_EYE_ON or L_BIRD_BEAK_ON;

	-- Colours for pixel data on video signal
	-- Changing the background and ball colour by pushbuttons
	O_RGB <= SHEILD_SPRITE_RGB when (L_BIRD_ON = '1' and I_SHEILD = '1') else
		BIRD_RGB when (L_BIRD_ON = '1') else
		BIRD_EYE_RGB when (L_BIRD_EYE_ON = '1') else
		BIRD_BEAK_RGB when (L_BIRD_BEAK_ON = '1') else
		(others => '0');

end behavior;