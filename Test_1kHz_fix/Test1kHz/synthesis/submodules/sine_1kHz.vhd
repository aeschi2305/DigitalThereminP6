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
    aso_seL_data       : out std_logic_vector(23 downto 0);

    aso_seR_ready      : in std_logic;
    aso_seR_valid      : out std_logic;
    aso_seR_data       : out std_logic_vector(23 downto 0)
  );
end entity sine1kHz;

architecture rtl of sine1kHz is
  constant rc_factor : natural := 1000; --Rate Change Factor
  constant one : signed (23 downto 0) := "000000000000000000000001";
  type sine_table is array (0 to 47) of signed (23 downto 0);
  constant sine : sine_table :=     ("000000000000000000000000",
                                     "000100001011010100010101",
                                     "001000010010000011111100",
                                     "001100001111101111000101",
                                     "010000000000000000000000",
                                     "010011011110101111100101",
                                     "010110101000001001111010",
                                     "011001011000110010011010",
                                     "011011101101100111101100",
                                     "011101100100000110101111",
                                     "011110111010001101110101",
                                     "011111101110011110101010",
                                     "011111111111111111111111",
                                     "011111101110011110101010",
                                     "011110111010001101110101",
                                     "011101100100000110101111",
                                     "011011101101100111101100",
                                     "011001011000110010011010",
                                     "010110101000001001111010",
                                     "010011011110101111100101",
                                     "010000000000000000000000",
                                     "001100001111101111000101",
                                     "001000010010000011111100",
                                     "000100001011010100010101",
                                     "000000000000000000000000",
                                     "111011110100101011101011",
                                     "110111101101111100000100",
                                     "110011110000010000111011",
                                     "110000000000000000000000",
                                     "101100100001010000011011",
                                     "101001010111110110000110",
                                     "100110100111001101100110",
                                     "100100010010011000010100",
                                     "100010011011111001010001",
                                     "100001000101110010001011",
                                     "100000010001100001010110",
                                     "100000000000000000000000",
                                     "100000010001100001010110",
                                     "100001000101110010001011",
                                     "100010011011111001010001",
                                     "100100010010011000010100",
                                     "100110100111001101100110",
                                     "101001010111110110000110",
                                     "101100100001010000011011",
                                     "110000000000000000000000",
                                     "110011110000010000111011",
                                     "110111101101111100000100",
                                     "111011110100101011101011");
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


  p_stL : process (reset, clk)
  
  begin
  if reset = '1' then
        aso_seL_valid <= '0';
  elsif rising_edge(clk) then
        if en_comb = true then
          aso_seL_valid <= '1';
        elsif aso_seL_ready = '1' then
          aso_seL_valid <= '0';
        end if;
  end if;
  end process p_stL;


  p_stR : process (reset, clk)
  
  begin
  if reset = '1' then
        aso_seR_valid <= '0';
  elsif rising_edge(clk) then
        if en_comb = true then
          aso_seR_valid <= '1';
        elsif aso_seR_ready = '1' then
          aso_seR_valid <= '0';
        end if;
  end if;
  end process p_stR;

  ------------------------------------------------------------------------------
  -- ST Process Process
  -- Handles the communication with the Streaming Interface
  ------------------------------------------------------------------------------

  aso_seL_data <= audio_reg ;
  aso_seR_data <= audio_reg ;


end rtl;