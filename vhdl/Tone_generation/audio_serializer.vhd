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

entity audio_serializer is
	
  	port (
  	 reset  	    : in  std_logic; -- asynchronous reset
     clk      	    : in  std_logic; -- clock
   
     -- Streaming Source
    coe_AUD1_BCLK                     : in  std_logic;             -- export
    coe_AUD2_DACDAT                   : out std_logic;                                        -- export
    coe_AUD3_DACLRCK                  : in  std_logic; 
    aso_se_ready                      : out std_logic;
    aso_se_valid                      : in std_logic;
    aso_se_data                       : in std_logic_vector(23 downto 0)
               -- export
  );
end entity audio_serializer;

architecture rtl of audio_serializer is
  
  constant zero               : std_logic_vector (23 downto 0) := (others => '0');
  signal audio_cmb            : std_logic_vector(23 downto 0);
  signal audio_reg            : std_logic_vector(23 downto 0);
  signal streaming_data_reg       : std_logic_vector (23 downto 0);
  signal streaming_data_cmb       : std_logic_vector (23 downto 0);
  signal audio                : std_logic;
  signal DACLRCK_reg              : std_logic_vector(1 downto 0);
  signal DACLRCK_comb              : std_logic_vector(1 downto 0);
  signal BCLK_reg                 : std_logic_vector(1 downto 0);
  signal BCLK_cmb                 : std_logic_vector(1 downto 0);
  signal emptied              : boolean;
  signal full                : boolean;


begin

  ------------------------------------------------------------------------------
  -- Serializer Registerd Process 
  -- Also handles the communication with the STEAMING SOURCE INTERFACE
  ------------------------------------------------------------------------------
  p_ser_reg : process (reset, clk)
  begin
    if reset = '0' then
      audio_reg <= (others => '0');
      DACLRCK_reg <= (others => '0');
      BCLK_reg <= (others => '0');
      audio <= '0';
      streaming_data_reg <= (others => '0');
      emptied <= true;
    elsif rising_edge(clk) then
      DACLRCK_reg <= DACLRCK_comb;
      BCLK_reg <= BCLK_cmb;
      

      if BCLK_reg(1) = '1' and BCLK_reg(0) = '0' then
        audio <= audio_reg(audio_reg'high);
        audio_reg <= audio_cmb;
      end if;

      if DACLRCK_reg(0) /= DACLRCK_reg(1) then
        
        if DACLRCK_reg(0) = '1' then
          audio_reg <= streaming_data_reg;
        elsif DACLRCK_reg(0) = '0'  then
          audio_reg <= streaming_data_reg;
          emptied <= true;
        else
          audio_reg <= (others => '0');
        end if;
      end if;

      aso_se_ready <= '1';
      if emptied = true then
        if aso_se_valid = '1' then
          streaming_data_reg <= streaming_data_cmb;
          aso_se_ready <= '0';
          emptied <= false;
        end if;
      end if;
    end if;
  end process p_ser_reg;
  ------------------------------------------------------------------------------
  -- Serializer Combinatorial Process
  -- subtracts the old input value from the new
  ------------------------------------------------------------------------------
  p_ser_cmb : process (all)
    variable sine_tmp : std_logic_vector(23 downto 0);
  begin
      DACLRCK_comb <= DACLRCK_reg(0) & coe_AUD3_DACLRCK;
      BCLK_cmb <= BCLK_reg(0) & coe_AUD1_BCLK;
      audio_cmb <= audio_reg(22 downto 0) & '0';
      streaming_data_cmb <= aso_se_data;
  end process p_ser_cmb;


  
coe_AUD2_DACDAT <= audio;

end rtl;