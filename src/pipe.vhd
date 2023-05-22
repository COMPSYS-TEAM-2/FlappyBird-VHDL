library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;
use work.Constantvalues.all;
use work.RGBValues.all;

entity pipe is
	generic (
		X_START : std_logic_vector(10 downto 0)
	);
	port (
		I_CLK : in std_logic;
		I_V_SYNC : in std_logic;
		I_RST : in std_logic;
		I_ENABLE : in std_logic;
		I_PIXEL : in T_RECT;
		I_PIPE_GAP_POSITION : in std_logic_vector(7 downto 0);
		I_BIRD : in T_RECT;
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic;
		O_COLLISION : out std_logic;
		O_PIPE_PASSED : out std_logic
	);
end pipe;

architecture behavior of pipe is
	constant INITIAL_SPEED : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);
	signal L_TOP : T_RECT := CreateRect(0, 0, PIPE_WIDTH, 0);
	signal L_BOTTOM : T_RECT := CreateRect(0, 0, PIPE_WIDTH, 0);
	signal POWERUP_TYPE : std_logic_vector(5 downto 0);
	signal L_POWERUP : T_RECT := CreateRect(0, 0, PLAYER_SIZE, PLAYER_SIZE);
	signal L_POWERUP_ON : std_logic;
begin
	spritePowerup : entity work.sprite
		port map(
			I_CLK => I_CLK,
			I_X => L_POWERUP.X,
			I_Y => L_POWERUP.Y,
			I_PIXEL_ROW => I_PIXEL.Y,
			I_PIXEL_COL => I_PIXEL.X,
			I_INDEX => POWERUP_TYPE,
			O_ON => L_POWERUP_ON
		);

	Move_Pipes : process (I_V_SYNC)
		variable X_POS : std_logic_vector(10 downto 0) := X_START;
		variable X_VEL : std_logic_vector(9 downto 0) := INITIAL_SPEED;
		variable PIPE_GAP_POSITION : std_logic_vector(9 downto 0);
		variable Y_POS : std_logic_vector(9 downto 0);
	begin
		-- Move pipes once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (I_RST = '1') then
				X_POS := X_START;
				X_VEL := INITIAL_SPEED;
			elsif (I_ENABLE = '1') then
				if (X_POS >= conv_std_logic_vector(640, 11)) then
					PIPE_GAP_POSITION := ("00" & I_PIPE_GAP_POSITION) + CONV_STD_LOGIC_VECTOR((480 - 256)/2, 10);
					L_TOP.HEIGHT <= PIPE_GAP_POSITION - ('0' & PIPE_GAP(9 downto 1));
					Y_POS := PIPE_GAP_POSITION + ('0' & PIPE_GAP(9 downto 1));
					L_BOTTOM.Y <= Y_POS;
					L_BOTTOM.HEIGHT <= conv_std_logic_vector(480, 10) - (Y_POS);
					case (PIPE_GAP_POSITION(1 downto 0)) is
						when "01" => POWERUP_TYPE <= CLOCK_POWERUP; -- Clock 
						when "10" => POWERUP_TYPE <= SHEILD_POWERUP;-- Sheild
						when others => POWERUP_TYPE <= HEART_POWERUP; -- Heart 
					end case;
					-- Powerup should only appear is the random value is within a range
					if (PIPE_GAP_POSITION(3 downto 0) > 4) then
						L_POWERUP.Y <= Y_POS - ('0' & PIPE_GAP(9 downto 1));
					else
						L_POWERUP.Y <= conv_std_logic_vector(500, 10);
					end if;
				end if;
				X_POS := X_POS - X_VEL;
				-- If the pipes overflow, place them back at the start
				if (X_POS <= - CONV_STD_LOGIC_VECTOR(PIPE_WIDTH, 11)) then
					X_POS := CONV_STD_LOGIC_VECTOR(640, 11);
				end if;
			end if;
		end if;
		L_TOP.X <= X_POS;
		L_BOTTOM.X <= X_POS;
		L_POWERUP.X <= X_POS + conv_std_logic_vector(2, 11);
	end process;

	O_PIPE_PASSED <= '1' when ((I_BIRD.X >= L_TOP.X + L_TOP.WIDTH) and (I_BIRD.X <= L_TOP.X + L_TOP.WIDTH + L_TOP.WIDTH)) else
		'0';
	O_ON <= '1' when ((CheckCollision(I_PIXEL, L_TOP) = '1') or (CheckCollision(I_PIXEL, L_BOTTOM) = '1') or (L_POWERUP_ON = '1')) else
		'0';
	O_RGB <= PIPE_RGB when ((CheckCollision(I_PIXEL, L_TOP) or CheckCollision(I_PIXEL, L_BOTTOM)) = '1') else
		HEART_SPRITE_RGB when (L_POWERUP_ON = '1' and POWERUP_TYPE = HEART_POWERUP) else
		CLOCK_SPRITE_RGB when (L_POWERUP_ON = '1' and POWERUP_TYPE = CLOCK_POWERUP) else
		SHEILD_SPRITE_RGB when (L_POWERUP_ON = '1' and POWERUP_TYPE = SHEILD_POWERUP);
	O_COLLISION <= checkCollision(I_BIRD, L_TOP) or checkCollision(I_BIRD, L_BOTTOM);

end behavior;