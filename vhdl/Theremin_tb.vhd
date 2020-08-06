-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : Theremin_tb.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Testbench for complete setup excluding codec
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Theremin_tb is
end entity Theremin_tb;

architecture struct of Theremin_tb is
  
  constant N       : natural := 16; 
  constant dat_len_avl : natural := 32;
  -- Internal signal declarations:
  signal clk                : std_ulogic;
  signal square_freq_pitch  : std_ulogic;
  signal square_freq_vol  : std_ulogic;
  signal volume             : std_logic_vector(17 downto 0);
  signal vol_enable         : std_logic;
  signal reset_n            : std_ulogic;
  signal avs_write     : std_logic;
  signal avs_writedata : std_logic_vector(dat_len_avl-1 downto 0);
  


  
  -- Component Declarations
  component Theremin_verify is
    generic (
      N : natural := 16  --Number of Bits of the sine wave (precision)
      );
      port (
        reset_n               : out  std_ulogic; -- asynchronous reset
        clk                   : out  std_ulogic; -- clock
        square_freq_pitch     : out  std_ulogic; 
        square_freq_vol       : out  std_ulogic;

        avs_write     : out std_logic;
        avs_writedata : out std_logic_vector(dat_len_avl-1 downto 0)
      );
  end component Theremin_verify;

  component pitch_generation_top is
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
    avs_sTG_write     : in std_logic;
    avs_sTG_address   : in std_logic_vector(1 downto 0);
    avs_sTG_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    avs_sTG_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);
    -- Avalon Streaming Source Interface (for output data)
    aso_se_ready      : in std_logic;
    aso_se_valid     : out std_logic;
    aso_se_data       : out std_logic_vector(23 downto 0);

    -- Avalon conduit Interfaces
    coe_square_freq   : in std_logic;
    coe_freq_up_down  : in std_logic_vector(1 downto 0);
    coe_Cal_Glis      : in std_logic_vector(1 downto 0);
    coe_vol_volume    : in std_logic_vector(17 downto 0);
    coe_vol_enable    : in std_logic
  );
  end component pitch_generation_top;

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
    avs_sVG_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    -- Avalon conduit Interfaces
    coe_square_freq   : in std_logic;
    coe_freq_up_down  : in std_logic_vector(1 downto 0);
    coe_vol_volume    : out std_logic_vector(17 downto 0);
    coe_vol_enable    : out std_logic
  );
end component Volume_generation_top;

  
begin
  
  -- Instance port mappings.
  verify_pm : entity work.Theremin_verify
    generic map (
      N => N
    )
    port map (
      reset_n => reset_n,   
      clk     => clk,   
      avs_write     => avs_write,
      avs_writedata => avs_writedata,
      square_freq_pitch => square_freq_pitch,
      square_freq_vol => square_freq_vol

    ); 

  pitch_generation_pm : entity work.pitch_generation_top
    port map( 
      -- Avalon Clock Reset Interfaces
      csi_clk           => clk,
      rsi_reset_n       => reset_n,
      -- Avalon Slave Port
      avs_sTG_write     => '0',
      avs_sTG_address   => (others => '0'),
      avs_sTG_writedata => (others => '0'),
      avs_sTG_readdata  => open,
      -- Avalon Streaming Source Interface (for output data)
      aso_se_ready      => '1',
      aso_se_valid      => open,
      aso_se_data       => open,
  
      -- Avalon conduit Interfaces
      coe_square_freq   => square_freq_pitch,
      coe_freq_up_down  => "00",
      coe_Cal_Glis      => "00",
      coe_vol_volume    => volume,
      coe_vol_enable    => vol_enable
    ); 

  volume_generation_pm : entity work.volume_generation_top
    port map( 
      -- Avalon Clock Reset Interfaces
      csi_clk           => clk,
      rsi_reset_n       => reset_n,
      -- Avalon Slave Port
      avs_sVG_write     => avs_write,
      avs_sVG_writedata => avs_writedata,
      -- Avalon conduit Interfaces
      coe_square_freq   => square_freq_vol,
      coe_freq_up_down  => "00",
      coe_vol_volume    => volume,
      coe_vol_enable    => vol_enable
    ); 
  
  
end architecture struct;