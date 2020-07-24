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

entity square1kHz is
	generic(
		count_freq  : integer := 12288;
    count_samp  : integer := 256
	);
	
  	port (
  	 reset  	    : in  std_logic; -- asynchronous reset
     clk      	    : in  std_logic; -- clock
   
     -- Streaming Source
     rect_out : signed
  );
end entity square1kHz;

architecture rtl of square1kHz is
  constant rc_factor : natural := 1000; --Rate Change Factor
  constant one : signed (23 downto 0) := "000000000000000000000001";
  -- Internal signals:
  signal count_freq_reg            : integer range 0 to count_freq;
  signal count_freq_cmb            : integer range 0 to (count_freq + 1);
  signal count_samp_reg            : integer range 0 to count_samp;
  signal count_samp_cmb            : integer range 0 to (count_samp + 1);
  signal square_reg       : signed(23 downto 0);
  signal square_cmb       : signed(23 downto 0);
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
      square_reg <= "000011111111111111111111";
      audio_reg <= (others => '0');  --The more zeros in front the smaller the amplitude
      count_samp_reg <= 0;
      count_freq_reg <= 0;
    elsif rising_edge(clk) then
        if count_samp_reg < count_samp then 
          count_samp_reg <= count_samp_cmb; 
          en_comb <= false;

        else
          count_samp_reg <= 0;
          
          audio_reg <= audio_cmb;
          en_comb <= true;
        end if;   

        if count_freq_reg < count_freq then
          count_freq_reg <= count_freq_cmb;
        else 
          count_freq_reg <= 0;
          square_reg <= square_cmb;
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

    square_tmp := not(square_reg);
    square_tmp := square_tmp + one;
    square_cmb <= square_tmp;

    audio_tmp := std_logic_vector(square_reg);
    audio_tmp(audio_tmp'high) := not square_reg(audio_tmp'high);
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