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
entity count_freq_pitch is
    generic (
     N : natural := 12;  --Number of Bits of the frequency value
     sine_N : natural:= 24;  --Number of Bits of the input sine wave
     max_per : natural := 12000;  --maximum period count value
     min_per : natural := 100     --minimum period count value
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;

    filt_in     : in signed(sine_N-1 downto 0); 
    per_cnt      : out unsigned(N-1 downto 0); 
    enable_in		: in std_ulogic;
    enable_out  : out std_ulogic;
    freq_meas    : out std_ulogic
  );
end entity count_freq_pitch;

architecture rtl of count_freq_pitch is
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------

  type t_reg_input is array(integer range <>) of signed(sine_N-1 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------

  constant ZERO :signed(sine_N-1 downto 0) := (others => '0');
  constant sine_in_length : natural := 2;
  signal sine_in_reg : t_reg_input(sine_in_length-1 downto 0);
  signal threas_val_1 : signed(sine_N-1 downto 0);
  signal threas_val_2 : signed(sine_N-1 downto 0);
  signal count_reg : integer range 0 to max_per;
  signal count_cmb : integer range 0 to max_per+1;
  signal per_reg : integer range 0 to max_per;
  signal threas : std_ulogic;
  signal meas_en : std_ulogic;
  signal en_out : std_ulogic;

begin

  ------------------------------------------------------------------------------
  -- registered process
  ------------------------------------------------------------------------------

 p_meas_reg : process(clk, reset_n)
 begin
   if reset_n = '0' then
     sine_in_reg <= (others => (others => '0'));
     meas_en <= '1';
     count_reg <= 0;
     freq_meas <= '0';
     threas_val_1 <= (others => '0');
     threas_val_2 <= (others => '0');
     threas <= '0';
   elsif rising_edge(clk) then
     if enable_in = '1' then
        sine_in_reg(0) <= filt_in;
        sine_in_reg(1) <= sine_in_reg(0);
        if sine_in_reg(0) < threas_val_1 then
          threas_val_1 <= sine_in_reg(0);
        end if;
        if filt_in <  threas_val_2 then
          threas <= '1';
        end if;  
        en_out <= '0';
        if threas = '1' and (sine_in_reg(1) < ZERO) and (sine_in_reg(0) >= ZERO) then
          threas_val_2 <= '1' & threas_val_1(sine_N-1 downto 1);
          threas_val_1 <= (others => '0');
          threas <= '0';
          freq_meas <= not freq_meas;
        	if count_reg < min_per then
        		per_reg <= min_per;
          else
            per_reg <= count_reg;
        	end if;
          en_out <= '1';
          count_reg <= 0;
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

  per_cnt <= to_unsigned(per_reg,per_cnt'length);
  enable_out <= en_out;
 
end rtl;
