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

    audio_out     : in signed(sine_N-1 downto 0); 
    freq_diff     : out signed(N+Qprec-1 downto 0);
    meas_enable  : in boolean;
    Cal_Glis_enable : in std_logic_vector(1 downto 0)
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
    enable_in   : in std_ulogic;
    enable_out  : out std_ulogic;
    freq_meas    : out std_ulogic
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
  reset_n    : in  std_logic;
  -- enable
  en_in      : in boolean;
  en_out     : out std_ulogic;
  -- data input
  i_data     : in  signed( sine_N-1 downto 0);
  -- filtered data 
  o_data     : out signed( sine_N-1 downto 0));

end component fir_filter;


Component CalGlis is
  generic (
    freq_len    : natural := 21;   -- bits of the freq signal
    glis_allow  : boolean        -- enables the glissando functionality
  );
  port(
    reset_n     : in std_ulogic;
    clk         : in std_ulogic;
    freq        : in unsigned(freq_len-1 downto 0);
    freq_diff   : out signed(freq_len-1 downto 0);
    cal_enable  : in std_ulogic;
    gli_enable  : in std_ulogic;
    mus_scale   : in std_ulogic;
    freq_enable : in std_ulogic;
    cal_done    : out std_ulogic;
    delay_index : in natural range 0 to 9;
    freq_meas    : in std_ulogic
  );
end component CalGlis;
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  type t_reg is array(integer range <>) of std_logic_vector(31 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  signal regs    : t_reg(0 to 2);



  
  signal per_cnt      : unsigned(N-1 downto 0);
  signal freq         : unsigned(N+Qprec-1 downto 0);
  signal freq_diff_int: signed(N+Qprec-1 downto 0);
  signal audio_filt   : signed(sine_N-1 downto 0);
  signal en_freq      : std_ulogic;
  signal en_per       : std_ulogic;
  signal en_meas      : std_ulogic;
  signal init         : std_ulogic;
  signal start        : std_ulogic;
  signal enable_start : boolean;
  signal enable_cal   : std_ulogic;
  signal cal_done     : std_ulogic;
  signal freq_meas     : std_ulogic;

  signal cntrl_reg       : std_logic_vector(dat_len_avl-1 downto 0);
  signal freq_data_reg   : std_logic_vector(dat_len_avl-1 downto 0);
  signal delay_reg       : std_logic_vector(dat_len_avl-1 downto 0);

  signal Cal_Glis_1 : std_logic_vector(1 downto 0);
  signal Cal_Glis_2 : std_logic_vector(1 downto 0);
  signal Cal_Glis_3 : std_logic_vector(1 downto 0);

  signal delay : integer range 0 to 9;

begin
  ------------------------------------------------------------------------------
  -- Registerd Process
  ------------------------------------------------------------------------------
 p_wr : process(reset_n,clk)
 begin
   if reset_n = '0' then
     cntrl_reg <= (31 downto 3 => '0') & "100"; --default calibration off, glissando off, penattonic sclae on
     delay_reg <= (31 downto 1 => '0') & '1';
   elsif rising_edge(clk) then
     Cal_Glis_1 <= Cal_Glis_enable;
     Cal_Glis_2 <= Cal_Glis_1;
     Cal_Glis_3 <= Cal_Glis_1 and not Cal_Glis_2;
     if avs_write = '1' then
       case avs_address is
         when "00" => cntrl_reg <= avs_writedata;
         when "10" => delay_reg <= avs_writedata;
         when others => cntrl_reg <= cntrl_reg;
       end case;
     elsif(cntrl_reg(1) = '1') then
        if cal_done = '1' then
          cntrl_reg(1) <= '0';
        end if;
     elsif Cal_Glis_3(0) = '1' then
       cntrl_reg(1) <= '1';
     elsif Cal_Glis_3(1) = '1' then
       cntrl_reg(0) <= not cntrl_reg(0);
     end if;
   end if;
 end process p_wr;

 p_rd : process(all)
 begin
    case avs_address is
      when "00" => avs_readdata <= cntrl_reg;
      when "01" => avs_readdata <= "000000" & std_logic_vector(freq);
      when others => avs_readdata <= (others => '0');
    end case;
 end process p_rd;



p_reg : process(reset_n,clk)
  begin
    if reset_n = '0' then
      init <= '0';
      start<= '0';
    elsif rising_edge(clk) then
      if en_per = '1' then
        init <= '1';
        enable_start <= true;
      elsif enable_start = true then
        init <= '0';
        start <= '1'; 
        enable_start <= false; 
      elsif en_freq = '1' then
        init <= '0';
        start <= '0';
      end if;



    end if;
end process p_reg;

delay <= to_integer(unsigned(delay_reg));

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
    enable_out  => en_per,
    freq_meas    => freq_meas
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

  CalGlis_1 : entity work.CalGlis
  generic map(
    freq_len => N+Qprec,   -- bits of the freq signal
    glis_allow => true        -- enables the glissando functionality
  )
  port map(
    reset_n => reset_n,
    clk => clk,
    freq => freq,
    freq_diff => freq_diff_int,
    cal_enable => cntrl_reg(1),
    gli_enable => cntrl_reg(0),
    mus_scale  => cntrl_reg(2),
    freq_enable => en_freq,
    cal_done   => cal_done,
    delay_index => delay,
    freq_meas => freq_meas
  );

  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  freq_diff <= freq_diff_int;
end rtl;
