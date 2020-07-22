library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity goldschmidt_verify is
	generic (
    	N : natural := 10; --Number of Bits (precision)
    	Qprec : natural := 10
  	);
	port (
		clk       : out std_ulogic;
		reset_n     : out std_ulogic;
    	init : out std_ulogic;
    	start : out std_ulogic;
    	num : out unsigned(N-1 downto 0);
    	den : out unsigned(N-1 downto 0);
    	quo : in unsigned(N+Qprec-1 downto 0);
    	done : in std_ulogic
	);
	
	-- Declarations
	
end entity goldschmidt_verify;

architecture sim of goldschmidt_verify is
	constant c_clk_cycle : time := 20 ns;
	constant c_delay     : time := 2 ns;
	
	signal sim_end       : boolean;
	
	signal cnt_value : std_ulogic_vector(N-1 downto 0);
	
begin

	reset_n <= transport '0', '1' after 3*c_clk_cycle;
	

	p_clock_reset : process
	begin

		l_clk : while (not sim_end) loop
			clk <= transport '0', '1' after c_clk_cycle/2;
			wait for c_clk_cycle;
		end loop l_clk;
		
		--report "Process p_clock_reset stopped";
		clk <= '0';
		wait;
	end process p_clock_reset;
	
	p_control : process
	begin
		sim_end <= false;
		
		init <= '0';
		start <= '0';
		
		num <= to_unsigned(1200000,N);
		den <= to_unsigned(765,N);
		wait for 5*c_clk_cycle;
		report "Solution is 1568.6274";
		
		
		init <= '1';
		wait for 1*c_clk_cycle;
		init <= '0';
		wait for 1*c_clk_cycle;

		
		start <= '1';
		wait until done = '1';
		start <= '0';
		wait for 2*c_clk_cycle;

		
		num <= to_unsigned(1200000,N);
		den <= to_unsigned(11865,N);
		wait for 5*c_clk_cycle;
		report "Solution is 101.1378";
		
		
		init <= '1';
		wait for 1*c_clk_cycle;
		init <= '0';
		wait for 1*c_clk_cycle;

		start <= '1';
		wait until done = '1';
		start <= '0';
		wait for 2*c_clk_cycle;

		num <= to_unsigned(7,N);
		den <= to_unsigned(3,N);
		wait for 5*c_clk_cycle;
		report "Solution is 2.33333";

		
		
		sim_end <= true;
		wait;
	end process p_control;
	
end architecture sim;
	 