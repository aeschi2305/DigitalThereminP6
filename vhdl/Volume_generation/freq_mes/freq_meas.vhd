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
    fsamp  : natural := 240000;  --sampling frequency of the sine wave to be measured
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
    avs_address   : in  std_logic_vector(1 downto 0);
    avs_write     : in std_logic;
    avs_writedata : in std_logic_vector(dat_len_avl-1 downto 0);
    avs_readdata  : out std_logic_vector(dat_len_avl-1 downto 0);

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
  reset_n    : in  std_logic;
  -- enable
  en_in      : in boolean;
  en_out     : out boolean;
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
    delay_index : in natural range 0 to 9
  );
end component CalGlis;
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  type t_reg is array(integer range <>) of std_logic_vector(31 downto 0);
  type t_digit is array(integer range <>) of std_logic_vector(6 downto 0);
  type t_vol_array is array(integer range 0 to 78) of signed(6 downto 0);
  type t_vol_gain_array is array(integer range 0 to 9) of signed(6 downto 0);

  constant vol_values : t_vol_array :=     (  "0010011001101001",
                                               "0010011101011000",
                                               "0010100001001101",
                                               "0010100101001000",
                                               "0010101001001001",
                                               "0010101101010000",
                                               "0010110001011101",
                                               "0010110101110001",
                                               "0010111010001100",
                                               "0010111110101110",
                                               "0011000011010110",
                                               "0011001000000110",
                                               "0011001100111110",
                                               "0011010001111100",
                                               "0011010111000011",
                                               "0011011100010001",
                                               "0011100001101000",
                                               "0011100111000111",
                                               "0011101100101110",
                                               "0011110010011111",
                                               "0011111000011000",
                                               "0011111110011010",
                                               "0100000100100110",
                                               "0100001010111011",
                                               "0100010001011011",
                                               "0100011000000100",
                                               "0100011110110111",
                                               "0100100101110110",
                                               "0100101100111111",
                                               "0100110100010011",
                                               "0100111011110011",
                                               "0101000011011110",
                                               "0101001011010101",
                                               "0101010011011000",
                                               "0101011011101000",
                                               "0101100100000101",
                                               "0101101100101111",
                                               "0101110101100110",
                                               "0101111110101011",
                                               "0110000111111111",
                                               "0110010001100000",
                                               "0110011011010001",
                                               "0110100101010000",
                                               "0110101111100000",
                                               "0110111001111111",
                                               "0111000100101110",
                                               "0111001111101111",
                                               "0111011011000000",
                                               "0111100110100011",
                                               "0111110010011000",
                                               "0111111110011111",
                                               "1000001010111001",
                                               "1000010111100110",
                                               "1000100100100111",
                                               "1000110001111101",
                                               "1000111111100111",
                                               "1001001101100110",
                                               "1001011011111011",
                                               "1001101010100111",
                                               "1001111001101001",
                                               "1010001001000011",
                                               "1010011000110100",
                                               "1010101000111111",
                                               "1010111001100010",
                                               "1011001010011111",
                                               "1011011011110110",
                                               "1011101101101001",
                                               "1011111111110111",
                                               "1100010010100001",
                                               "1100100101101000",
                                               "1100111001001110",
                                               "1101001101010001",
                                               "1101100001110100",
                                               "1101110110110111",
                                               "1110001100011010",
                                               "1110100010011111",
                                               "1110111001000111",
                                               "1111010000010001",
                                               "1111101000000000");

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
  signal en_per       : boolean;
  signal en_meas      : boolean;
  signal init         : std_ulogic;
  signal start        : std_ulogic;
  signal enable_start : boolean;
  signal enable_cal   : std_ulogic;
  signal cal_done     : std_ulogic;

  signal cntrl_reg       : std_logic_vector(dat_len_avl-1 downto 0);
  signal freq_data_reg   : std_logic_vector(dat_len_avl-1 downto 0);
  signal delay_reg       : std_logic_vector(dat_len_avl-1 downto 0);

  signal delay : integer range 0 to 9;

  signal vol_mult_reg : integer range 0 to vol_values'length;
  signal vol_mult_cmb : integer range 0 to vol_values'length;


begin
  ------------------------------------------------------------------------------
  -- Registerd Process
  ------------------------------------------------------------------------------
 p_wr : process(clk, reset_n)
 begin
   if reset_n = '0' then
     cntrl_reg <= (others => '0');
     delay_reg <= (others => '0');
   elsif rising_edge(clk) then
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
     end if;
   end if;
 end process p_wr;

 p_rd : process(all)
 begin
    case avs_address is
      when '0' => avs_readdata <= cntrl_reg;
      when '1' => avs_readdata <= vol_mult_reg;
      when others => avs_readdata <= (others => '0');
    end case;
 end process p_rd;



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
      elsif en_freq = '1' then
        init <= '0';
        start <= '0';
      end if;

      vol_mult_reg <= vol_mult_cmb;



    end if;
end process p_reg;

p_cmb : process(all)
  variable vol_index : integer range 0 to vol_values'length;
  variable vol_mult : unsigned(13 downto 0);
  begin
    l_freq_range : for ii in 0 to vol_values'length-1 loop
        if vol_values(ii) < signed(freq) and vol_values(ii+1) > signed(freq) then
            vol_index := ii;
        end if;
    end loop l_freq_range;
    vol_index_cmb <= vol_index;
    vol_mult := to_unsigned(vol_index,7) *  vol_gain(cntrl_reg(cntrl_reg'length downto 1));
    vol_mult_cmb <= vol_mult(13 downto 7) + (6 downto 1 => '0') & vol_mult(6)
end process p_cmb

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

  CalFlis : entity work.CalGlis
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
    freq_enable => en_freq,
    cal_done   => cal_done,
    delay_index => delay
  );

  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  freq_diff <= freq_diff_int;
end rtl;
