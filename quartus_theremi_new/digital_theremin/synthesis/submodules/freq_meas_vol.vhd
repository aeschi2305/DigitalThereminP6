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
entity freq_meas_vol is
  generic (
    fsamp  : natural := 2400000;  --sampling frequency of the sine wave to be measured
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
    sfm_write     : in std_logic;
    sfm_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    sfm_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);

    audio_out     : in signed(sine_N-1 downto 0); 
    freq_diff     : out signed(N+Qprec-1 downto 0);
    volume_out    : out unsigned(17 downto 0);
    volume_enable : out std_logic;
    meas_enable  : in boolean
  );
end entity freq_meas_vol;



architecture rtl of freq_meas_vol is

  ---------------------------------------------------------------------------
  -- Components        
  ---------------------------------------------------------------------------

component count_freq_vol is
  generic (
    N : natural := 12;  --Number of Bits of the frequency value
    sine_N : natural:= 24;  --Number of Bits of the input sine wave
    max_per : natural := 2400;  --maximum period count value
    min_per : natural := 24     --minimum period count value
  );
  port(
    reset_n     : in std_ulogic;
    clk         : in std_ulogic;
    filt_in     : in signed(sine_N-1 downto 0); 
    per_cnt     : out unsigned(N-1 downto 0);
    enable_in   : in std_ulogic;
    enable_out  : out std_ulogic;
    freq_meas   : out std_ulogic
  );
end component count_freq_vol;

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

component fir_filter_vol is
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

end component fir_filter_vol;


Component CalGlis_vol is
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
    freq_enable : in std_ulogic;
    cal_done    : out std_ulogic;
    delay_index : in natural range 0 to 9;
    freq_meas   : in std_ulogic
  );
