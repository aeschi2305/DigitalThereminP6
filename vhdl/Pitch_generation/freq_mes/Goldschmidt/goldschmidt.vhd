-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : goldschmidt.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : divides the numerator by the denominator iteratively
-----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity goldschmidt is
  generic (
    N : natural := 21; --Number of numerator and denominator Bits (precision)
    Qda : natural := 10;  --Number for more precision
    Qprec : natural := 5 --Number of bits after the decimal point
  );
  port(
    reset_n : in std_ulogic;        --asynchronous reset
    clk : in std_ulogic;            --clock
    init : in std_ulogic;           --signal to initialize the algorithm
    start : in std_ulogic;          --signal to start iterating
    num : in unsigned(N-1 downto 0);            --numerator
    den : in unsigned(N-1 downto 0);            --denominator
    quo : out unsigned(N+Qprec-1 downto 0);     --quotient
    done : out std_ulogic           --signal to signal end of iterations
  );
end entity goldschmidt;
	
architecture behavioral of goldschmidt is



signal num_cmb : unsigned(3*N+2*Qda downto 0); 
signal den_cmb : unsigned(2*N+2*Qda+1 downto 0); 
signal num_reg : unsigned(2*N+Qda-1 downto 0);	
signal den_reg : unsigned(N+Qda downto 0); 
signal quo_reg : unsigned(2*N-1 downto 0); 
constant TWO : unsigned(N+Qda+1 downto 0) := '1' & (N+Qda downto 0 => '0'); 
constant ONE : unsigned(N+Qda downto 0) := '0' & (N+Qda-1 downto 0 => '1'); 

signal enable : boolean;

begin

  ------------------------------------------------------------------------------
  -- Registered Process
  -- handles initialisation and start of iterations
  ------------------------------------------------------------------------------


    p_reg : process(reset_n,clk)
    begin
        if reset_n = '0' then
            num_reg <= (others => '0');
            den_reg <= (others => '0');
            quo_reg <= (others => '0');
            done <= '0';
        elsif rising_edge(clk) then
            done <= '0';
            if init = '1' then
            	num_reg <= (N-1 downto 0 => '0') & num & (Qda-1 downto 0 => '0');
            	den_reg <= '0' & den & (Qda-1 downto 0 => '0');
            	quo_reg <= (others => '0');
            elsif start = '1' and done = '0' then
            	if enable = true then
            		num_reg <= num_cmb(3*N+2*Qda-1 downto N+Qda);  
            		den_reg <= den_cmb(2*N+2*Qda downto N+Qda);  
            	else
            		done <= '1';
            		quo_reg	<= num_cmb(3*N+2*Qda-1 downto N+2*Qda);
            	end if;
            end if;
        end if;
    end process p_reg;

  ------------------------------------------------------------------------------
  -- Combinatorial Process
  -- calculates the iterations of the algorithm and checks if calculation ist done
  ------------------------------------------------------------------------------

    p_cmb_iter : process(all)
        variable F_tmp : unsigned(N+Qda+1 downto 0); 

    begin
        F_tmp := TWO - ('0' & den_reg);
        den_cmb <= den_reg * F_tmp(N+Qda downto 0);
        num_cmb <= num_reg * F_tmp(N+Qda downto 0);
    	if den_reg = ONE then
    		enable <= false;
    	else 
            
            enable <= true;
    	end if;
    end process p_cmb_iter;

  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------

    quo <= quo_reg(2*N-1 downto N-Qprec);

end architecture behavioral;
