----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- Description: Generates a test 1920x1200@60 signal 
-- http://martin.hinner.info/vga/timing.html
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_gen is
    Port ( clk193 : in  STD_LOGIC;
           pclk  : out STD_LOGIC;
           red   : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           green : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           blue  : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           blank : out STD_LOGIC := '0';
           hsync : out STD_LOGIC := '0';
           vsync : out STD_LOGIC := '0');
end vga_gen;

architecture Behavioral of vga_gen is
   constant h_rez        : natural := 1920;
   constant h_sync_start : natural := 2048;
   constant h_sync_end   : natural := 2256;
   constant h_max        : natural := 2592-1;
   constant h_polarity   : std_logic := '0';--'-'
   signal   h_count      : unsigned(11 downto 0) := (others => '0');

   constant v_rez        : natural := 1200;
   constant v_sync_start : natural := 1201;
   constant v_sync_end   : natural := 1204;
   constant v_max        : natural := 1242-1;
   constant v_polarity   : std_logic := '1';--'+'
   signal   v_count      : unsigned(11 downto 0) := (others => '0');
   
begin
   pclk <= clk193;
   
process(clk193)
   begin
      if rising_edge(clk193) then
         if h_count < h_rez and v_count < v_rez then
				red   <= std_logic_vector(h_count(7 downto 0));
            green <= std_logic_vector(v_count(7 downto 0));
            blue  <= std_logic_vector(h_count(7 downto 0)+v_count(7 downto 0));
				blank <= '0';
         else
            red   <= (others => '0');
            green <= (others => '0');
            blue  <= (others => '0');
            blank <= '1';
         end if;

         if h_count >= h_sync_start and h_count < h_sync_end then
            hsync <= h_polarity;
         else
            hsync <= not h_polarity;
         end if;
         
         if v_count >= v_sync_start and v_count < v_sync_end then
            vsync <= v_polarity;
         else
            vsync <= not v_polarity;
         end if;
         
         if h_count = h_max then
            h_count <= (others => '0');
            if v_count = v_max then
               v_count <= (others => '0');
            else
               v_count <= v_count+1;
            end if;
         else
            h_count <= h_count+1;
         end if;

      end if;
   end process;

end Behavioral;
