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
     sine_N : natural:= 24;  --Number of Bits of the input sine wave
     max_per : natural := 12000;  --maximum period count value
     min_per : natural := 500     --minimum period count value
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;

    filt_in     : in signed(sine_N-1 downto 0); 
    per_cnt      : out unsigned(N-1 downto 0); 
    enable_in		: in boolean;
    enable_out  : out boolean
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

  constant ZERO :signed(sine_N-1 downto 0) := (others => '0');
  constant sine_in_length : natural := 6;
  signal sine_in_reg : t_reg_input(sine_in_length-1 downto 0);
  signal count_reg : integer range 0 to max_per;
  signal count_cmb : integer range 0 to max_per+1;
  signal meas_en : boolean;
  signal en_out : boolean;

begin

  ------------------------------------------------------------------------------
  -- registered process
  ------------------------------------------------------------------------------

 p_meas_reg : process(clk, reset_n)
 begin
   if reset_n = '0' then
     sine_in_reg <= (others => (others => '0'));
     meas_en <= true;
     count_reg <= 0;
   elsif rising_edge(clk) then
     if enable_in = true then
        sine_in_reg(0) <= filt_in;
        l_buf : for ii in 1 to sine_in_length-1 loop
          sine_in_reg(ii) <= sine_in_reg(ii-1);
        end loop l_buf;        
        en_out <= false;
        if ((sine_in_reg(5) < ZERO) and (sine_in_reg(4) < ZERO) and (sine_in_reg(3) < ZERO) and (sine_in_reg(2) < ZERO) and (sine_in_reg(1) < ZERO) and (sine_in_reg(0) >= ZERO)) then
          if meas_en = true then
            count_reg <= 0;
            meas_en <= false;
          else
          	if count_reg < min_per then
          		count_reg <= min_per;
            else
              meas_en <= true;
              en_out <= true;
          	end if;
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

  per_cnt <= to_unsigned(count_reg,per_cnt'length);
  enable_out <= en_out;
 
end rtl;
