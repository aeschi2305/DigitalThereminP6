-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : freq_mes.vhd
-- Author  : 
-----------------------------------------------------
-- Description : Frequency measurement 
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
entity freq_mes is
    generic (
     N : natural := 16;  --Number of Bits of the sine wave (precision)
     dat_len_avl : natural := 31   --Number of Bits of Avalon data w/r
    );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    -- Slave Port
--   sTG_address   : in  std_logic;
--   sTG_write     : in std_logic;
--   sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
--   sTG_read      : in  std_logic;
--   sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);

    audio_out     : in std_logic_vector(23 downto 0); 
    freq_div      : out signed(N-1 downto 0) 
  );
end entity freq_mes;

architecture rtl of freq_mes is
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  type t_reg is array(integer range <>) of std_logic_vector(31 downto 0);
  type t_digit is array(integer range <>) of std_logic_vector(6 downto 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  signal regs           : t_reg(0 to 2);
  signal freq : signed(N-1 downto 0) := (others => '0');

begin
  ------------------------------------------------------------------------------
  -- Registerd Process
  ------------------------------------------------------------------------------
   -- 1. Avalon R/W Register
-- p_avs : process(clk, reset_n)
-- begin
--   if reset_n = '0' then
--     regs <= (others => (others => '0'));
--   elsif rising_edge(clk) then
--     if sTG_write = '1' then
--       case sTG_address is
--         when '0' =>
--           regs(0) <= sTG_writedata;
--         when others =>
--           regs(1) <= sTG_writedata;
--       end case;
--     end if;
--   end if;
-- end process p_avs;

-- with sTG_address select
--   sTG_readdata <= regs(0) when '0',
--   regs(1)                when others; 
  ------------------------------------------------------------------------------
  -- Combinatorial Process
  ------------------------------------------------------------------------------
  
freq_div <= freq;
  
  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
 
end rtl;
