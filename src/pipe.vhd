library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;

entity pipe is
	generic (
		X_START : std_logic_vector(10 downto 0)
	);
	port (
		I_V_SYNC : in std_logic;
		I_PIXEL : in T_RECT;
		I_PIPE_GAP_POSITION : in std_logic_vector(7 downto 0);
		I_BIRD : in T_RECT;
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic;
		O_COLLISION : out std_logic ;
		O_PIPE_X : out STD_LOGIC_VECTOR(10 downto 0) ;
		
		
	
	);
end pipe;

architecture behavior of pipe is
	constant PIPE_GAP : std_logic_vector(9 downto 0) := conv_std_logic_vector(195, 10); -- Define the size of the gap between the pipes
	constant PIPE_WIDTH : integer := 40;
	-- constant ACCELLERATION : std_logic_vector(9 downto 0) := conv_std_logic_vector(0, 0);

	signal L_TOP : T_RECT := CreateRect(0, 0, PIPE_WIDTH, 0);
	signal L_BOTTOM : T_RECT := CreateRect(0, 0, PIPE_WIDTH, 0);
begin
	Move_pipes : process (I_V_SYNC)
		variable X_POS : std_logic_vector(10 downto 0) := X_START;
		variable X_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);
		variable PIPE_GAP_POSITION : std_logic_vector(9 downto 0);
		variable Y_POS : std_logic_vector(9 downto 0);
	begin
		-- Move pipes once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (X_POS >= conv_std_logic_vector(640, 11)) then
				PIPE_GAP_POSITION := ("00" & I_PIPE_GAP_POSITION) + CONV_STD_LOGIC_VECTOR((480 - 256)/2, 10);
				L_TOP.HEIGHT <= PIPE_GAP_POSITION - ('0' & PIPE_GAP(9 downto 1));
				Y_POS := PIPE_GAP_POSITION + ('0' & PIPE_GAP(9 downto 1));
				L_BOTTOM.Y <= Y_POS;
				L_BOTTOM.HEIGHT <= conv_std_logic_vector(480, 10) - (Y_POS);
			end if;
			X_POS := X_POS - X_VEL;
			-- If the pipes overflow, place them back at the start
			if (X_POS <= - CONV_STD_LOGIC_VECTOR(PIPE_WIDTH, 11)) then
				X_POS := CONV_STD_LOGIC_VECTOR(640, 11);
			end if;
		end if;
		L_TOP.X <= X_POS;
		L_BOTTOM.X <= X_POS;
	end process Move_pipes;

	O_ON <= CheckCollision(I_PIXEL, L_TOP) or CheckCollision(I_PIXEL, L_BOTTOM);
	O_RGB <= x"5E2";
	O_COLLISION <= checkCollision(I_BIRD, L_TOP) or checkCollision(I_BIRD, L_BOTTOM);
	O_PIPE_X <= L_TOP.X;
	

end behavior;