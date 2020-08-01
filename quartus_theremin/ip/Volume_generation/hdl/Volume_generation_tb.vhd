-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : volume_tb.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Testbench for complete setup excluding codec
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity volume_tb is
end entity volume_tb;

architecture struct of volume_tb is
  
  constant N       : natural := 16; 
  constant dat_len_avl : natural := 32;
  -- Internal signal declarations:
  signal clk                : std_ulogic;
  signal square_freq        : std_logic;
  signal reset_n            : std_ulogic;
  signal avs_sTG_write      : std_logic;
  signal avs_sTG_address    : std_logic_vector(1 downto 0);
  signal avs_sTG_writedata  : std_logic_vector(dat_len_avl-1 downto 0);
  signal avs_sTG_readdata   : std_logic_vector(dat_len_avl-1 downto 0);
  


  
  -- Component Declarations
  component Theremin_verify is
    generic (
      N : natural := 16  --Number of Bits of the sine wave (precision)
      );
      port (
          clk           : in std_logic;
          reset_n       : in std_logic;
              -- Avalon Slave Port
          avs_sTG_write     : out std_logic;
          avs_sTG_address   : out std_logic_vector(1 downto 0);
          avs_sTG_writedata : out std_logic_vector(dat_len_avl-1 downto 0);
          avs_sTG_readdata  : in std_logic_vector(dat_len_avl-1 downto 0);
    
              -- Avalon conduit Interfaces
          coe_square_freq   : out std_logic;
          coe_freq_up_down  : out std_logic_vector(1 downto 0)
      );
  end component Theremin_verify;

  component Volume_generation_top is
    generic (
      dat_len_avl : natural := 32;   --Number of Bits of Avalon data w/r
      cic1Bits : natural := 21;
      cic2Bits : natural := 25;
      cic3Bits : natural := 28
    );
    port( 
      -- Avalon Clock Reset Interfaces
      csi_clk           : in std_logic;
      rsi_reset_n       : in std_logic;
      -- Avalon Slave Port
      avs_sVG_write     : in std_logic;
      avs_sVG_address   : in std_logic_vector(1 downto 0);
      avs_sVG_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
      avs_sVG_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);
      -- Avalon conduit Interfaces
      coe_square_freq   : in std_logic;
      coe_freq_up_down  : in std_logic_vector(1 downto 0)
    );
end component Volume_generation_top;

  
begin
  
  -- Instance port mappings.
  verify_pm : entity work.Theremin_verify
    generic map (
      N => N
    )
    port map (
       reset_n   => reset_n,       
       clk       => clk,      
       avs_sTG_write  => avs_sTG_write, 
       avs_sTG_address => avs_sTG_address, 
       avs_sTG_writedata => avs_sTG_writedata,
       avs_sTG_readdata => avs_sTG_readdata,
           -- Avalon con
       coe_square_freq => square_freq, 
       coe_freq_up_down => open

    ); 

  Volume_generation_pm : entity work.Volume_generation_top
    generic map(
      dat_len_avl => 32,   --Number of Bits of Avalon data w       dat_len_avl : natural := 32;   --Number of Bits of Avalon data w/r
      cic1Bits    => 21,
      cic2Bits    => 25,
      cic3Bits    => 28
    )
    port map (
    -- Avalon Clock Reset Interfaces
       rsi_reset_n   => reset_n,       
       csi_clk       => clk,      
       avs_sVG_write  => avs_sTG_write, 
       avs_sVG_address => avs_sTG_address, 
       avs_sVG_writedata => avs_sTG_writedata,
       avs_sVG_readdata => avs_sTG_readdata,
           -- Avalon con
       coe_square_freq => square_freq, 
       coe_freq_up_down => "00"
    ); 

  
  
end architecture struct;