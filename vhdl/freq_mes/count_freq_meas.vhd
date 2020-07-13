-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : freq_mes.vhd
-- Author  : 
-----------------------------------------------------
-- Description : Frequency measurement through counting
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
entity count_freq_meas is
    generic (
     N : natural := 12;  --Number of Bits of the frequency value
     sine_N := 24;  --Number of Bits of the input sine wave
     max_per := 12000;  --maximum period count value
     min_per := 500     --minimum period count value
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;

    audio_out     : in std_logic_vector(sine_N-1 downto 0); 
    per_cnt      : out unsigned(N-1 downto 0); 
    enable		: in boolean
  );
end entity count_freq_meas;

architecture rtl of count_freq_meas is
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------

  type t_reg_input is array(integer range <>) of signed(sine_N-1 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------

  signal sine_in_reg : t_reg_input(1 downto 0);
  signal count_reg : integer range 0 to max_per;
  signal count_cmb : integer range 0 to max_per+1;
  signal meas_en : boolean;
  signal enable_out : boolean;

begin

  ------------------------------------------------------------------------------
  -- registered process
  ------------------------------------------------------------------------------

 p_meas_reg : process(clk, reset_n)
 begin
   if reset_n = '0' then
     freq <= others => '0');
     meas_en <= true;
     count <= 0;
   elsif rising_edge(clk) then
     if enable = true then
        sine_in_reg = sine_in_reg(0) & audio_out;
        enable_out <= false;
        if sine_in_reg(1) > (others => '0') && sine_in_reg(0) < (others => '0') then
          if meas_en = true then
            count_reg <= 0;
            meas_en <= false;
          else
          	if count_reg < min_per then
          		count_reg <= min_per;
          	end if;
            meas_en <= true;
            enable_out <= true;
          end if;
        else
          if count_reg = max_per then
            count_reg <= max_per;
          else
            count_reg <= count_cmb;
          end if;
        end if;
     end if;
   end if;
 end process p_meas_reg;


  ------------------------------------------------------------------------------
  -- Combinatorial Process
  ------------------------------------------------------------------------------

 p_meas_cmb : process(all)
	begin
	   count_cmb <= count_reg + 1;
	end process p_meas_cmb;
  

  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------

  per_cnt <= count_reg;
 
end rtl;
