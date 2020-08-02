-----------------------------------------------------
-- Project : Digital Calibration
-----------------------------------------------------
-- File    : Calibration_verify.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
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

entity Calibration_verify is
  generic (
    N : natural := 16;  --Number of Bits of the sine wave (precision)
    dat_len_avl : natural := 32
    );
    port (
      reset_n        : out  std_ulogic; -- asynchronous reset
      clk            : out  std_ulogic; -- clock
      square_freq    : out  std_ulogic; -- asynchronous reset, active low

      avs_address   : out  std_logic_vector(1 downto 0);
      avs_write     : out std_logic;
      avs_writedata : out std_logic_vector(dat_len_avl-1 downto 0);
      avs_read      : out  std_logic;
      avs_readdata  : in std_logic_vector(dat_len_avl-1 downto 0)
      
    );
end entity Calibration_verify;

architecture stimuli_and_monitor of Calibration_verify is
  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ
  constant c_cycle_time_rect  : time := 1.818512457 us; --579kHz --1.7301038 us; --578kHz
  --constant c_cycle_time_DACLRCK  : time := 20.83333 us; --48kHz
  signal enable : boolean   := true;
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

    -- rect signal
  p_clk_rect : process
  begin
    square_freq <= '0';
    wait for 2*c_cycle_time;
    while enable loop
      square_freq <= '0';
      wait for c_cycle_time_rect/2;
      square_freq <= '1';
      wait for c_cycle_time_rect/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect;


    p_control : process
  begin
    enable <= true;
    avs_writedata <= (others => '0');
    avs_address <= "00";
    avs_write <= '0';

    --wait until rising_edge(<<Signal .calibration_tb.Volume_generation_pm.freq_meas_1.en_freq : std_ulogic>>);

    wait for 20*c_cycle_time;
    
    avs_writedata <= (dat_len_avl-1 downto 2 => '0') & "00";
    avs_address <= "00";
    avs_write <= '1';
    wait for c_cycle_time;
    avs_write <= '0';
    
    wait until avs_readdata(1) = '0';
    
    --enable <= false;
    wait;
  end process p_control;




end architecture stimuli_and_monitor;