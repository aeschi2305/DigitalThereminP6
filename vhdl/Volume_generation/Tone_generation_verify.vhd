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
    N : natural := 16  --Number of Bits of the sine wave (precision)
    );
    port (
      reset_n        : out  std_ulogic; -- asynchronous reset
      clk            : out  std_ulogic; -- clock
      square_freq    : out  std_ulogic -- asynchronous reset, active low
    --  DACLRCK        : out std_logic
    );
end entity Theremin_verify;

architecture stimuli_and_monitor of Theremin_verify is
  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ
  constant c_cycle_time_rect  : time := 1.727711 us; --579kHz --1.7301038 us; --578kHz
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

    -- 48kHz
 -- p_clk_DACLRCK : process
 -- begin
 --   DACLRCK <= '0';
 --   wait for 2*c_cycle_time;
 --   while enable loop
 --     DACLRCK <= '0';
 --     wait for c_cycle_time_DACLRCK/2;
 --     DACLRCK <= '1';
 --     wait for c_cycle_time_DACLRCK/2;
 --   end loop;
 --   wait;  -- don't do it again
 -- end process p_clk_DACLRCK;


end architecture stimuli_and_monitor;