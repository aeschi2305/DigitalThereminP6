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

entity goldschmidt_tb is
end entity goldschmidt_tb;

architecture struct of goldschmidt_tb is
	
	constant N       : natural := 21; 
	constant Qda 	 : natural := 0;
	constant Qprec   : natural := 5;
	constant iter 	 : natural := 100;

	-- Internal signal declarations:
	signal clk       : std_ulogic;
	signal reset_n     : std_ulogic;
	signal init 	 : std_ulogic;
	signal start : std_ulogic;
	signal num : unsigned(N-1 downto 0);
	signal den : unsigned(N-1 downto 0);
	signal quo : unsigned(N+Qprec-1 downto 0);
	signal done : std_ulogic;


	
	-- Component Declarations
	component goldschmidt is
	  generic (
    	N : natural := 10; --Number of numerator and denominator Bits (precision)
    	Qda : natural := 10;  --Number for more precision
    	Qprec : natural := 10; --Number of bits after the decimal point
    	iter : natural := 30  --Number of Iterations
	  );
	  port(
	    reset_n : in std_ulogic;
	    clk : in std_ulogic;
	    init : in std_ulogic;
	    start : in std_ulogic;
	    num : in unsigned(N-1 downto 0);
	    den : in unsigned(N-1 downto 0);
	    quo : out unsigned(N+Qprec-1 downto 0);
	    done : out std_ulogic
	  );
	end component goldschmidt;
	
	component goldschmidt_verify is
		generic (
    		N : natural := 10; --Number of Bits (precision)
    		Qprec : natural := 10
  		);
		port (
			clk       : out std_ulogic;
			reset_n     : out std_ulogic;
	    	init : out std_ulogic;
	    	start : out std_ulogic;
			key1 	  : in  std_ulogic;
			key2	  : in  std_ulogic;
			key3	  : in  std_ulogic;
	    	num : out unsigned(N-1 downto 0);
	    	den : out unsigned(N-1 downto 0);
	    	quo : in unsigned(N+Qprec-1 downto 0);
	    	done : in std_ulogic
		);
	end component goldschmidt_verify;


begin
	
	-- Instance port mappings.
	goldschmidt_pm : entity work.goldschmidt
		generic map (
			N => N,
			Qda => Qda,
			Qprec => Qprec,
			iter => iter
		)
		port map (
			clk       => clk,
			reset_n     => reset_n,
			init => init,
			start => start,
			num => num,
			den => den,
			quo => quo,
			done => done
		); 

	verify_pm : entity work.goldschmidt_verify
	    generic map (
			N => N,
			Qprec => Qprec
		)
		port map (
			clk       => clk,
			reset_n     => reset_n,
			init => init,
			start => start,
			num => num,
			den => den,
			quo => quo,
			done => done
		); 
	
end architecture struct;