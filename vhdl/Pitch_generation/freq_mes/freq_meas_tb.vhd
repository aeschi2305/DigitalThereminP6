-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : goldschmidt_tb.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Testbench for goldschmidt.vhd
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_meas_tb is
end entity freq_meas_tb;

architecture struct of freq_meas_tb is
	
	constant N       : natural := 21; 
	constant Qda 	 : natural := 0;
	constant Qprec   : natural := 5;
	constant iter 	 : natural := 100;

	-- Internal signal declarations:
	signal clk       : std_ulogic;
	signal reset_n     : std_ulogic;
	signal audio_out   : signed(17 downto 0);
	signal meas_enable : boolean;



	-- Component Declarations
	component freq_meas is
	    generic (
	     fsamp  : natural := 1200000;  --sampling frequency of the sine wave to be measured
	     N      : natural := 21; --Number of numerator and denominator bits
	     Qda    : natural := 0;  --Number for more precision
	     Qprec  : natural := 5;  --Number of bits after decimal point of quotient
	     sine_N : natural := 18; --Number of bits of the sine Wave to be measured
	     Coeffs : natural := 37  --Number of FIR Filter Coefficients
	    );
	  port(
	    reset_n       : in std_ulogic;
	    clk           : in std_ulogic;
	    -- Slave Port
	    --sTG_address   : in  std_logic;
	    --sTG_write     : in std_logic;
	    --sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
	    --sTG_read      : in  std_logic;
	    --sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);
	
	    audio_out     : in std_logic_vector(31 downto 0); 
	    freq_diff     : out signed(N-1 downto 0);
	    meas_enable  : in boolean;
	    enable_out    : out boolean
	  );
	end component freq_meas;


	component freq_meas_verify is
	  generic (
	    sine_N : natural := 16  --Number of Bits of the sine wave (precision)
	    );
	    port (
	      reset_n        : out  std_ulogic; -- asynchronous reset
	      clk            : out  std_ulogic; -- clock
	      square_freq    : out  std_ulogic; -- asynchronous reset, active low
	      enable_meas    : out  boolean
	    );
	end component freq_meas_verify;



begin
	
	-- Instance port mappings.
	freq_meas_pm : entity work.freq_meas
	    generic map(
	  	   fsamp  => 1200000,  --sampling frequency of the sine wave to be measured
	  	   N      => 21, --Number of numerator and denominator bits
	  	   Qda    => 0,  --Number for more precision
	  	   Qprec  => 5,  --Number of bits after decimal point of quotient
	  	   sine_N => 18, --Number of bits of the sine Wave to be measured
	  	   Coeffs => 37  --Number of FIR Filter Coefficients
	  	  )
	  	port map(
	  	  reset_n     => reset_n,
	  	  clk         => clk,
	  	  -- Slave Port
	  	  --sTG_address   : in  std_logic;
	  	  --sTG_write     : in std_logic;
	  	  --sTG_writedata : in std_logic_vector(dat_len_avl downto 0);
	  	  --sTG_read      : in  std_logic;
	  	  --sTG_readdata  : out std_logic_vector(dat_len_avl downto 0);
		
	  	  audio_out    => audio_out,
	  	  freq_diff    => open,
	  	  meas_enable  => meas_enable,
	  	  enable_out   => open
	  	);

	verify_pm : entity work.freq_meas_verify
	  generic map(
	    sine_N => 18  --Number of Bits of the sine wave (precision)
	    )
	    port map(
	      reset_n        => reset_n,
	      clk            => clk,
	      square_freq    => audio_out,
	      enable_meas    => meas_enable
	    );
	
end architecture struct;