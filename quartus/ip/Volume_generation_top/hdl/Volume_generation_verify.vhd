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
      reset_n        : out  std_ulogic; -- asynchronous reset
      clk            : out  std_ulogic; -- clock
          -- Avalon Slave Port
      avs_sTG_write     : out std_logic;
      avs_sTG_address   : out std_logic_vector(1 downto 0);
      avs_sTG_writedata : out std_logic_vector(dat_len_avl-1 downto 0);
      avs_sTG_readdata  : in std_logic_vector(dat_len_avl-1 downto 0);

          -- Avalon conduit Interfaces
      coe_square_freq   : out std_logic;
      coe_freq_up_down  : out std_logic_vector(1 downto 0)

    );
end entity Theremin_verify;

architecture stimuli_and_monitor of Theremin_verify is
  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ
  --constant c_cycle_time_DACLRCK  : time := 20.83333 us; --48kHz
  constant enable : boolean   := true;
  type t_time is array(integer range 0 to 10) of time range 1.727115717  us to 1.731901628 us;

  constant c_cycle_time_rect  : t_time := (1.731901628 us, --577400
                                          1.731901628 us,
                                          1.730702665 us, --577800
                                          1.730702665 us,
                                          1.729505361 us, --578200
                                          1.729505361 us,
                                          1.728309713 us, --578600
                                          1.728309713 us,
                                          1.727115717 us, --579000
                                          1.727115717 us,
                                          1.727115717 us);
  signal cnt : integer range 0 to 10;
  signal square_freq : std_ulogic;
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
      wait for c_cycle_time_rect(cnt)/2;
      square_freq <= '1';
      wait for c_cycle_time_rect(cnt)/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect;
  coe_square_freq <= square_freq;

  p_vol : process
  begin
      avs_sTG_write <= '0';
      avs_sTG_address <= "00";
      avs_sTG_writedata <= (others => '0');
    wait for 2*c_cycle_time;
    avs_sTG_write <= '1';
    avs_sTG_address <= "10";
    avs_sTG_writedata <= (31 downto 4 => '0') & "1000";
    wait for 2*c_cycle_time;

    while enable loop
      avs_sTG_write <= '0';
      wait until rising_edge(<<Signal .volume_tb.Volume_generation_pm.freq_meas_1.goldschmid_1.done : std_ulogic>>) ;
      if cnt >= 10 then
       cnt <= 10;
      else
        cnt <= cnt +1; 
        --avs_sTG_writedata <= std_logic_vector(to_unsigned(cnt,avs_sTG_writedata'length));
      end if;
    end loop;
    wait;  -- don't do it again
  end process p_vol;


end architecture stimuli_and_monitor;