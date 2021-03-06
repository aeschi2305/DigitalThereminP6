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
  en_out       : out std_ulogic;
  -- data input
  i_data       : in  signed( M-1 downto 0);
  -- filtered data 
  o_data       : out signed( O-1 downto 0));

end fir_filter_dec;
architecture rtl of fir_filter_dec is
type coeff_type is array (0 to N-1) of signed (O-1 downto 0);
constant addstages : natural := N-1; -- Number of summation stages
constant coeffs : coeff_type :=  ( "000000010101110001001010101",
                                   "000000100111100000011011011",
                                   "000001000101101011110010100",
                                   "000001101100101100110011001",
                                   "000010011010101000001100100",
                                   "000011001100000100011101000",
                                   "000011111100011111010011011",
                                   "000100100110110011100101101",
                                   "000101000110001101011001111",
                                   "000101010110111100100110110",
                                   "000101010110111100100110110",
                                   "000101000110001101011001111",
                                   "000100100110110011100101101",
                                   "000011111100011111010011011",
                                   "000011001100000100011101000",
                                   "000010011010101000001100100",
                                   "000001101100101100110011001",
                                   "000001000101101011110010100",
                                   "000000100111100000011011011",
                                   "000000010101110001001010101");


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

  ------------------------------------------------------------------------------
  -- Registered Process
  ------------------------------------------------------------------------------

 p_reg : process(reset_n,clk)
    begin
        if reset_n = '0' then
            l_mult : for ii in 0 to N-1 loop
              p_data_in_reg(ii) <= (others => '0');
            end loop l_mult;
            p_data_out_reg <= (others => '0');
            en_out <= '0';
        elsif rising_edge(clk) then
            en_out <= '0';
            if en_in = true and count_reg < dec-1 then --undersampling of the signal
              p_data_in_reg <= p_data_in_cmb;
              count_reg <= count_cmb;
            elsif en_in = true then
              p_data_out_reg <= p_data_out_cmb;
              en_out <= '1';
              count_reg <= 0;
            end if;
        end if;
    end process p_reg;

  ------------------------------------------------------------------------------
  -- Combinatorial Process
  -- applies FIR Filter
  ------------------------------------------------------------------------------

p_cmb : process(all)
    variable mult               : t_mult;
    variable sum                  : signed(O*2-1 downto 0);
    begin 
    p_data_in_cmb <= i_data(M-1 downto M-O) & p_data_in_reg(0 to p_data_in_reg'length-2); --shift register of the FIR filter
    l_mult : for ii in 0 to N-1 loop
        mult(ii) := p_data_in_reg(ii)*coeffs(ii);         --multiplication with all coefficients
    end loop l_mult;
    sum := to_signed(0,sum'length);
    l_add : for ii in 0 to N-1 loop               --sums up all products
        sum := sum+mult(ii);
    end loop l_add;
    p_data_out_cmb <= sum(O*2-1 downto O);

    count_cmb <= count_reg + 1;
    end process p_cmb;

  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------

    o_data <= p_data_out_reg; 
end rtl;