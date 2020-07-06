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
  signal square_freq        : std_ulogic;
  signal reset_n            : std_ulogic;
  signal DACLRCK            : std_logic;
  


  
  -- Component Declarations
  component Theremin_verify is
    generic (
      N : natural := 16  --Number of Bits of the sine wave (precision)
      );
      port (
        reset_n        : out  std_ulogic; -- asynchronous reset
        clk            : out  std_ulogic; -- clock
        square_freq    : out  std_ulogic; -- asynchronous reset, active low
        DACLRCK        : out std_ulogic
      );
  end component Theremin_verify;

  component Tone_generation_top is
  generic (
    dat_len_avl : natural := 31   --Number of Bits of Avalon data w/r
  );
  port( 
    -- Avalon Clock Reset Interfaces
    csi_clk           : in std_logic;
    rsi_reset_n       : in std_logic;
    -- Avalon Streaming Source Interface (for output data)
    aso_seR_ready      : in std_logic;
    aso_seR_valid     : out std_logic;
    aso_seR_data       : out std_logic_vector(23 downto 0);
    aso_seL_ready      : in std_logic;
    aso_seL_valid      : out std_logic;
    aso_seL_data       : out std_logic_vector(23 downto 0);
    -- Avalon conduit Interfaces
    coe_square_freq   : in std_logic;
    coe_freq_up_down  : in std_logic_vector(1 downto 0)
  );
end component Tone_generation_top;

  
begin
  
  -- Instance port mappings.
  verify_pm : entity work.Theremin_verify
    generic map (
      N => N
    )
    port map (
      reset_n => reset_n,   
      clk     => clk,   
      square_freq => square_freq

    ); 

  Tone_generation_pm : entity work.Tone_generation_top
    port map (
      csi_clk           => clk,
      rsi_reset_n       => reset_n,
     
      aso_seR_ready     => '1',
      aso_seR_valid     => open,
      aso_seR_data      => open,
      aso_seL_ready     => '1',
      aso_seL_valid     => open,
      aso_seL_data      => open,
    
      coe_square_freq   => square_freq,
      coe_freq_up_down  => "00"
    ); 

  
  
end architecture struct;