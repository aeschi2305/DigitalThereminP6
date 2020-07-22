-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cic_codec.vhd
-- Author  : andreas.frei@students.fhnw.ch
-----------------------------------------------------
-- Description : Test component for 1kHz square Wave
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity sine1kHz is
	
  	port (
  	 reset_n  	    : in  std_logic; -- asynchronous reset_n
     clk      	    : in  std_logic; -- clock
   
     -- Streaming Source
    coe_AUD1_BCLK                     : in  std_logic                     := 'X';             -- export
    coe_AUD2_DACDAT                   : out std_logic;                                        -- export
    coe_AUD3_DACLRCK                  : in  std_logic                     := 'X'              -- export
  );
end entity sine1kHz;

architecture rtl of sine1kHz is
  type sine_table is array (0 to 47) of signed (23 downto 0);
  constant sine : sine_table :=     ("000000000000000000000000",
                                     "000010111011000111110101",
                                     "000101110011000010110000",
                                     "001000100100100111010111",
                                     "001011001100110011001101",
                                     "001101101000101110000111",
                                     "001111110101101101010101",
                                     "010001110001010110011111",
                                     "010011011001100010001011",
                                     "010100101100011110010100",
                                     "010101101000110000000101",
                                     "010110001101010101011110",
                                     "010110011001100110011010",
                                     "010110001101010101011110",
                                     "010101101000110000000101",
                                     "010100101100011110010100",
                                     "010011011001100010001011",
                                     "010001110001010110011111",
                                     "001111110101101101010101",
                                     "001101101000101110000111",
                                     "001011001100110011001101",
                                     "001000100100100111010111",
                                     "000101110011000010110000",
                                     "000010111011000111110101",
                                     "000000000000000000000000",
                                     "111101000100111000001011",
                                     "111010001100111101010000",
                                     "110111011011011000101001",
                                     "110100110011001100110011",
                                     "110010010111010001111001",
                                     "110000001010010010101011",
                                     "101110001110101001100001",
                                     "101100100110011101110101",
                                     "101011010011100001101100",
                                     "101010010111001111111011",
                                     "101001110010101010100010",
                                     "101001100110011001100110",
                                     "101001110010101010100010",
                                     "101010010111001111111011",
                                     "101011010011100001101100",
                                     "101100100110011101110101",
                                     "101110001110101001100001",
                                     "110000001010010010101011",
                                     "110010010111010001111001",
                                     "110100110011001100110011",
                                     "110111011011011000101001",
                                     "111010001100111101010000",
                                     "111101000100111000001011");
  -- Internal signals:

  signal audio_cmb            : std_logic_vector(23 downto 0);
  signal audio_reg            : std_logic_vector(23 downto 0);
  signal sine_cmb            : std_logic_vector(23 downto 0);
  signal audio                : std_logic;
  signal DACLRCK_reg              : std_logic_vector(1 downto 0);
  signal DACLRCK_comb              : std_logic_vector(1 downto 0);
  signal BCLK_reg                 : std_logic_vector(1 downto 0);
  signal BCLK_cmb                 : std_logic_vector(1 downto 0);
  signal count_reg                : integer range 0 to 47;
  signal count_cmb                : integer range 0 to 47;

begin

  ------------------------------------------------------------------------------
  -- Comb Registerd Process 
  -- Also handles the communication with the STEAMING SOURCE INTERFACE
  ------------------------------------------------------------------------------
  p_reg : process (reset_n, clk)
  begin
    if reset_n = '0' then
      audio_reg <= (others => '0');
      DACLRCK_reg <= (others => '0');
      BCLK_reg <= (others => '0');
      count_reg <= 0;
    elsif rising_edge(clk) then
      DACLRCK_reg <= DACLRCK_comb;
      BCLK_reg <= BCLK_cmb;
      

      if BCLK_reg(1) = '1' and BCLK_reg(0) = '0' then
        audio <= audio_reg(audio_reg'high);
        audio_reg <= audio_cmb;
      end if;


      if DACLRCK_reg(0) /= DACLRCK_reg(1) then
        audio_reg <= sine_cmb;
        if DACLRCK_reg(0) = '1' then
          if count_reg = 47 then
            count_reg <= 0;
          else
            count_reg <= count_cmb;
          end if;
        end if;
      end if;

    end if;
  end process p_reg;
  ------------------------------------------------------------------------------
  -- Comb Combinatorial Process
  -- subtracts the old input value from the new
  ------------------------------------------------------------------------------
  p_comb_cmb : process (all)
    variable sine_tmp : std_logic_vector(23 downto 0);
  begin
      DACLRCK_comb <= DACLRCK_reg(0) & coe_AUD3_DACLRCK;
      BCLK_cmb <= BCLK_reg(0) & coe_AUD1_BCLK;
      count_cmb <= count_reg + 1;
      audio_cmb <= audio_reg(22 downto 0) & '0';

      sine_tmp := std_logic_vector(sine(count_reg));
      sine_tmp(sine_tmp'high) := not sine_tmp(sine_tmp'high);
      sine_cmb <= sine_tmp;
  end process p_comb_cmb;

coe_AUD2_DACDAT <= audio;

end rtl;