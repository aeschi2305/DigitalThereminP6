-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : sine_1kHz.vhd
-- Author  : andreas.frei@students.fhnw.ch
-----------------------------------------------------
-- Description : Test component for 1kHz square Wave
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity sine1kHz is
	generic(
		count_freq  : integer := 47;
    count_samp  : integer := 256
	);
	
  	port (
  	 reset  	    : in  std_logic; -- asynchronous reset
     clk      	    : in  std_logic; -- clock
   
     -- Streaming Source
    aso_seL_ready      : in std_logic;
    aso_seL_valid      : out std_logic;
    aso_seL_data       : out std_logic_vector(23 downto 0)

  );
end entity sine1kHz;

architecture rtl of sine1kHz is
  constant rc_factor : natural := 1000; --Rate Change Factor
  constant one : signed (23 downto 0) := "000000000000000000000001";
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
  signal count_freq_reg            : integer range 0 to count_freq;
  signal count_freq_cmb            : integer range 0 to (count_freq + 1);
  signal count_samp_reg            : integer range 0 to count_samp;
  signal count_samp_cmb            : integer range 0 to (count_samp + 1);
  signal audio_cmb            : std_logic_vector(23 downto 0);
  signal audio_reg            : std_logic_vector(23 downto 0);
  signal en_comb              : boolean := false;
begin

  ------------------------------------------------------------------------------
  -- Comb Registerd Process 
  -- Also handles the communication with the STEAMING SOURCE INTERFACE
  ------------------------------------------------------------------------------
  p_square_reg : process (reset, clk)
  begin
    if reset = '1' then
      audio_reg <= (others => '0');  --The more zeros in front the smaller the amplitude
      count_samp_reg <= 0;
      count_freq_reg <= 0;
    elsif rising_edge(clk) then
        if count_samp_reg < count_samp then 
          count_samp_reg <= count_samp_cmb; 

          en_comb <= false;

        else
          if count_freq_reg < count_freq then
            count_freq_reg <= count_freq_cmb;
          else 
            count_freq_reg <= 0;
          end if; 
          count_samp_reg <= 0;
          
          audio_reg <= audio_cmb;
          en_comb <= true;
        end if;   

    end if;
  end process p_square_reg;
  ------------------------------------------------------------------------------
  -- Comb Combinatorial Process
  -- subtracts the old input value from the new
  ------------------------------------------------------------------------------
  p_comb_cmb : process (all)
  variable audio_tmp : std_logic_vector(23 downto 0);
  variable square_tmp : signed(23 downto 0);
  begin
    count_samp_cmb <= count_samp_reg + 1;
    count_freq_cmb <= count_freq_reg + 1;



    audio_tmp := std_logic_vector(sine(count_freq_reg));
    audio_tmp(audio_tmp'high) := not audio_tmp(audio_tmp'high);
    audio_cmb <= audio_tmp;
  end process p_comb_cmb;

  ------------------------------------------------------------------------------
  -- ST Process Process
  -- Handles the communication with the Streaming Interface
  ------------------------------------------------------------------------------


  p_st : process (reset, clk)
  
  begin
  if reset = '1' then
        aso_se_valid <= '0';
  elsif rising_edge(clk) then
        if en_comb = true then
          aso_se_valid <= '1';
        elsif aso_se_ready = '1' then
          aso_se_valid <= '0';
        end if;
  end if;
  end process p_st;

  ------------------------------------------------------------------------------
  -- ST Process Process
  -- Handles the communication with the Streaming Interface
  ------------------------------------------------------------------------------

  aso_se_data <= audio_reg ;



end rtl;