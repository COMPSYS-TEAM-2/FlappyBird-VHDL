library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity VGA_SYNC is
	port (
		I_CLK_25Mhz : in std_logic;
		I_RGB : in std_logic_vector(11 downto 0);
		O_RED, O_GREEN, O_BLUE : out std_logic_vector(3 downto 0);
		O_H_SYNC, O_V_SYNC : out std_logic;
		O_PIXEL_ROW, O_PIXEL_COL : out std_logic_vector(9 downto 0));
end VGA_SYNC;

architecture a of VGA_SYNC is
	signal horiz_sync, vert_sync : std_logic;
	signal video_on, video_on_v, video_on_h : std_logic;
	signal h_count, v_count : std_logic_vector(9 downto 0) := (others => '0');

begin

	-- video_on is high only when RGB data is displayed
	video_on <= video_on_H and video_on_V;

	process
	begin
		wait until(I_CLK_25Mhz'EVENT) and (I_CLK_25Mhz = '1');

		--Generate Horizontal and Vertical Timing Signals for Video Signal
		-- H_count counts pixels (640 + extra time for sync signals)
		-- 
		--  Horiz_sync  ------------------------------------__________--------
		--  H_count       0                640             659       755    799
		--
		if (h_count = 799) then
			h_count <= "0000000000";
		else
			h_count <= h_count + 1;
		end if;

		--Generate Horizontal Sync Signal using H_count
		if (h_count <= 755) and (h_count >= 659) then
			horiz_sync <= '0';
		else
			horiz_sync <= '1';
		end if;

		--V_count counts rows of pixels (480 + extra time for sync signals)
		--  
		--  Vert_sync      -----------------------------------------------_______------------
		--  V_count         0                                      480    493-494          524
		--
		if (v_count >= 524) and (h_count >= 699) then
			v_count <= "0000000000";
		elsif (h_count = 699) then
			v_count <= v_count + 1;
		end if;

		-- Generate Vertical Sync Signal using V_count
		if (v_count <= 494) and (v_count >= 493) then
			vert_sync <= '0';
		else
			vert_sync <= '1';
		end if;

		-- Generate Video on Screen Signals for Pixel Data
		if (h_count <= 639) then
			video_on_h <= '1';
			O_PIXEL_COL <= h_count;
		else
			video_on_h <= '0';
		end if;

		if (v_count <= 479) then
			video_on_v <= '1';
			O_PIXEL_ROW <= v_count;
		else
			video_on_v <= '0';
		end if;

		-- Put all video signals through DFFs to elminate any delays that cause a blurry image
		if (video_on = '1') then
			O_RED <= I_RGB(11 downto 8);
			O_GREEN <= I_RGB(7 downto 4);
			O_BLUE <= I_RGB(3 downto 0);
		else
			O_RED <= (others => '0');
			O_GREEN <= (others => '0');
			O_BLUE <= (others => '0');
		end if;

		O_H_SYNC <= horiz_sync;
		O_V_SYNC <= vert_sync;

	end process;
end a;