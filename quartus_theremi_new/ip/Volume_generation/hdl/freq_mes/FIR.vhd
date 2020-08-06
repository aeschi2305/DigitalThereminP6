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
entity fir_filter is
generic (
    N : natural := 16; --Number of Filter Coefficients
    M : natural := 29; --Number of Input Bits
    O : natural := 27 --Number of Output Bits
);
port (
  clk        : in  std_logic;
  reset_n       : in  std_logic;
  en_in        : in boolean;                  -- input enable
  en_out       : out std_ulogic;                 -- output enable
  i_data       : in  signed( M-1 downto 0);   -- data input
  o_data       : out signed( O-1 downto 0));  -- data output
end entity fir_filter;

architecture rtl of fir_filter is
type coeff_type is array (0 to N-1) of signed (O-1 downto 0);
constant addstages : natural := N-1; -- Number of summation stages
constant coeffs : coeff_type :=  ("000001000010110111",
                                  "000001011111110011",
                                  "000010010110101010",
                                  "000011010100011011",
                                  "000100010010110001",
                                  "000101001010100001",
                                  "000101110100011110",
                                  "000110001010111110",
                                  "000110001010111110",
                                  "000101110100011110",
                                  "000101001010100001",
                                  "000100010010110001",
                                  "000011010100011011",
                                  "000010010110101010",
                                  "000001011111110011",
                                  "000001000010110111");
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
            en_out <= '0';
        elsif rising_edge(clk) then
            en_out <= '0';
            if en_in = true then 
              p_data_in_reg <= p_data_in_cmb;
              p_data_out_reg <= p_data_out_cmb;
              en_out <= '1';
            end if;
        end if;
    end process p_reg;

p_cmb : process(all)
    variable mult   : t_mult;
    variable sum    : signed(O*2-1 downto 0);
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
    
    end process p_cmb;

    o_data <= p_data_out_reg; 
end rtl;