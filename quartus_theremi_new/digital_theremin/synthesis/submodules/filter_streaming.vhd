-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cic_streaming.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : CIC-Filter to Streaming Interface Converter
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity filter_streaming is
	generic (
	 N : natural := 27;	--Input Bits
   M : natural := 24  --Output Bits
	);
  	port (
  	 reset_n  	    : in  std_ulogic; -- asynchronous reset
     clk      	    : in  std_ulogic; -- clock
     cic_out 	    : in signed(N-1 downto 0);				--Input signal
     -- Streaming Source
     streaming     : out std_logic_vector(M-1 downto 0);	--Output signal
     valid        : out std_logic;	--Control Signals
     ready        : in std_logic;	

     vol_cntrl    : in std_logic;

     enable         : in boolean
  );
end entity filter_streaming;



architecture rtl of filter_streaming is

signal audio_reg : std_logic_vector(M-1 downto 0);
signal audio_cmb : std_logic_vector(M-1 downto 0);
begin

  p_reg : process (reset_n, clk)
  
  begin
  if reset_n = '0' then
          audio_reg <= (others => '0');
  elsif rising_edge(clk) then
        if enable = true then
          audio_reg <= audio_cmb;
         end if;
  end if;
  end process p_reg;



  p_comb_cmb : process (all)
  variable cic_gain  : signed(N*2-1 downto 0);
  variable audio_tmp : std_logic_vector(M-1 downto 0);
  begin
    cic_gain := cic_out * to_signed(121,cic_out'length);
    if vol_cntrl = '0' then
      audio_tmp := std_logic_vector(cic_gain(N-1+5 downto N-M+5));
    else
      audio_tmp := std_logic_vector(shift_right(cic_gain(N-1+5 downto N-M+5),3));
    end if;
    audio_tmp(audio_tmp'high) := not audio_tmp(audio_tmp'high);
    audio_cmb <= audio_tmp;
  end process p_comb_cmb;

  ------------------------------------------------------------------------------
  -- ST Process Process
  -- Handles the communication with the Streaming Interface
  ------------------------------------------------------------------------------


  p_st : process (reset_n, clk)
  
  begin
  if reset_n = '0' then
        valid <= '0';
  elsif rising_edge(clk) then
        if enable = true then
          valid <= '1';
        elsif ready = '1' then
          valid <= '0';
        end if;
  end if;
  end process p_st;

 

  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  streaming <= audio_reg;

end rtl;