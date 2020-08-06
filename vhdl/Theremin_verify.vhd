-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : theremin_verify.vhd
-- Author  : andreas.frei@students.fhnw.ch
-----------------------------------------------------
-- Description : Stimulus and Monitor 
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity Theremin_verify is
  generic (
    N : natural := 16;  --Number of Bits of the sine wave (precision)
    dat_len_avl : natural := 32
    );
    port (
      reset_n           : out  std_ulogic; -- asynchronous reset
      clk               : out  std_ulogic; -- clock
      square_freq_vol   : out  std_ulogic;
      square_freq_pitch : out  std_ulogic; -- asynchronous reset, active low

      avs_write     : out std_logic;
      avs_writedata : out std_logic_vector(dat_len_avl-1 downto 0)
    );
end entity Theremin_verify;

architecture stimuli_and_monitor of Theremin_verify is
  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ
  constant c_cycle_time_rect_vol  : time := 1.821493625 us; --549kHz --1.818843216 us; --549.8kHz
  constant c_cycle_time_rect_pitch : time := 1.757469244 us; --569kHz
  --constant c_cycle_time_DACLRCK  : time := 20.83333 us; --48kHz
  constant enable : boolean   := true;
begin
  

  -- 54MHz
  p_system_clk : process
  begin
    reset_n <= transport '0', '1' after 2*c_cycle_time;
    while enable loop
      clk <= '0';
      wait for c_cycle_time/2;
      clk <= '1';
      wait for c_cycle_time/2;
    end loop;
    wait;  -- don't do it again
  end process p_system_clk;

    -- square from the pitch antenna
  p_clk_rect_pitch : process
  begin
    square_freq_pitch <= '0';
    wait for 2*c_cycle_time;
    while enable loop
      square_freq_pitch <= '0';
      wait for c_cycle_time_rect_pitch/2;
      square_freq_pitch <= '1';
      wait for c_cycle_time_rect_pitch/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect_pitch;

      -- square from the volume antenna
  p_clk_rect_vol : process
  begin
    square_freq_vol <= '0';
    wait for 2*c_cycle_time;
    while enable loop
      square_freq_vol <= '0';
      wait for c_cycle_time_rect_vol/2;
      square_freq_vol <= '1';
      wait for c_cycle_time_rect_vol/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect_vol;

  p_control : process
  begin
    avs_writedata <= (others => '0');
    avs_write <= '0';

    --wait until rising_edge(<<Signal .calibration_tb.Volume_generation_pm.freq_meas_1.en_freq : std_ulogic>>);

    wait for 20*c_cycle_time;
    
    avs_writedata <= (dat_len_avl-1 downto 1 => '0') & '1';
    avs_write <= '1';
    wait for c_cycle_time;
    avs_write <= '0';
    
    
    
    --enable <= false;
    wait;
  end process p_control;


end architecture stimuli_and_monitor;