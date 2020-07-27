-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : Theremin_top.vhd
-- Author  : andreas.frei@students.fhnw.ch
-----------------------------------------------------
-- Description : Custom IP Tone_generation 
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Volume_generation_top is
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
end entity Volume_generation_top;

architecture struct of Volume_generation_top is
  -- Architecture declarations
  constant N      : natural := 16;
  constant stages : natural := 3;
  constant cordic_def_freq :natural := 578500;
  constant sine_N : natural := 18;

  -- Internal signal declarations:
  signal sine                 : signed(N-1 downto 0);
  signal phi                  : signed(N-1 downto 0);
  signal mixer_out            : signed(N-1 downto 0);
  signal freq_dif             : signed(N-1 downto 0);
  signal audio_out            : std_logic_vector(23 downto 0);
  signal audio_meas           : signed(cic3Bits-1 downto 0);
  signal meas_enable          : boolean;
  signal freq_diff            : signed(25 downto 0);
  signal clk                  : std_logic;
  signal reset_n              : std_logic;

component cordic_Control is
    generic (
     N : natural := 16;  --Number of Bits of the sine wave (precision)
     cordic_def_freq : natural := 577000
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    phi : out signed(N-1 downto 0);      --calculated angle for cordic processor
    freq_dif : in signed(N-1 downto 0);
    sig_freq_up_down : in std_logic_vector(1 downto 0)
  );
end component cordic_Control;

component filter is
  generic (
   N : natural := 16;  --Number of Bits of the sine wave (precision)
   cic1Bits : natural := 23;
   cic2Bits : natural := 26;
   cic3Bits : natural := 29
  );
    port (
     reset_n        : in  std_ulogic; -- asynchronous reset
     clk            : in  std_ulogic; -- clock
     mixer_out      : in signed(N-1 downto 0);        --Input signal
     -- Streaming Source
     audio_out      : out std_logic_vector(23 downto 0);  --Output signal
     valid          : out std_logic;  --Control Signals
     ready          : in std_logic;

     cic1o          : out signed(cic1Bits-1 downto 0);
     cic2o          : out signed(cic2Bits-1 downto 0);
     cic3o          : out signed(cic3Bits-1 downto 0);

     cic1_en        : out boolean;
     cic2_en        : out boolean;
     cic3_en        : out boolean
  );
end component filter;


component cordic_pipelined is
  generic (
    N : natural := 16; --Number of Bits of the sine wave (precision)
    stages : natural := 3
  );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    phi : in signed(N-1 downto 0);
    sine : out signed(N-1 downto 0)
  );
end component cordic_pipelined;

component mixer is
  generic (
   N : natural := 16  --Number of Bits of the sine wave (precision)
  );
    port (
     reset_n      : in  std_ulogic; -- asynchronous reset
     clk          : in  std_ulogic; -- clock
     square_freq  : in  std_ulogic; -- asynchronous reset, active low
     sine       : in signed(N-1 downto 0);
     mixer_out    : out signed(N-1 downto 0)
  );
end component mixer;

component freq_meas is
  generic (
    fsamp  : natural := 1200000;  --sampling frequency of the sine wave to be measured
    N      : natural := 21; --Number of numerator and denominator bits
    Qda    : natural := 0;  --Number for more precision
    Qprec  : natural := 5;  --Number of bits after decimal point of quotient
    sine_N : natural := 18; --Number of bits of the sine Wave to be measured
    Coeffs : natural := 16;  --Number of FIR Filter Coefficients
    dat_len_avl : natural := 32
  );
  port(
    reset_n       : in std_ulogic;
    clk           : in std_ulogic;
    -- Slave Port
    sfm_address   : in  std_logic_vector(1 downto 0);
    sfm_write     : in std_logic;
    sfm_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    sfm_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);

    audio_out     : in std_logic_vector(31 downto 0); 
    freq_diff     : out signed(N+Qprec-1 downto 0);
    meas_enable  : in boolean
  );
end component freq_meas;

begin

  clk <= csi_clk;
  reset_n <= rsi_reset_n;
  -- user design: mixer
  mixer_1 : entity work.mixer
    port map (
      clk         => clk,
      reset_n     => reset_n,
      square_freq => coe_square_freq,
      sine        => sine,
      mixer_out   => mixer_out
    ); 

  -- user design: cordic_pipelinded
  cordic_pipelined_1 : entity work.cordic_pipelined
    generic map (
      N => N,
      stages => stages
    )
    port map (
      clk         => clk,
      reset_n     => reset_n,
      phi         => phi,
      sine        => sine
    ); 

  -- user design: cordic_control
  cordic_Control_1 : entity work.cordic_Control
    generic map (
      N => N,
      cordic_def_freq => cordic_def_freq
    )
    port map (
      clk         => clk,
      reset_n     => reset_n,
      phi         => phi,
      freq_dif    => freq_diff,
      sig_freq_up_down => coe_freq_up_down
    ); 

  -- user design: cic
  cic_1 : entity work.filter
    generic map (
      N => N,
      cic1Bits => cic1Bits,
      cic2Bits => cic2Bits,
      cic3Bits => cic3Bits
    )
    port map (
      reset_n     => reset_n,
      clk         => clk,
      mixer_out   => mixer_out,
      audio_out   => open,
      valid       => open,
      ready       => '0',

      cic1o       => open,
      cic2o       => open,
      cic3o       => audio_meas,

      cic1_en     => open,
      cic2_en     => open,
      cic3_en     => meas_enable
    ); 

  -- user design: freq_mes
  freq_meas_1 : entity work.freq_meas
    generic map (
      fsamp  => 240000, --sampling frequency of the sine wave to be measured
      N      => 21, --Number of numerator and denominator bits
      Qda    => 0,  --Number for more precision
      Qprec  => 5,  --Number of bits after decimal point of quotient
      sine_N => sine_N, --Number of bits of the sine Wave to be measured
      Coeffs => 16,  --Number of FIR Filter Coefficients
      dat_len_avl => dat_len_avl
    )
    port map (
      reset_n       => reset_n,
      clk           => clk,
      -- Slave Port
      sfm_address   => avs_sVG_address,
      sfm_write     => avs_sVG_write,
      sfm_writedata => avs_sVG_writedata,
      sfm_readdata  => avs_sVG_readdata,

      audio_out     => audio_meas(cic3Bits-1 downto cic3Bits-sine_N),
      freq_diff     => freq_diff,
      meas_enable   => meas_enable
    ); 
  
end architecture struct;
