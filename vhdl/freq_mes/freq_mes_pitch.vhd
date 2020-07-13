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
entity freq_mes is
    generic (
     fsamp  : natural := 1200000  --sampling frequency of the sine wave to be measured
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
    sTG_address   : in  std_logic;
    sTG_write     : in std_logic;
    sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
    sTG_read      : in  std_logic;
    sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);

    audio_out     : in std_logic_vector(31 downto 0); 
    freq_diff     : out signed(N-1 downto 0);
    audio_enable  : in boolean
  );
end entity freq_mes;

component count_freq_meas is
  generic (
    N           : natural := 21;  --Number of Bits of the frequency value
    dat_len_avl : natural := 31;   --Number of Bits of Avalon data w/r
    sine_N      : natural := 24
  );
  port(
    reset_n     : in std_ulogic;
    clk         : in std_ulogic;
    audio_out   : in std_logic_vector(sine_N-1 downto 0); 
    per_cnt     : out unsigned(N-1 downto 0);
    enable      : out boolean
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

architecture rtl of freq_mes is
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
  signal en_freq  : boolean;
  signal en_meas  : boolean;

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
      
    elsif rising_edge(clk) then
      if audio_enable = true then

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
    );
  port map(
    reset_n   => reset_n,
    clk       => clk,
    audio_out => audio_out,
    per_cnt   => per_cnt,
    enable    => en_meas
  );


  goldschmidt : entity work.goldschmidt
  generic map(
    N       => N, --Number of numerator and denominator Bits (precision)
    Qda     => Qda,  --Number for more precision
    Qprec   => Qprec --Number of bits after the decimal point
  );
  port map(
    reset_n => reset_n,
    clk     => clk,
    init    => init,
    start   => start,
    num     => unsigned(fsamp, N)
    den     => per_cnt,
    quo     => freq,
    done    => en_freq
  );


  fir : entity work.fir_filter_pitch_meas
    generic (
      N => Coeffs, --Number of Filter Coefficients
      M => sine_N, --Number of Input Bits
      O => sine_N --Number of Output Bits
    );
    port (
      clk      => clk,
      reset_n  => reset_n,
      en_in    => audio_enable,
      en_out   => en_meas,
      i_data   => ;
      o_data       : out signed( O-1 downto 0));
    );

  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
 
end rtl;
