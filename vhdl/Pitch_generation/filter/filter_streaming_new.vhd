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

     volume_out    : in unsigned(17 downto 0);
     volume_enable : in std_logic;

     enable         : in std_ulogic
  );
end entity filter_streaming;



architecture rtl of filter_streaming is

type t_reg_input is array(integer range <>) of signed(N-1 downto 0);

constant zero_cross_pos : signed(N-1 downto 0) := (N-1 downto 4 => '0') & "1000";
constant zero_cross_neg : signed(N-1 downto 0) := (N-1 downto 4 => '1') & "1000";
constant zero           : signed(N-1 downto 0) := (others => '0');
constant zero_vol       : unsigned(17 downto 0) := (others => '0');
constant cic_gain_const : signed(8 downto 0) :=  "011101101";   -- equals gain (5.53) * 2^5

signal audio_s_reg       : t_reg_input(1 downto 0);
signal audio_reg : std_logic_vector(M-1 downto 0);
signal audio_cmb : std_logic_vector(M-1 downto 0);
signal audio_signed : signed(M-1 downto 0);
signal volume : unsigned(17 downto 0);
signal volume_actual : unsigned(17 downto 0);
signal count_reg : integer range 0 to 5;
signal count_cmb : integer range 0 to 6;
begin

  p_reg : process (reset_n, clk)
  
  begin
  if reset_n = '0' then
          audio_reg <= (others => '0');
          volume_actual <= (others => '0');
          count_reg <= 0;
          volume <= (others => '0');
  elsif rising_edge(clk) then
        if enable = '1' then
          audio_reg <= audio_cmb;
          audio_s_reg(0) <= cic_out;
          audio_s_reg(1) <= audio_s_reg(0);
         end if;
        if volume_enable = '1' then
          volume <= volume_out;
        end if;
        if (audio_s_reg(0) > zero and audio_s_reg(1) < zero) or (audio_s_reg(1) > zero and audio_s_reg(0) < zero) then
          if volume = zero_vol then
            if count_reg = 5 then
              volume_actual <= (others => '0');
              count_reg <= 0;
            else
              count_reg <= count_cmb;
            end if;
          else
            volume_actual <= volume;
            count_reg <= 0;
          end if;
        end if;

  end if;
  end process p_reg;



  p_comb_cmb : process (all)
  variable cic_gain  : signed(N+cic_gain_const'length-1 downto 0);
  variable audio_tmp : signed(M-1 downto 0);
  variable audio_tmp_2 : signed(M+volume_actual'length downto 0);
  variable audio_tmp_3 : std_logic_vector(M-1 downto 0);
  begin
    cic_gain := cic_out * cic_gain_const;
    audio_tmp := cic_gain(N+cic_gain_const'length-4 downto N+cic_gain_const'length-3-M);

    audio_tmp_2 := audio_tmp * signed('0' & volume_actual);

    --audio_tmp_3 := std_logic_vector(audio_tmp_2(audio_tmp_2'high-2 downto audio_tmp_2'high-audio_tmp_3'length-1));

    audio_signed <= audio_tmp_2(audio_tmp_2'high-1 downto audio_tmp_2'high-audio_signed'length);

    audio_cmb <= not audio_signed(audio_signed'high) & std_logic_vector(audio_signed(audio_signed'high-1 downto 0));
    --audio_cmb <= audio_tmp_3;

    count_cmb <= count_reg + 1;

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
        if enable = '1' then
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