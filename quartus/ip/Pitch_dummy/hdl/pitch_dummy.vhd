-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : freq_mes.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Frequency measurement 
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
entity pitch_dummy is
    generic (
     dat_len_avl  : natural := 31;  --data length
     data_freq    : std_logic_vector(31 downto 0) := (31 downto 16 => '0') &"1111101000000000";
     delay_thres  : std_logic_vector(31 downto 0) := (31 downto 2 => '0') &"11";
     data_freq1   : std_logic_vector(31 downto 0) := (31 downto 16 => '0') &"0111110100000000"
    );
  port(
    rsi_reset_n       : in std_logic;
    csi_clk           : in std_logic;
    -- Slave Port
    avs_sP_address   : in std_logic_vector(1 downto 0);
    avs_sP_readdata  : out std_logic_vector(dat_len_avl downto 0);
    avs_sP_write     : in std_logic;
    avs_sP_writedata : in std_logic_vector(dat_len_avl downto 0);

    -- Led
    coe_led_delay         : out std_logic;
    coe_led_gli         : out std_logic
  );
end entity pitch_dummy;

architecture rtl of pitch_dummy is
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  --type t_reg is array(integer range <>) of std_logic_vector(31 downto 0);
  --type t_digit is array(integer range <>) of std_logic_vector(6 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  --signal regs    : t_reg(0 to 2);
  --signal per_cnt  : unsigned(N-1 downto 0);
  --signal freq     : unsigned(N+Qprec-1 downto 0);
  --signal en_freq  : boolean;
  --signal en_meas  : boolean;

  ---------------------------------------------------------------------------
  -- Register declarations         
  ---------------------------------------------------------------------------
  constant max_count     : natural := 50000000;
  constant delay_ms      : natural := 20;
  signal enable          : boolean;
  signal cntrl_reg       : std_logic_vector(dat_len_avl downto 0);
  signal freq_data_reg   : std_logic_vector(dat_len_avl downto 0);
  signal delay_data_reg       : std_logic_vector(dat_len_avl downto 0);
  signal count_reg       : integer range 0 to max_count;
  signal count_cmb       : integer range 0 to max_count+1;
  signal led_delay             : std_logic;
  signal led_gli             : std_logic;

begin
------------------------------------------------------------------------------
-- Registerd Process
------------------------------------------------------------------------------
 -- 1. Avalon R/W Register
 p_wr : process(csi_clk, rsi_reset_n)
 begin
   if rsi_reset_n = '0' then
     count_reg <= 0;
     cntrl_reg <= (others => '0');
     delay_data_reg <= (others => '0');
   elsif rising_edge(csi_clk) then
     if avs_sP_write = '1' then
       case avs_sP_address is
         when "00" => cntrl_reg <= avs_sP_writedata;
         when "10" => delay_data_reg <= avs_sP_writedata;
         when others => cntrl_reg <= cntrl_reg;
       end case;
     elsif(cntrl_reg(0) = '1') then
        count_reg <= count_cmb;
        if(count_reg = max_count) then
            cntrl_reg(0) <= '0';
            count_reg <= 0;
        end if;
     end if;
   end if;
 end process p_wr;

 p_rd : process(all)
 begin
    case avs_sP_address is
      when "00" => avs_sP_readdata <= cntrl_reg;
      when "01" => avs_sP_readdata <= freq_data_reg;
      when "10" => avs_sP_readdata <= delay_data_reg;
      when others => avs_sP_readdata <= (others => '0');
    end case;
 end process p_rd;

 p_dummy_reg : process(csi_clk, rsi_reset_n)
 begin
   if rsi_reset_n = '0' then
     freq_data_reg <= (others => '0');
     led_delay <= '0';
     led_gli <= '0';
   elsif rising_edge(csi_clk) then
      
      if(enable = true) then
        freq_data_reg <= data_freq;
        enable <= false;
      else
        freq_data_reg <= data_freq1;
        enable <= true;
      end if;
      if(delay_data_reg >= delay_thres) then
          led_delay <= '1';
      else
          led_delay <= '0';
      end if;
      led_gli <= cntrl_reg(1);
      end if;
 end process p_dummy_reg;

 p_dummy_cmb : process(all)
 begin
    count_cmb <= count_reg +1;
 end process p_dummy_cmb;

 coe_led_delay <= led_delay;
 coe_led_gli <= led_gli;


end rtl;