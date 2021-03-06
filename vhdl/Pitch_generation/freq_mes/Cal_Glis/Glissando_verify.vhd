-----------------------------------------------------
-- Project : Digital Calibration
-----------------------------------------------------
-- File    : Glissando_verify.vhd
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

entity Glissando_verify is
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
end entity Glissando_verify;

architecture stimuli_and_monitor of Glissando_verify is

  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ

  type t_c_cycle is array(integer range 0 to 1) of time range 1.724137931 us to 1.730103806 us;

  constant c_cycle_time_rect : t_c_cycle := (1.730103806 us,
                                            1.724286576 us);

  --constant c_cycle_time_rect_1  : time := 1.754385965 us; --579kHz 
  --constant c_cycle_time_rect_2  : time := 1.72702921 us; --579.029kHz 
  --constant c_cycle_time_rect_2  : time := 1.727414061 us; --578.9kHz
  --constant c_cycle_time_rect_2  : time := 1.72681747 us; --578.9kHz
  signal enable : boolean   := true;
  signal enable_toggle : boolean   := true;
  signal count : integer range 0 to 11;

  signal index : integer range 0 to 1;
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
      wait for c_cycle_time_rect(index)/2;
      square_freq <= '1';
      wait for c_cycle_time_rect(index)/2;
    end loop;
    wait;  -- don't do it again
  end process p_clk_rect;


    p_control : process
  begin
    count <= 0;
    enable <= true;
    avs_writedata <= (others => '0');
    avs_address <= "00";
    avs_write <= '0';
    index <= 0;
    --enable_toggle <= false;


    wait for 20*c_cycle_time;

    avs_writedata <= (dat_len_avl-1 downto 2 => '0') & "00";
    avs_address <= "10";
    avs_write <= '1';
    wait for c_cycle_time;
    avs_write <= '0';

    wait for c_cycle_time;

    avs_writedata <= (dat_len_avl-1 downto 3 => '0') & "001";
    avs_address <= "00";
    avs_write <= '1';
    wait for c_cycle_time;
    avs_write <= '0';


    
    wait until rising_edge(<<Signal .glissando_tb.pitch_generation_pm.freq_meas_pitch_1.CalGlis_1.approx_done : std_ulogic>>);
    wait for 2 ms;

    --index <= 1;


   
    --while count /= 11 loop
    --  wait until falling_edge(<<Signal .glissando_tb.pitch_generation_pm.freq_meas_pitch_1.freq_meas : std_ulogic>>);
    --  if count = 11 then
    --    count <= 11;
    --  else
    --    count <= count + 1;
    --  end if;
    --end loop;

    --wait until rising_edge(<<Signal .glissando_tb.pitch_generation_pm.freq_meas_1.CalGlis_1.approx_done : std_ulogic>>);
    --wait until rising_edge(<<Signal .glissando_tb.pitch_generation_pm.freq_meas_1.freq_meas : std_ulogic>>);
    --wait for 100*c_cycle_time;

    --enable <= false;

    wait;
  end process p_control;




end architecture stimuli_and_monitor;