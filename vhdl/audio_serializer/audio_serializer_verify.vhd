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
      clk_24            : out  std_ulogic; -- clock
      Bclk         : out  std_ulogic; -- asynchronous reset, active low
      DACLRCK    : out  std_ulogic -- asynchronous reset, active low
    --  DACLRCK        : out std_logic
    );
end entity Theremin_verify;

architecture stimuli_and_monitor of Theremin_verify is
  constant c_cycle_time       : time := 41.66666666 ns; -- 54MHZ
  constant c_cycle_time_bclk  : time := 83.33333333 ns; --578kHz
  constant enable : boolean   := true;
  signal   count  : natural range 0 to 125;
  signal   enable_DACLRCK : boolean;
begin
  

  -- 24MHz
  p_system_clk : process
  begin
    reset_n <= transport '0', '1' after 2*c_cycle_time;
    while enable loop
      clk_24 <= '0';
      
      wait for c_cycle_time/2;
      clk_24 <= '1';
      
      wait for c_cycle_time/2;
    end loop;
    wait;  -- don't do it again
  end process p_system_clk;

    -- BCLK
  p_clk_rect : process
  begin
    Bclk <= '0';
    enable_DACLRCK <= false;
    wait for 2*c_cycle_time;
    while enable loop
      Bclk <= '0';
      enable_DACLRCK <= true;
      wait for c_cycle_time_bclk/2;
      Bclk <= '1';
      enable_DACLRCK <= false;
      wait for c_cycle_time_bclk/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect;


 p_clk_DACLRCK : process
 begin
   DACLRCK <= '0';
   wait for 2*c_cycle_time;
   while enable loop
     wait until enable_DACLRCK = true;
     if count < 125 then
      count <= count + 1;
     else
       count <= 0;
       DACLRCK <= not DACLRCK;
     end if;
   end loop;
   wait;  -- don't do it again
 end process p_clk_DACLRCK;


end architecture stimuli_and_monitor;