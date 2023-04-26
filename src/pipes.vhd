library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity pipes is
	port (
		I_CLK, I_V_SYNC : in std_logic;
		I_PIXEL_ROW, I_PIXEL_COL : in std_logic_vector(9 downto 0);
		O_RGB : out std_logic_vector(11 downto 0);
		O_ON : out std_logic
	);
end pipes;

architecture behavior of pipes is
    constant PIPE_GAP : std_logic_vector(9 downto 0) := conv_std_logic_vector(100, 10); -- Define the size of the gap between the pipes
    constant PIPE_GAP_POSITION_A : std_logic_vector(9 downto 0) := conv_std_logic_vector(220, 10); -- Position of the gap between the pipes
    constant PIPE_GAP_POSITION_B : std_logic_vector(9 downto 0) := conv_std_logic_vector(220, 10); -- Position of the gap between the pipes
    constant PIPE_WIDTH : std_logic_vector(9 downto 0) := conv_std_logic_vector(20, 10);
    -- constant ACCELLERATION : std_logic_vector(9 downto 0) := conv_std_logic_vector(0, 0);

	signal L_X_POS_A : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(640, 11);
	signal L_X_POS_B : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(960, 11);

begin
	-- Define the Linear Feeback Shift Register
	lfsr : entity lfsr
	port map(
		I_CLK => I_CLK,
		O_VAL => PIPE_GAP 
	);
	Move_pipes : process (I_V_SYNC)
		variable X_POS_A : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(640, 11);
		variable X_POS_B : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(960, 11);
		variable X_VEL : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);
	begin
		-- Move pipes once every vertical sync
		if (rising_edge(I_V_SYNC)) then
			X_POS_A := L_X_POS_A - X_VEL;
			X_POS_B := L_X_POS_B - X_VEL;
			-- If the pipes overflow, place them back at the start
            if (X_POS_A <= 0) then
                X_POS_A := CONV_STD_LOGIC_VECTOR(640, 11);
            elsif (X_POS_B <= 0) then
                X_POS_B := CONV_STD_LOGIC_VECTOR(640, 11);
            end if;
			L_X_POS_A <= X_POS_A;
			L_X_POS_B <= X_POS_B;
		end if;
	end process Move_pipes;

	O_ON <= '1' when (((('0' & I_PIXEL_COL >= '0' & L_X_POS_A - PIPE_WIDTH) and ('0' & I_PIXEL_COL <= '0' & L_X_POS_A + PIPE_WIDTH))-- L_X_POS_A - PIPE_WIDTH <= I_PIXEL_COL <= L_X_POS_A + PIPE_WIDTH
			and (('0' & I_PIXEL_ROW <= PIPE_GAP_POSITION_A - PIPE_GAP) or ('0' & I_PIXEL_ROW >= PIPE_GAP_POSITION_A + PIPE_GAP)))  -- PIPE_GAP_POSITION_A - PIPE_GAP >= I_PIXEL_ROW >= PIPE_GAP_POSITION_A + PIPE_GAP
		or ((('0' & I_PIXEL_COL >= '0' & L_X_POS_B - PIPE_WIDTH) and ('0' & I_PIXEL_COL <= '0' & L_X_POS_B + PIPE_WIDTH)) -- L_X_POS_B - PIPE_WIDTH <= I_PIXEL_COL <= L_X_POS_B + PIPE_WIDTH)			
			and (('0' & I_PIXEL_ROW <= PIPE_GAP_POSITION_B - PIPE_GAP) or ('0' & I_PIXEL_ROW >= PIPE_GAP_POSITION_B + PIPE_GAP)))) else  -- PIPE_GAP_POSITION_B - PIPE_GAP >= I_PIXEL_ROW >= PIPE_GAP_POSITION_B + PIPE_GAP 
		'0';

	O_RGB <= x"5E2";

end behavior;