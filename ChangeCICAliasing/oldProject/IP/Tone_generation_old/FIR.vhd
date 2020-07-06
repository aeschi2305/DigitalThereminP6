library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fir_filter is
generic (
    N : natural := 11; --Number of Filter Coefficients
    M : natural := 29; --Number of Input Bits
    O : natural := 31 --Number of Output Bits
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
  o_data       : out signed( O-1 downto 0);

  DACLRCK      : std_logic);
end fir_filter;
architecture rtl of fir_filter is
type coeff_type is array (0 to N-1) of signed (M-1 downto 0);
constant addstages : natural := 10;
constant coeffs : coeff_type :=  ("00000011111111001110101011000",
                                  "00001011111110001110111110000",
                                  "00010101100011100111010011100",
                                  "00100001100001111110110101000",
                                  "00101001101011000110000100101",
                                  "00101101100100001001110011011",
                                  "00101001101011000110000100101",
                                  "00100001100001111110110101000",
                                  "00010101100011100111010011100",
                                  "00001011111110001110111110000",
                                  "00000011111111001110101011000");
type t_data_pipe      is array (0 to N-1) of signed(M-1  downto 0);
type t_mult           is array (0 to N-1) of signed(M*2-1    downto 0);
signal p_data_in_reg               : t_data_pipe;
signal p_data_in_cmb               : t_data_pipe;
signal p_data_out_reg              : signed(O-1 downto 0);
signal p_data_out_cmb              : signed(O-1 downto 0);

signal DACLRCK_cmb       : std_logic_vector(2 downto 0);
signal DACLRCK_reg       : std_logic_vector(2 downto 0);
begin

 p_reg : process(reset_n,clk)
    begin
        if reset_n = '0' then
            l_mult : for ii in 0 to N-1 loop
              p_data_in_reg(ii) <= (others => '0');
            end loop l_mult;
            
            p_data_out_reg <= (others => '0');
        elsif rising_edge(clk) then
            DACLRCK_reg <= DACLRCK_cmb;
            if en_in = true then 
              p_data_in_reg <= p_data_in_cmb;
            end if;
            if DACLRCK_reg(2) = '0' and DACLRCK_reg(1) = '1' then 
              p_data_out_reg <= p_data_out_cmb;
              en_out <= true;
            else
              en_out <= false;
            end if;
        end if;
    end process p_reg;

p_cmb : process(all)
    variable mult               : t_mult;
    variable sum                  : signed(M*2+addstages-1 downto 0);
    begin 
    p_data_in_cmb <= i_data & p_data_in_reg(0 to p_data_in_reg'length-2);
    l_mult : for ii in 0 to N-1 loop
        mult(ii) := p_data_in_reg(ii)*coeffs(ii);
    end loop l_mult;
    sum := to_signed(0,sum'length);
    l_add : for ii in 0 to N-1 loop
        sum := sum+mult(ii);
    end loop l_add;
    p_data_out_cmb <= sum(M*2+addstages-1 downto M*2+addstages-O);

    DACLRCK_cmb <= DACLRCK_reg(1 downto 0) & DACLRCK;
    end process p_cmb;

    o_data <= p_data_out_reg; 
end rtl;