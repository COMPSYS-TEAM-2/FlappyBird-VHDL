library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity pipes is
	port (
		I_V_SYNC : in std_logic;
		I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
		I_PIPE_GAP_POSITION : in std_logic_vector(7 downto 0);
		O_X_A_POS, O_X_B_POS : out std_logic_vector(10 downto 0);
		O_A_PIPE_GAP_POS, O_B_PIPE_GAP_POS : out std_logic_vector(9 downto 0);
		O_PIPE_GAP, O_PIPE_WIDTH : out std_logic_vector(9 downto 0);
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic
	);
end pipes;

architecture behavior of pipes is
	constant PIPE_GAP : std_logic_vector(9 downto 0) := conv_std_logic_vector(195, 10); -- Define the size of the gap between the pipes
	constant PIPE_WIDTH : std_logic_vector(9 downto 0) := conv_std_logic_vector(40, 10);
	-- constant ACCELLERATION : std_logic_vector(9 downto 0) := conv_std_logic_vector(0, 0);

	signal PIPE_GAP_POSITION_A : std_logic_vector(9 downto 0);
	signal PIPE_GAP_POSITION_B : std_logic_vector(9 downto 0);

	signal L_X_POS_A : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(680, 11);
	signal L_X_POS_B : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(1000, 11);

begin
	Move_pipes : process (I_V_SYNC)
		variable X_POS_A : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(680, 11);
		variable X_POS_B : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(1000, 11);
		variable X_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);
	begin
		-- Move pipes once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			if (X_POS_A >= conv_std_logic_vector(640, 11)) then
				PIPE_GAP_POSITION_A <= (I_PIPE_GAP_POSITION) + conv_std_logic_vector(164, 10);
			elsif (X_POS_B >= conv_std_logic_vector(640, 11)) then
				PIPE_GAP_POSITION_B <= (I_PIPE_GAP_POSITION) + conv_std_logic_vector(164, 10);
			end if;
			X_POS_A := L_X_POS_A - X_VEL;
			X_POS_B := L_X_POS_B - X_VEL;
			-- If the pipes overflow, place them back at the start
			if (X_POS_A <= 0) then
				X_POS_A := CONV_STD_LOGIC_VECTOR(640, 11);
				PIPE_GAP_POSITION_A <= ((I_PIPE_GAP_POSITION & '0') + conv_std_logic_vector(164, 10));
			elsif (X_POS_B <= 0) then
				X_POS_B := CONV_STD_LOGIC_VECTOR(640, 11);
				PIPE_GAP_POSITION_B <= ((I_PIPE_GAP_POSITION & '0') + conv_std_logic_vector(164, 10));
			end if;
			L_X_POS_A <= X_POS_A;
			L_X_POS_B <= X_POS_B;
		end if;
	end process Move_pipes;

	O_X_A_POS <= L_X_POS_A;
	O_X_B_POS <= L_X_POS_B;
	O_A_PIPE_GAP_POS <= PIPE_GAP_POSITION_A;
	O_B_PIPE_GAP_POS <= PIPE_GAP_POSITION_B;
	O_PIPE_GAP <= PIPE_GAP;
	O_PIPE_WIDTH <= PIPE_WIDTH;

	O_ON <= '1' when (((('0' & I_PIXEL_COL >= '0' & L_X_POS_A) and ('0' & I_PIXEL_COL <= '0' & L_X_POS_A + PIPE_WIDTH))-- L_X_POS_A - PIPE_WIDTH <= I_PIXEL_COL <= L_X_POS_A + PIPE_WIDTH
		and (('0' & I_PIXEL_ROW <= PIPE_GAP_POSITION_A) or ('0' & I_PIXEL_ROW >= PIPE_GAP_POSITION_A + PIPE_GAP))) -- PIPE_GAP_POSITION_A - PIPE_GAP >= I_PIXEL_ROW >= PIPE_GAP_POSITION_A + PIPE_GAP
		or ((('0' & I_PIXEL_COL >= '0' & L_X_POS_B) and ('0' & I_PIXEL_COL <= '0' & L_X_POS_B + PIPE_WIDTH)) -- L_X_POS_B - PIPE_WIDTH <= I_PIXEL_COL <= L_X_POS_B + PIPE_WIDTH)			
		and (('0' & I_PIXEL_ROW <= PIPE_GAP_POSITION_B) or ('0' & I_PIXEL_ROW >= PIPE_GAP_POSITION_B + PIPE_GAP)))) else -- PIPE_GAP_POSITION_B - PIPE_GAP >= I_PIXEL_ROW >= PIPE_GAP_POSITION_B + PIPE_GAP 
		'0';

	O_RGB <= x"5E2";

end behavior;