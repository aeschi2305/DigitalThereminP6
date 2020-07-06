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


entity Tone_generation_top is
  generic (
    dat_len_avl : natural := 24   --Number of Bits of Avalon data w/r
  );
  port( 
    -- Avalon Clock Reset Interfaces
    csi_clk           : in std_logic;
    rsi_reset_n       : in std_logic;
    -- Avalon Slave Port
 --   avs_sTG_write     : in std_logic;
 --   avs_sTG_address   : in std_logic;
 --   avs_sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
 --   avs_sTG_read      : in std_logic;
 --   avs_sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);
    -- Avalon Streaming Source Interface (for output data)
    aso_seR_ready      : in std_logic;
    aso_seR_valid     : out std_logic;
    aso_seR_data       : out std_logic_vector(23 downto 0);
    aso_seL_ready      : in std_logic;
    aso_seL_valid      : out std_logic;
    aso_seL_data       : out std_logic_vector(23 downto 0);
    -- Avalon conduit Interfaces
    coe_square_freq   : in std_logic;
    coe_DACLRC        : in std_logic;
    coe_freq_up_down  : in std_logic_vector(1 downto 0)
  );
end entity Tone_generation_top;

architecture struct of Tone_generation_top is
  -- Architecture declarations
  constant N      : natural := 16;
  constant stages : natural := 3;
  constant cordic_def_freq :natural := 577000;
  -- Internal signal declarations:
  signal sine                 : signed(N-1 downto 0);
  signal phi                  : signed(N-1 downto 0);
  signal mixer_out            : signed(N-1 downto 0);
  signal freq_div             : signed(N-1 downto 0);
  signal audio_out            : std_logic_vector(23 downto 0);

component cordic_Control is
    generic (
     N : natural := 16;  --Number of Bits of the sine wave (precision)
     cordic_def_freq : natural := 577000
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    phi : out signed(N-1 downto 0);      --calculated angle for cordic processor
    freq_div : in signed(N-1 downto 0);
    sig_freq_up_down : in std_logic_vector(1 downto 0)
  );
end component cordic_Control;

component filter is
  generic (
   N : natural := 16  --Number of Bits of the sine wave (precision)
  );
    port (
     reset_n        : in  std_ulogic; -- asynchronous reset
     clk            : in  std_ulogic; -- clock
     mixer_out      : in signed(N-1 downto 0);        --Input signal
     -- Streaming Source
     audio_out      : out std_logic_vector(23 downto 0);  --Output signal
     valid_R        : out std_logic;  --Control Signals
     valid_L        : out std_logic;  --Control Signals
     ready_R        : in std_logic;   
     ready_L        : in std_logic;
     
     DACLRCK     : in std_logic

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

component freq_mes is
    generic (
     N : natural := 16;  --Number of Bits of the sine wave (precision)
     dat_len_avl : natural := 31   --Number of Bits of Avalon data w/r
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    -- Slave Port
--    sTG_address   : in std_logic;
--    sTG_write     : in std_logic;
--    sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
--    sTG_read      : in  std_logic;
--    sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);

    audio_out     : in std_logic_vector(23 downto 0); 
    freq_div      : out signed(N-1 downto 0)  
  );
end component freq_mes;

begin


  aso_seR_data <= audio_out;
  aso_seL_data <= audio_out;
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
      freq_div    => freq_div,
      sig_freq_up_down => coe_freq_up_down
    ); 

  -- user design: cic
  cic_1 : entity work.filter
    generic map (
      N => N
    )
    port map (
      reset_n     => rsi_reset_n,
      clk         => csi_clk,
      mixer_out   => mixer_out,
      audio_out   => audio_out,
      valid_R     => aso_seR_valid,
      ready_R     => aso_seR_ready,
      valid_L     => aso_seL_valid,
      ready_L     => aso_seL_ready,

      DACLRCK      => coe_DACLRC


    ); 

  -- user design: freq_mes
  freq_mes_1 : entity work.freq_mes
    generic map (
      N => N,
      dat_len_avl => dat_len_avl
    )
    port map (
      reset_n       => rsi_reset_n,
      clk           => csi_clk,
  --    sTG_address   => avs_sTG_address,  
  --    sTG_write     => avs_sTG_write,
  --    sTG_writedata => avs_sTG_writedata,
  --    sTG_read      => avs_sTG_read,
  --    sTG_readdata  => avs_sTG_readdata,
      audio_out     => audio_out,
      freq_div      => freq_div
    ); 
  
end architecture struct;
