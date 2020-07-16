-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : freq_mes.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Frequency measurement 
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
entity freq_meas is
  generic (
    fsamp  : natural := 1200000;  --sampling frequency of the sine wave to be measured
    N      : natural := 21; --Number of numerator and denominator bits
    Qda    : natural := 0;  --Number for more precision
    Qprec  : natural := 5;  --Number of bits after decimal point of quotient
    sine_N : natural := 18; --Number of bits of the sine Wave to be measured
    Coeffs : natural := 36  --Number of FIR Filter Coefficients
  );
  port(
    reset_n       : in std_ulogic;
    clk           : in std_ulogic;
    -- Slave Port
    --sTG_address   : in  std_logic;
    --sTG_write     : in std_logic;
    --sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
    --sTG_read      : in  std_logic;
    --sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);

    audio_out     : in signed(sine_N-1 downto 0); 
    freq_diff     : out unsigned(N+Qprec-1 downto 0);
    meas_enable  : in boolean;
    enable_out    : out boolean
  );
end entity freq_meas;



architecture rtl of freq_meas is

  ---------------------------------------------------------------------------
  -- Components        
  ---------------------------------------------------------------------------

component count_freq_meas is
  generic (
    N : natural := 12;  --Number of Bits of the frequency value
    sine_N : natural:= 24;  --Number of Bits of the input sine wave
    max_per : natural := 12000;  --maximum period count value
    min_per : natural := 500     --minimum period count value
  );
  port(
    reset_n     : in std_ulogic;
    clk         : in std_ulogic;
    filt_in     : in signed(sine_N-1 downto 0); 
    per_cnt     : out unsigned(N-1 downto 0);
    enable_in   : in boolean;
    enable_out  : out boolean
  );
end component count_freq_meas;

component goldschmidt is
  generic (
    N        : natural := 21; --Number of numerator and denominator Bits (precision)
    Qda      : natural := 10;  --Number for more precision
    Qprec    : natural := 5 --Number of bits after the decimal point
  );
  port(
    reset_n  : in std_ulogic;
    clk      : in std_ulogic;
    init     : in std_ulogic;
    start    : in std_ulogic;
    num      : in unsigned(N-1 downto 0);
    den      : in unsigned(N-1 downto 0);
    quo      : out unsigned(N+Qprec-1 downto 0);
    done     : out std_ulogic
  );
end component goldschmidt;

component fir_filter is
generic (
    N : natural := 36; --Number of Filter Coefficients
    M : natural := 29; --Number of Input Bits
    O : natural := 27 --Number of Output Bits
);
port (
  clk        : in  std_logic;
  reset_n       : in  std_logic;
  -- enable
  en_in        : in boolean;
  en_out       : out boolean;
  -- data input
  i_data       : in  signed( sine_N-1 downto 0);
  -- filtered data 
  o_data       : out signed( sine_N-1 downto 0));

end component fir_filter;
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  type t_reg is array(integer range <>) of std_logic_vector(31 downto 0);
  type t_digit is array(integer range <>) of std_logic_vector(6 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  signal regs    : t_reg(0 to 2);



  
  signal per_cnt  : unsigned(N-1 downto 0);
  signal freq     : unsigned(N+Qprec-1 downto 0);
  signal audio_filt : signed(sine_N-1 downto 0);
  signal en_freq  : boolean;
  signal en_per   : boolean;
  signal en_meas  : boolean;
  signal init     : std_ulogic;
  signal start    : std_ulogic;
  signal enable_start : boolean;

begin
  ------------------------------------------------------------------------------
  -- Registerd Process
  ------------------------------------------------------------------------------
   -- 1. Avalon R/W Register
-- p_avs : process(clk, reset_n)
-- begin
--   if reset_n = '0' then
--     regs <= (others => (others => '0'));
--   elsif rising_edge(clk) then
--     if sTG_write = '1' then
--       case sTG_address is
--         when '0' =>
--           regs(0) <= sTG_writedata;
--         when others =>
--           regs(1) <= sTG_writedata;
--       end case;
--     end if;
--   end if;
-- end process p_avs;

-- with sTG_address select
--   sTG_readdata <= regs(0) when '0',
--   regs(1)                when others; 


p_reg : process(reset_n,clk)
  begin
    if reset_n = '0' then
      init <= '0';
      start<= '0';
    elsif rising_edge(clk) then
      if en_per = true then
        init <= '1';
        enable_start <= true;
      elsif enable_start = true then
        init <= '0';
        start <= '1'; 
        enable_start <= false; 
      elsif en_freq = true then
        init <= '0';
        start <= '0';
      end if;

    end if;
end process p_reg;

  ------------------------------------------------------------------------------
  -- Combinatorial Process
  ------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------
  -- Component assignements
  ------------------------------------------------------------------------------


  count_meas : entity work.count_freq_meas
       generic map (
     N        => N,  --Number of Bits of the frequency value
     sine_N   => sine_N
    )
  port map(
    reset_n     => reset_n,
    clk         => clk,
    filt_in   => audio_filt,
    per_cnt     => per_cnt,
    enable_in   => en_meas,
    enable_out  => en_per
  );


  goldschmid_1 : entity work.goldschmidt
  generic map(
    N       => N, --Number of numerator and denominator Bits (precision)
    Qda     => Qda,  --Number for more precision
    Qprec   => Qprec --Number of bits after the decimal point
  )
  port map(
    reset_n => reset_n,
    clk     => clk,
    init    => init,
    start   => start,
    num     => to_unsigned(fsamp, N),
    den     => per_cnt,
    quo     => freq,
    done    => en_freq
  );


  fir : entity work.fir_filter
    generic map(
      N => Coeffs, --Number of Filter Coefficients
      M => sine_N, --Number of Input Bits
      O => sine_N --Number of Output Bits
    )
    port map(
      clk      => clk,
      reset_n  => reset_n,
      en_in    => meas_enable,
      en_out   => en_meas,
      i_data   => audio_out,
      o_data   => audio_filt
    );

  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  freq_diff <= freq;
  enable_out <= en_freq;
end rtl;
