-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : Theremin_tb.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Testbench for complete setup excluding codec
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity volume_dummy_tb is
end entity volume_dummy_tb;

architecture struct of volume_dummy_tb is
  
  constant dat_len_avl      : natural := 31; 
  constant data_freq        : std_logic_vector(31 downto 0) := (31 downto 16 => '0') &"1111101000000000";
  constant data_freq1       : std_logic_vector(31 downto 0) := (31 downto 16 => '0') &"0111110100000000";
  -- Internal signal declarations:
  signal clk                : std_ulogic;
  signal reset_n            : std_ulogic;
  signal avs_sP_address     : std_logic;
  signal avs_sP_readdata    : std_logic_vector(dat_len_avl downto 0);
  signal avs_sP_write       : std_logic;
  signal avs_sP_writedata   : std_logic_vector(dat_len_avl downto 0);

  


  
  -- Component Declarations
  component volume_dummy_verify is
  generic (
    dat_len_avl : natural := 31  --Number of Bits of the sine wave (precision)
    );
    port (
      reset_n          : out  std_ulogic; -- asynchronous reset
      clk              : out  std_ulogic; -- clock
         -- Slave Port
      avs_sP_address   : out std_logic;
      avs_sP_readdata  : in std_logic_vector(dat_len_avl downto 0);
      avs_sP_write     : out std_logic;
      avs_sP_writedata : out std_logic_vector(dat_len_avl downto 0)

    );
  end component volume_dummy_verify;
  

component volume_dummy is
    generic (
     dat_len_avl  : natural := 31;  --data length
     data_freq    : std_logic_vector(31 downto 0) := (31 downto 16 => '0') &"1111101000000000";
     data_freq1   : std_logic_vector(31 downto 0) := (31 downto 16 => '0') &"0111110100000000"
    );
  port(
    reset_n       : in std_ulogic;
    clk           : in std_ulogic;
    -- Slave Port
    avs_sP_address   : in std_logic;
    avs_sP_readdata  : out std_logic_vector(dat_len_avl downto 0);
    avs_sP_write     : in std_logic;
    avs_sP_writedata : in std_logic_vector(dat_len_avl downto 0);

    -- Led
    coe_led_vol      : out std_logic
  );
end component volume_dummy;

  
begin
  
  -- Instance port mappings.
  volume_dummy_verify_pm : entity work.pitch_dummy_verify
    generic map (
      dat_len_avl => dat_len_avl
    )
    port map (
      reset_n => reset_n,   
      clk     => clk,
      avs_sP_address  => avs_sP_address,
      avs_sP_readdata => avs_sP_readdata,
      avs_sP_write    => avs_sP_write, 
      avs_sP_writedata=> avs_sP_writedata    
    ); 

  volume_dummy_pm : entity work.pitch_dummy
    generic map(
     dat_len_avl => dat_len_avl,
     data_freq   => data_freq,
     data_freq1  => data_freq1
    )
    port map (
      reset_n => reset_n,   
      clk     => clk,
      avs_sP_address  => avs_sP_address,
      avs_sP_readdata => avs_sP_readdata,
      avs_sP_write    => avs_sP_write, 
      avs_sP_writedata=> avs_sP_writedata,
      coe_led_vol     => open
    ); 

  
  
end architecture struct;