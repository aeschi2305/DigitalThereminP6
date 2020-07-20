-- altera vhdl_input_version vhdl_2008
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

entity pitch_dummy_verify is
  generic (
    dat_len_avl : natural := 31  --Number of Bits of the sine wave (precision)
    );
    port (
      reset_n          : out  std_ulogic; -- asynchronous reset
      clk              : out  std_ulogic; -- clock
         -- Slave Port
      avs_sP_address   : out std_logic_vector(1 downto 0);
      avs_sP_readdata  : in std_logic_vector(dat_len_avl downto 0);
      avs_sP_write     : out std_logic;
      avs_sP_writedata : out std_logic_vector(dat_len_avl downto 0)
    );
end entity pitch_dummy_verify;

architecture stimuli_and_monitor of pitch_dummy_verify is
  constant c_cycle_time       : time := 18.51851852 ns; -- 54MHZ
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
    wait;
  end process p_system_clk;

    -- Procedure
  p_w_r : process
  begin
    avs_sP_address <= "00";
    avs_sP_writedata <= (others => '0');
    avs_sP_write <= '0';
    wait for 2*c_cycle_time;
    avs_sP_write <= '1';
    avs_sP_address <= "00";
    avs_sP_writedata <= (31 downto 8 => '0') & "10101010";
    wait for 2*c_cycle_time;
    avs_sP_write <= '1';
    avs_sP_address <= "00";
    avs_sP_writedata <= (31 downto 8 => '0') & "11111111";
    wait for 4*c_cycle_time;
    avs_sP_write <= '1';
    avs_sP_address <= "10";
    avs_sP_writedata <= (31 downto 8 => '0') & "11111111";
    wait for 4*c_cycle_time;
    avs_sP_write <= '1';
    avs_sP_address <= "01";
    avs_sP_writedata <= (31 downto 8 => '0') & "11111111";
    wait for 2*c_cycle_time;
    enable <= false;
    wait;
   end process p_w_r;

end architecture stimuli_and_monitor;