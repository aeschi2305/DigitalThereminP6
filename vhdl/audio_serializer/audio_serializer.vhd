-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : audio_serializer.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : serializes the parallel audio data and communicates with the codec
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity audio_serializer is
	
  	port (
  	 reset_n  	    : in  std_logic; -- asynchronous reset
     clk      	    : in  std_logic; -- clock
   
     -- Streaming Source
    coe_AUD1_BCLK                     : in  std_logic;             -- Bitclock of the codec
    coe_AUD2_DACDAT                   : out std_logic;             -- serial data connecion of the codec
    coe_AUD3_DACLRCK                  : in  std_logic; 			   -- Left/right channel clock of the codec
    asi_se_ready                      : out std_logic;						--ready bit of the streaming interface
    asi_se_valid                      : in std_logic;						--valid bit of the streaming interface
    asi_se_data                       : in std_logic_vector(23 downto 0)	--data of the streaming interface
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
  p_ser_reg : process (reset_n, clk)
  begin
    if reset_n = '0' then
      audio_reg <= (others => '0');
      DACLRCK_reg <= (others => '0');
      BCLK_reg <= (others => '0');
      audio <= '0';
      streaming_data_reg <= (others => '0');
      emptied <= true;
    elsif rising_edge(clk) then
      DACLRCK_reg <= DACLRCK_comb;
      BCLK_reg <= BCLK_cmb;
      

      if BCLK_reg(1) = '1' and BCLK_reg(0) = '0' then	--Shift register for serialization
        audio <= audio_reg(audio_reg'high);
        audio_reg <= audio_cmb;
      end if;

      if DACLRCK_reg(0) /= DACLRCK_reg(1) then 		--Fills the shift register with audio data from streaming interface
        if DACLRCK_reg(0) = '1' then
          audio_reg <= streaming_data_reg;
        elsif DACLRCK_reg(0) = '0'  then
          audio_reg <= streaming_data_reg;
          emptied <= true;
        else
          audio_reg <= (others => '0');
        end if;
      end if;

      asi_se_ready <= '1';
      if emptied = true then 						--handles the streaming interface
        if asi_se_valid = '1' then
          streaming_data_reg <= streaming_data_cmb;
          asi_se_ready <= '0';
          emptied <= false;
        end if;
      end if;
    end if;
  end process p_ser_reg;
  ------------------------------------------------------------------------------
  -- Serializer Combinatorial Process
  ------------------------------------------------------------------------------
  p_ser_cmb : process (all)
    variable sine_tmp : std_logic_vector(23 downto 0);
  begin
      DACLRCK_comb <= DACLRCK_reg(0) & coe_AUD3_DACLRCK;
      BCLK_cmb <= BCLK_reg(0) & coe_AUD1_BCLK;
      audio_cmb <= audio_reg(22 downto 0) & '0';
      streaming_data_cmb <= asi_se_data;
  end process p_ser_cmb;


  
coe_AUD2_DACDAT <= audio;

end rtl;