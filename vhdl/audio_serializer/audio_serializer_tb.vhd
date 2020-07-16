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
  signal reset                : std_ulogic;
  signal square_freq        : std_ulogic;
  signal reset_n            : std_ulogic;
  signal DACLRCK            : std_logic;
  signal Bclk                : std_ulogic;
  signal ready                : std_ulogic;
  signal valid                : std_ulogic;
  signal data                : std_logic_vector(23 downto 0);
  


  
  -- Component Declarations
  component audio_serializer is
    
      port (
       reset        : in  std_logic; -- asynchronous reset
       clk            : in  std_logic; -- clock
     
       -- Streaming Source
      coe_AUD1_BCLK                     : in  std_logic;             -- export
      coe_AUD2_DACDAT                   : out std_logic;                                        -- export
      coe_AUD3_DACLRCK                  : in  std_logic; 
      aso_se_ready                      : out std_logic;
      aso_se_valid                      : in std_logic;
      aso_se_data                       : in std_logic_vector(23 downto 0)
                 -- export
    );
  end component audio_serializer;

  component Theremin_verify is
    generic (
      N : natural := 16  --Number of Bits of the sine wave (precision)
      );
      port (
        reset_n        : out  std_ulogic; -- asynchronous reset
        clk_24            : out  std_ulogic; -- clock
        Bclk         : out  std_ulogic; -- asynchronous reset, active low
        DACLRCK    : out  std_ulogic -- asynchronous reset, active low
      --  DACLRCK        : out std_logic
      );
  end component Theremin_verify;

  component sine1kHz is
    generic(
    count_freq  : integer := 47;
    count_samp  : integer := 256
  );
  
    port (
     reset        : in  std_logic; -- asynchronous reset
     clk            : in  std_logic; -- clock
   
     -- Streaming Source
    aso_se_ready      : in std_logic;
    aso_se_valid      : out std_logic;
    aso_se_data       : out std_logic_vector(23 downto 0)

  );
  end component sine1kHz;

  
begin
  
  -- Instance port mappings.
  verify_pm : entity work.Theremin_verify
    generic map (
      N => N
    )
    port map (
        reset_n        => reset,
        clk_24         => clk,
        Bclk           => Bclk,
        DACLRCK        => DACLRCK
    ); 

  sine_pm : entity work.sine1kHz
    generic map(
    count_freq  => 47,
    count_samp  => 500
  )  
    port map(
     reset            => reset,
     clk              => clk,
   
     -- Streaming Source
    aso_se_ready     => valid,
    aso_se_valid     => valid,
    aso_se_data      => data

  ); 

  serializer_pm : entity work.audio_serializer
    port map(
       reset        => reset,
       clk          => clk,
     
       -- Streaming Source
      coe_AUD1_BCLK                    => Bclk,
      coe_AUD2_DACDAT                  => open,
      coe_AUD3_DACLRCK                 => DACLRCK,
      aso_se_ready                     => ready,
      aso_se_valid                     => valid,
      aso_se_data                      => data
                 -- export
    );
  
  
end architecture struct;