end component CalGlis_vol;
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  type t_vol_gain_array is array(integer range 0 to 9) of unsigned(17 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------

  constant vol_gain : t_vol_gain_array :=     ("000110011001100110",
                                               "001100110010110000",
                                               "010011001011111001",
                                               "011001100101000010",
                                               "011111111110001011",
                                               "100110010111010101",
                                               "101100110000011110",
                                               "110011001001100111",
                                               "111001100010110001",
                                               "111111111011111010");


  --constant freq_max      : unsigned(N-1 downto 0) := (N-1 downto 12 => '0') & "100111000100"; -- equals 2500 Hz
  constant freq_max      : unsigned(N-1 downto 0) := (N-1 downto 12 => '0') & "110110101100"; -- equals 3500 Hz
                                                                              
  constant offset     : unsigned(N-1 downto 0) := (N-1 downto 9 => '0') & "100101100"; -- equals 300Hz
  constant Qprec_vol  : natural := 18;
  
  signal per_cnt      : unsigned(N-1 downto 0);
  signal freq         : unsigned(N+Qprec-1 downto 0);
  signal freq_diff_int: signed(N+Qprec-1 downto 0);
  signal audio_filt   : signed(sine_N-1 downto 0);
  signal freq_vol_reg : unsigned(N-1 downto 0);
  signal freq_vol_cmb : unsigned(N-1 downto 0);
  signal volume       : unsigned(N+Qprec_vol-1 downto 0);
  signal volume_gold  : unsigned(N+Qprec_vol-1 downto 0);
  signal en_vol       : std_ulogic;
  signal en_freq      : std_ulogic;
  signal en_per       : std_ulogic;
  signal en_meas      : std_ulogic;
  signal init         : std_ulogic;
  signal start        : std_ulogic;
  signal enable_start : boolean;
  signal init_2         : std_ulogic;
  signal start_2        : std_ulogic;
  signal enable_start_2 : boolean;
  signal enable_cal   : std_ulogic;
  signal en_vol_calc  : std_ulogic;
  signal cal_done     : std_ulogic;
  signal freq_meas    : std_ulogic;

  signal cntrl_reg       : std_logic_vector(dat_len_avl-1 downto 0);
  signal vol_data_reg    : std_logic_vector(dat_len_avl-1 downto 0);
  signal vol_data_cmb    : std_logic_vector(dat_len_avl-1 downto 0);
  signal vol_gain_reg    : std_logic_vector(dat_len_avl-1 downto 0);

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
       cntrl_reg <= (others => '0');
     elsif rising_edge(clk) then
       if sfm_write = '1' then
         cntrl_reg <= sfm_writedata;
       elsif(cntrl_reg(1) = '1') then
         if cal_done = '1' then
           cntrl_reg(1) <= '0';
         end if;
       end if;
     end if;
   end process p_wr;

 p_rd : process(all)
 begin
    sfm_readdata <= cntrl_reg;
 end process p_rd;



p_gold_1 : process(reset_n,clk)
  begin
    if reset_n = '0' then
      init <= '0';
      start<= '0';
      freq_vol_reg <= (others => '0');
      en_vol_calc <= '0';
      enable_start <= false;
    elsif rising_edge(clk) then
    en_vol_calc<= '0';
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
        freq_vol_reg <= freq_vol_cmb;
        en_vol_calc <= '1';
      end if;
    end if;
end process p_gold_1;

p_gold_2 : process(reset_n,clk)
  begin
    if reset_n = '0' then
      init_2 <= '0';
      start_2<= '0';
      enable_start_2 <= false;
      volume_enable <= '0';
      volume <= (others => '0');
    elsif rising_edge(clk) then
    volume_enable <= '0';
      if en_vol_calc = '1' then
        init_2 <= '1';
        enable_start_2 <= true;
      elsif enable_start_2 = true then
        init_2 <= '0';
        start_2 <= '1'; 
        enable_start_2 <= false; 
      elsif en_vol = '1' then
        init_2 <= '0';
        start_2 <= '0';
      end if;
      if cntrl_reg(0) = '0' then
        volume <= (others => '1');
        volume_enable <= '1';
      elsif en_vol = '1' then
        volume_enable <= '1';
        volume <= volume_gold;
      end if;
    end if;
end process p_gold_2;

p_cmb : process(all)
  begin
    if freq(N+Qprec-1 downto Qprec) > offset then
      if freq(N+Qprec-1 downto Qprec) > freq_max then
        freq_vol_cmb <= freq_max - offset;
      else
        freq_vol_cmb <= freq(N+Qprec-1 downto Qprec) - offset;
      end if;
    else
      freq_vol_cmb <= (others => '0');
    end if;

end process p_cmb;

--delay <= to_integer(unsigned(delay_reg));

  ------------------------------------------------------------------------------
  -- Combinatorial Process
  ------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------
  -- Component assignements
  ------------------------------------------------------------------------------


  count_meas : entity work.count_freq_vol
       generic map (
     N        => N,  --Number of Bits of the frequency value
     sine_N   => sine_N,
     max_per  => 2400,  --maximum period count value
     min_per  => 24     --minimum period count value
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

  goldschmid_2 : entity work.goldschmidt
  generic map(
    N       => N, --Number of numerator and denominator Bits (precision)
    Qda     => Qda,  --Number for more precision
    Qprec   => Qprec_vol --Number of bits after the decimal point
  )
  port map(
    reset_n => reset_n,
    clk     => clk,
    init    => init_2,
    start   => start_2,
    num     => freq_vol_reg,
    den     => freq_max-offset,
    quo     => volume_gold,
    done    => en_vol
  );


  fir_vol : entity work.fir_filter_vol
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

  CalGlis_vol_1 : entity work.CalGlis_vol
  generic map(
    freq_len => N+Qprec,   -- bits of the freq signal
    glis_allow => false        -- enables the glissando functionality
  )
  port map(
    reset_n => reset_n,
    clk => clk,
    freq => freq,
    freq_diff => freq_diff_int,
    cal_enable => cntrl_reg(1),
    gli_enable => '0',
    freq_enable => en_freq,
    cal_done   => cal_done,
    delay_index => 0,
    freq_meas => freq_meas
  );

  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  freq_diff <= freq_diff_int;
  volume_out <= volume(Qprec_vol-1 downto 0);
 end rtl;
