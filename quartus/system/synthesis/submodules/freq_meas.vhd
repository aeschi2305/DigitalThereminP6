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
    sfm_address   : in  std_logic_vector(1 downto 0);
    sfm_write     : in std_logic;
    sfm_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    sfm_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);

    audio_out     : in signed(sine_N-1 downto 0); 
    freq_diff     : out signed(N+Qprec-1 downto 0);
    meas_enable  : in boolean
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
  type t_digit is array(integer range <>) of std_logic_vector(6 downto 0);
  type t_vol_array is array(integer range 0 to 79) of unsigned(25 downto 0);
  type t_vol_gain_array is array(integer range 0 to 9) of unsigned(6 downto 0);

  constant vol_values : t_vol_array :=     (   "00000000000010011001101001",
                                               "00000000000010011101011000",
                                               "00000000000010100001001101",
                                               "00000000000010100101001000",
                                               "00000000000010101001001001",
                                               "00000000000010101101010000",
                                               "00000000000010110001011101",
                                               "00000000000010110101110001",
                                               "00000000000010111010001100",
                                               "00000000000010111110101110",
                                               "00000000000011000011010110",
                                               "00000000000011001000000110",
                                               "00000000000011001100111110",
                                               "00000000000011010001111100",
                                               "00000000000011010111000011",
                                               "00000000000011011100010001",
                                               "00000000000011100001101000",
                                               "00000000000011100111000111",
                                               "00000000000011101100101110",
                                               "00000000000011110010011111",
                                               "00000000000011111000011000",
                                               "00000000000011111110011010",
                                               "00000000000100000100100110",
                                               "00000000000100001010111011",
                                               "00000000000100010001011011",
                                               "00000000000100011000000100",
                                               "00000000000100011110110111",
                                               "00000000000100100101110110",
                                               "00000000000100101100111111",
                                               "00000000000100110100010011",
                                               "00000000000100111011110011",
                                               "00000000000101000011011110",
                                               "00000000000101001011010101",
                                               "00000000000101010011011000",
                                               "00000000000101011011101000",
                                               "00000000000101100100000101",
                                               "00000000000101101100101111",
                                               "00000000000101110101100110",
                                               "00000000000101111110101011",
                                               "00000000000110000111111111",
                                               "00000000000110010001100000",
                                               "00000000000110011011010001",
                                               "00000000000110100101010000",
                                               "00000000000110101111100000",
                                               "00000000000110111001111111",
                                               "00000000000111000100101110",
                                               "00000000000111001111101111",
                                               "00000000000111011011000000",
                                               "00000000000111100110100011",
                                               "00000000000111110010011000",
                                               "00000000000111111110011111",
                                               "00000000001000001010111001",
                                               "00000000001000010111100110",
                                               "00000000001000100100100111",
                                               "00000000001000110001111101",
                                               "00000000001000111111100111",
                                               "00000000001001001101100110",
                                               "00000000001001011011111011",
                                               "00000000001001101010100111",
                                               "00000000001001111001101001",
                                               "00000000001010001001000011",
                                               "00000000001010011000110100",
                                               "00000000001010101000111111",
                                               "00000000001010111001100010",
                                               "00000000001011001010011111",
                                               "00000000001011011011110110",
                                               "00000000001011101101101001",
                                               "00000000001011111111110111",
                                               "00000000001100010010100001",
                                               "00000000001100100101101000",
                                               "00000000001100111001001110",
                                               "00000000001101001101010001",
                                               "00000000001101100001110100",
                                               "00000000001101110110110111",
                                               "00000000001110001100011010",
                                               "00000000001110100010011111",
                                               "00000000001110111001000111",
                                               "00000000001111010000010001",
                                               "00000000001111101000000000",
                                               "11111111111111111111111111");
--"11111111111111111111111111"
  constant vol_gain : t_vol_gain_array :=     ( "0001101",
                                                "0011001",
                                                "0100110",
                                                "0110011",
                                                "1000000",
                                                "1001100",
                                                "1011001",
                                                "1100110",
                                                "1110010",
                                                "1111111");
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
     vol_gain_reg <= (others => '0');
   elsif rising_edge(clk) then
     Cal_Glis_2 <= Cal_Glis_1;
     Cal_Glis_3 <= Cal_Glis_1 and not Cal_Glis_2;
     if sfm_write = '1' then
       case sfm_address is
         when "00" => cntrl_reg <= sfm_writedata;
         when "10" => vol_gain_reg <= sfm_writedata;
         when others => cntrl_reg <= cntrl_reg;
       end case;
     elsif(cntrl_reg(1) = '1') then
        if cal_done = '1' then
          cntrl_reg(1) <= '0';
        elsif Cal_Glis_3(0) = '1' then
          cntrl_reg(1) <= '1';
        elsif Cal_Glis_3(1) = '1' then
          cntrl_reg(0) <= not cntrl_reg(0);
        end if;
     end if;
   end if;
 end process p_wr;

 p_rd : process(all)
 begin
    case sfm_address is
      when "00" => sfm_readdata <= cntrl_reg;
      when "01" => sfm_readdata <= vol_data_reg;
      when "10" => sfm_readdata <= vol_gain_reg;
      when others => sfm_readdata <= (others => '0');
    end case;
 end process p_rd;



p_reg : process(reset_n,clk)
  begin
    if reset_n = '0' then
      init <= '0';
      start<= '0';
      vol_data_reg <= (others => '0');
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
        vol_data_reg <= vol_data_cmb;
    end if;
end process p_reg;

p_cmb : process(all)
  variable vol_index : integer range 0 to vol_values'length-1;
  variable vol_mult : unsigned(13 downto 0);
  variable vol_mult_temp : unsigned(7 downto 0);
  begin
    l_freq_range : for ii in 0 to vol_values'length-2 loop
        if vol_values(ii) < freq and vol_values(ii+1) > freq then
            vol_index := ii;
        end if;
    end loop l_freq_range;
    vol_mult := to_unsigned(vol_index,7) *  vol_gain(to_integer(unsigned(vol_gain_reg)));
    vol_mult := shift_right(vol_mult,1);
    vol_mult_temp := vol_mult(13 downto 7) + (6 downto 1 => '0') & vol_mult(6);
    vol_data_cmb <= (31 downto 7 => '0') & std_logic_vector(vol_mult_temp(6 downto 0));
end process p_cmb;

--delay <= to_integer(unsigned(delay_reg));

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
end rtl;
