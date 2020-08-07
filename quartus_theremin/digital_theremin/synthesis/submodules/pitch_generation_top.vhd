-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : pitch_generation_top.vhd
-- Author  :dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Custom IP pitch_generation_top 
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pitch_generation_top is
  generic (
    dat_len_avl : natural := 32;   --Number of Bits of Avalon data w/r
    cic1Bits : natural := 21;
    cic2Bits : natural := 25;
    cic3Bits : natural := 28;
    FIRBits : natural := 27;
    StreamingBits : natural := 24
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
end entity pitch_generation_top;

architecture struct of pitch_generation_top is
  -- Architecture declarations
  constant N      : natural := 16;
  constant stages : natural := 3;
  constant cordic_def_freq :natural := 570000;--569800;
  constant sine_N : natural := 18;

  -- Internal signal declarations:
  signal sine                 : signed(N-1 downto 0);
  signal phi                  : signed(N-1 downto 0);
  signal mixer_out            : signed(N-1 downto 0);
  signal freq_dif             : signed(N-1 downto 0);
  signal filter               : signed(FIRBits-1 downto 0);
  signal audio_meas           : signed(cic2Bits-1 downto 0);
  signal meas_enable         : boolean;
  signal freq_diff            : signed(25 downto 0);
  signal enable_amp           : std_ulogic;
  signal volume               : unsigned(17 downto 0);

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

component filter_pitch is
  generic (
   N : natural := 16;  --Number of Bits of the sine wave (precision)
   cic1Bits : natural := 21;
   cic2Bits : natural := 25;
   cic3Bits : natural := 28;
   FIRBits  : natural := 27
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
     cic3_en        : out boolean;

     FIR_out        : out signed(FIRBits-1 downto 0);
     FIR_enable     : out std_ulogic

  );
end component filter_pitch;

component amplifier is
  generic (
   N : natural := 27; --Input Bits
   M : natural := 24  --Output Bits
  );
    port (
     reset_n        : in  std_ulogic; -- asynchronous reset
     clk            : in  std_ulogic; -- clock
     filter_out      : in signed(N-1 downto 0);        --Input signal
     -- Streaming Source
     streaming     : out std_logic_vector(M-1 downto 0);  --Output signal
     valid        : out std_logic;  --Control Signals
     ready        : in std_logic; 

     volume_out    : in unsigned(17 downto 0);
     volume_enable : in std_logic;

     enable         : in std_ulogic
  );
end component amplifier;


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

component freq_meas_pitch is
  generic (
    fsamp  : natural := 1200000;  --sampling frequency of the sine wave to be measured
    N      : natural := 21; --Number of numerator and denominator bits
    Qda    : natural := 0;  --Number for more precision
    Qprec  : natural := 5;  --Number of bits after decimal point of quotient
    sine_N : natural := 18; --Number of bits of the sine Wave to be measured
    Coeffs : natural := 36;  --Number of FIR Filter Coefficients
    dat_len_avl : natural := 32
  );
  port(
    reset_n       : in std_ulogic;
    clk           : in std_ulogic;
    -- Slave Port
    avs_address   : in  std_logic_vector(1 downto 0);
    avs_write     : in std_logic;
    avs_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    avs_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);

    audio_out     : in std_logic_vector(31 downto 0); 
    freq_diff     : out signed(N+Qprec-1 downto 0);
    meas_enable   : in boolean;
    Cal_Glis_enable : in std_logic_vector(1 downto 0)
  );
end component freq_meas_pitch;

begin


  -- user design: mixer
  mixer_1 : entity work.mixer
    port map (
      clk         => csi_clk,
      reset_n     => rsi_reset_n,
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
      clk         => csi_clk,
      reset_n     => rsi_reset_n,
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
      clk         => csi_clk,
      reset_n     => rsi_reset_n,
      phi         => phi,
      freq_dif    => freq_diff,
      sig_freq_up_down => coe_freq_up_down
    ); 

  -- user design: cic
  filter_pitch_1 : entity work.filter_pitch
    generic map (
      N => N,
      cic1Bits => cic1Bits,
      cic2Bits => cic2Bits,
      cic3Bits => cic3Bits,
      FIRBits  => FIRBits
    )
    port map (
      reset_n     => rsi_reset_n,
      clk         => csi_clk,
      mixer_out   => mixer_out,

      cic1o       => open,
      cic2o       => audio_meas,
      cic3o       => open,

      cic1_en     => open,
      cic2_en     => meas_enable,
      cic3_en     => open,

      FIR_out     => filter,
      FIR_enable  => enable_amp


    ); 

  ampliifier_1 : entity work.amplifier
    generic map (
     N  => FIRBits, --Input Bits
     M  => StreamingBits  --Output Bits
    )
    port map(
     reset_n      => rsi_reset_n, 
     clk          => csi_clk,
     filter_out   => filter,
     -- Streaming Source
     streaming    => aso_se_data,
     valid        => aso_se_valid,
     ready        => aso_se_ready,

     volume_out    => volume,
     volume_enable => coe_vol_enable,

     enable        => enable_amp
  );

  -- user design: freq_mes
  freq_meas_pitch_1 : entity work.freq_meas_pitch
    generic map (
      fsamp  => 1200000, --sampling frequency of the sine wave to be measured
      N      => 21, --Number of numerator and denominator bits
      Qda    => 0,  --Number for more precision
      Qprec  => 5,  --Number of bits after decimal point of quotient
      sine_N => sine_N, --Number of bits of the sine Wave to be measured
      Coeffs => 37,  --Number of FIR Filter Coefficients
      dat_len_avl => dat_len_avl
    )
    port map (
      reset_n       => rsi_reset_n,
      clk           => csi_clk,
      -- Slave Port
      avs_address   => avs_sTG_address,
      avs_write     => avs_sTG_write,
      avs_writedata => avs_sTG_writedata,
      avs_readdata  => avs_sTG_readdata,

      audio_out     => audio_meas(cic2Bits-1 downto cic2Bits-sine_N),
      freq_diff     => freq_diff,
      meas_enable   => meas_enable,
      Cal_Glis_enable => coe_Cal_Glis
    ); 

    volume <= unsigned(coe_vol_volume); 
  
end architecture struct;
