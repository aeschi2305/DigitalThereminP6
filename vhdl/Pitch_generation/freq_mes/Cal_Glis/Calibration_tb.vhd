-----------------------------------------------------
-- Project : Digital Calibration
-----------------------------------------------------
-- File    : Calibration_tb.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Testbench for complete setup to test calibration
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Calibration_tb is
end entity Calibration_tb;

architecture struct of Calibration_tb is
  
  constant N       : natural := 16; 
  constant dat_len_avl : natural := 32;
  -- Internal signal declarations:
  signal clk                : std_ulogic;
  signal square_freq        : std_ulogic;
  signal reset_n            : std_ulogic;
  signal DACLRCK            : std_logic;

  signal avs_address   :  std_logic_vector(1 downto 0);
  signal avs_write     :  std_logic;
  signal avs_writedata :  std_logic_vector(dat_len_avl-1 downto 0);
  signal avs_readdata  :  std_logic_vector(dat_len_avl-1 downto 0);
  


  
  -- Component Declarations
  component Calibration_verify is
    generic (
      N : natural := 16;  --Number of Bits of the sine wave (precision)
      dat_len_avl : natural := 32
      );
      port (
        reset_n        : out  std_ulogic; -- asynchronous reset
        clk            : out  std_ulogic; -- clock
        square_freq    : out  std_ulogic; -- asynchronous reset, active low

        avs_address   : out  std_logic_vector(1 downto 0);
        avs_write     : out std_logic;
        avs_writedata : out std_logic_vector(dat_len_avl-1 downto 0);
        avs_read      : out  std_logic;
        avs_readdata  : in std_logic_vector(dat_len_avl-1 downto 0)
      );
  end component Calibration_verify;

  component pitch_generation_top is
  generic (
    dat_len_avl : natural := 24;   --Number of Bits of Avalon data w/r
    cic1Bits : natural := 23;
    cic2Bits : natural := 26;
    cic3Bits : natural := 29
  );
  port( 
    -- Avalon Clock Reset Interfaces
    csi_clk           : in std_logic;
    rsi_reset_n       : in std_logic;
    -- Avalon Slave Port
    avs_sTG_write     : in std_logic;
    avs_sTG_address   : in std_logic_vector(1 downto 0);
    avs_sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
    avs_sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);
    -- Avalon Streaming Source Interface (for output data)
    aso_se_ready      : in std_logic;
    aso_se_valid     : out std_logic;
    aso_se_data       : out std_logic_vector(23 downto 0);

    -- Avalon conduit Interfaces
    coe_square_freq   : in std_logic;
    coe_freq_up_down  : in std_logic_vector(1 downto 0);
    coe_Cal_Glis      : in std_logic_vector(1 downto 0)
  );
end component pitch_generation_top;

  
begin
  
  -- Instance port mappings.
  verify_pm : entity work.Calibration_verify
    generic map (
      N => N,
      dat_len_avl => dat_len_avl
    )
    port map (
      reset_n => reset_n,   
      clk     => clk,   
      square_freq => square_freq,

      avs_address   => avs_address,
      avs_write     => avs_write,
      avs_writedata => avs_writedata,
      avs_readdata  => avs_readdata

    ); 

  pitch_generation_pm : entity work.pitch_generation_top
    generic map(
      dat_len_avl => dat_len_avl,   --Number of Bits of Avalon data w/r
      cic1Bits    => 23,
      cic2Bits    => 26,
      cic3Bits    => 29
    )
    port map (
    -- Avalon Clock Reset Interfaces
    csi_clk           => clk,
    rsi_reset_n       => reset_n,
    -- Avalon Slave Port
    avs_sTG_write     => avs_write,
    avs_sTG_address   => avs_address,
    avs_sTG_writedata => avs_writedata,
    avs_sTG_readdata  => avs_readdata,
    -- Avalon Streaming Source Interface (for output data)
    aso_se_ready      => '1',
    aso_se_valid      => open,
    aso_se_data       => open,

    -- Avalon conduit Interfaces
    coe_square_freq   => square_freq,
    coe_freq_up_down  => "00",
    coe_Cal_Glis      => "00"
    ); 

  
  
end architecture struct;