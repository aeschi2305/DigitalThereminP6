library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity freq_meas_verify is
  generic (
    sine_N : natural := 18  --Number of Bits of the sine wave (precision)
    );
    port (
      reset_n        : out  std_ulogic; -- asynchronous reset
      clk            : out  std_ulogic; -- clock
      square_freq    : out  signed(sine_N-1 downto 0); -- asynchronous reset, active low
      enable_meas    : out  boolean
    );
end entity freq_meas_verify;

architecture stimuli_and_monitor of freq_meas_verify is
  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ
  constant c_cycle_time_rect  : time := 689.655 us; -- 1450Hz --511.771 us; --1954Hz --9.09090 ms; --110Hz  --633.312 us; --1579Hz    
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

    -- enable
  p_enable : process
  begin
    wait for 2*c_cycle_time;
    while enable loop
      enable_meas <= true;
      wait for c_cycle_time;
      enable_meas <= false;
      wait for c_cycle_time*44;
    end loop;
    wait;  -- don't do it again
  end process p_enable;

    -- 1kHz
  p_clk_rect : process
  begin
    square_freq <= (others => '0');
    wait for 2*c_cycle_time;
    while enable loop
      square_freq <= '1' & (sine_N-2 downto 0 => '0');
      wait for c_cycle_time_rect/2;
      square_freq <= '0' & (sine_N-2 downto 0 => '1');
      wait for c_cycle_time_rect/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect;


end architecture stimuli_and_monitor;