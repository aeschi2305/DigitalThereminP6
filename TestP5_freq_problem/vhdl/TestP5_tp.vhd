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
  -- Internal signal declarations:
  signal clk                : std_ulogic;
  signal clk_a              : std_ulogic;
  signal square_freq        : std_ulogic;
  signal reset_n            : std_ulogic;
  signal reset_a            : std_ulogic;


  
  -- Component Declarations
  component Theremin_verify is
    generic (
      N : natural := 16  --Number of Bits of the sine wave (precision)
      );
      port (
        reset_n        : out  std_ulogic; -- asynchronous reset
        reset_a        : out  std_ulogic;
        clk            : out  std_ulogic; -- clock
        clk_a          : out  std_ulogic; -- clock
        square_freq    : out  std_ulogic -- asynchronous reset, active low
      );
  end component Theremin_verify;

  component TestP5 is
      port (
          audio_0_external_interface_BCLK                  : in    std_logic := '0'; --                  audio_0_external_interface.BCLK
          audio_0_external_interface_DACDAT                : out   std_logic;        --                                            .DACDAT
          audio_0_external_interface_DACLRCK               : in    std_logic := '0'; --                                            .DACLRCK
          audio_and_video_config_0_external_interface_SDAT : inout std_logic := '0'; -- audio_and_video_config_0_external_interface.SDAT
          audio_and_video_config_0_external_interface_SCLK : out   std_logic;        --                                            .SCLK
          clk_clk                                          : in    std_logic := '0'; --                                         clk.clk
          clk_clk_a                                        : in    std_logic := '0'; --   
          reset_reset_n                                    : in    std_logic := '0'; --                                       reset.reset_n
          reset_reset_a                                    : in    std_logic := '0'; --  
          tone_generation_0_conduit_end_0_export           : in    std_logic := '0';  --             tone_generation_0_conduit_end_0.export
          AUD_XCK                                          : out std_logic
      );
  end component TestP5; 

  
begin
  
  -- Instance port mappings.
  verify_pm : entity work.Theremin_verify
    generic map (
      N => N
    )
    port map (
      reset_n => reset_n,   
      reset_a => reset_a,   
      clk     => clk,   
      clk_a   => clk_a,   
      square_freq => square_freq
    ); 

  TestP5_pm : entity work.TestP5
    port map (
      audio_0_external_interface_BCLK => open,                 
      audio_0_external_interface_DACDAT => open,                
      audio_0_external_interface_DACLRCK => open,              
      audio_and_video_config_0_external_interface_SDAT => open,
      audio_and_video_config_0_external_interface_SCLK => open,
      clk_clk       => clk, 
      clk_clk_a     => clk_a,                                  
      reset_reset_n  => reset_n, 
      reset_reset_a => reset_a,                                 
      tone_generation_0_conduit_end_0_export => square_freq,          
      AUD_XCK                            => open
    ); 

  
  
end architecture struct;