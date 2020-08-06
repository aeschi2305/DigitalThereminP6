-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : FIR_Decimation.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Applies an FIR Filter and Decimates the sampling Frequency by the factor dec
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fir_filter_dec is
generic (
    N : natural := 22; --Number of Filter Coefficients
    M : natural := 29; --Number of Input Bits
    O : natural := 27; --Number of Output Bits

  dec : natural := 5   --Decimation Factor
);
port (
  clk        : in  std_logic;
  reset_n       : in  std_logic;
  -- enable
  en_in        : in boolean;
  en_out       : out boolean;
  -- data input
  i_data       : in  signed( M-1 downto 0);
  -- filtered data 
  o_data       : out signed( O-1 downto 0));

end fir_filter_dec;
architecture rtl of fir_filter_dec is
type coeff_type is array (0 to N-1) of signed (O-1 downto 0);
constant addstages : natural := N-1; -- Number of summation stages
constant coeffs : coeff_type :=  ("000000001100110100011000011",
                                  "000000011001101110101010100",
                                  "000000101111110110101001100",
                                  "000001001110001010111001110",
                                  "000001110100000011010000000",
                                  "000010011111100101100111000",
                                  "000011001101101000010011010",
                                  "000011111010000111101100110",
                                  "000100100000101001001111010",
                                  "000100111101000011100111001",
                                  "000101001100001000111001000",
                                  "000101001100001000111001000",
                                  "000100111101000011100111001",
                                  "000100100000101001001111010",
                                  "000011111010000111101100110",
                                  "000011001101101000010011010",
                                  "000010011111100101100111000",
                                  "000001110100000011010000000",
                                  "000001001110001010111001110",
                                  "000000101111110110101001100",
                                  "000000011001101110101010100",
                                  "000000001100110100011000011");






                                  --"000000000101100110000101100",
                                  --"111111101110011001010000011",
                                  --"111111000101101001100010001",
                                  --"111110001110001010101111011",
                                  --"111101100110110001011001000",
                                  --"111101111011011100011001010",
                                  --"111111110000111111110011110",
                                  --"000011001100011001010000111",
                                  --"000111100100110101001100000",
                                  --"001011101011111011100000110",
                                  --"001110001011100001010000001",
                                  --"001110001011100001010000001",
                                  --"001011101011111011100000110",
                                  --"000111100100110101001100000",
                                  --"000011001100011001010000111",
                                  --"111111110000111111110011110",
                                  --"111101111011011100011001010",
                                  --"111101100110110001011001000",
                                  --"111110001110001010101111011",
                                  --"111111000101101001100010001",
                                  --"111111101110011001010000011",
                                  --"000000000101100110000101100");

type t_data_pipe      is array (0 to N-1) of signed(O-1  downto 0);
type t_mult           is array (0 to N-1) of signed(O*2-1    downto 0);
signal p_data_in_reg               : t_data_pipe;
signal p_data_in_cmb               : t_data_pipe;
signal p_data_out_reg              : signed(O-1 downto 0);
signal p_data_out_cmb              : signed(O-1 downto 0);

signal DACLRCK_cmb       : std_logic_vector(2 downto 0);
signal DACLRCK_reg       : std_logic_vector(2 downto 0);

signal count_reg         : natural range 0 to 5;
signal count_cmb         : natural range 0 to 6;

begin

 p_reg : process(reset_n,clk)
    begin
        if reset_n = '0' then
            l_mult : for ii in 0 to N-1 loop
              p_data_in_reg(ii) <= (others => '0');
            end loop l_mult;
            p_data_out_reg <= (others => '0');
            en_out <= false;
        elsif rising_edge(clk) then
            en_out <= false;
            if en_in = true and count_reg < dec-1 then 
              p_data_in_reg <= p_data_in_cmb;
              count_reg <= count_cmb;
            elsif en_in = true then
              p_data_out_reg <= p_data_out_cmb;
              en_out <= true;
              count_reg <= 0;
            end if;
        end if;
    end process p_reg;

p_cmb : process(all)
    variable mult               : t_mult;
    variable sum                  : signed(O*2-1 downto 0);
    begin 
    p_data_in_cmb <= i_data(M-1 downto M-O) & p_data_in_reg(0 to p_data_in_reg'length-2);
    l_mult : for ii in 0 to N-1 loop
        mult(ii) := p_data_in_reg(ii)*coeffs(ii);
    end loop l_mult;
    sum := to_signed(0,sum'length);
    l_add : for ii in 0 to N-1 loop
        sum := sum+mult(ii);
    end loop l_add;
    p_data_out_cmb <= sum(O*2-1 downto O);

    count_cmb <= count_reg + 1;
    end process p_cmb;

    o_data <= p_data_out_reg; 
end rtl;