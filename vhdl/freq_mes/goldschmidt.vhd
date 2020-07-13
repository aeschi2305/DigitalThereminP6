-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cordic.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Calculates the sine value of a given angle phi in N parallel iterations (no pipelining)
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
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    init : in std_ulogic;
    start : in std_ulogic;
    num : in unsigned(N-1 downto 0);
    den : in unsigned(N-1 downto 0);
    quo : out unsigned(N+Qprec-1 downto 0);
    done : out std_ulogic
  );
end entity goldschmidt;
	
architecture behavioral of goldschmidt is



signal num_cmb : unsigned(3*N+2*Qda downto 0); --50
signal den_cmb : unsigned(2*N+2*Qda+1 downto 0); --41
signal num_reg : unsigned(2*N+Qda-1 downto 0);	--29
signal den_reg : unsigned(N+Qda downto 0); --20
signal quo_reg : unsigned(2*N-1 downto 0); --19
constant TWO : unsigned(N+Qda+1 downto 0) := '1' & (N+Qda downto 0 => '0'); --21
constant ONE : unsigned(N+Qda downto 0) := '0' & (N+Qda-1 downto 0 => '1'); --21

signal enable : boolean;

begin

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
            	num_reg <= (N-1 downto 0 => '0') & num & (Qda-1 downto 0 => '0'); --(N+Qda-1 downto Qda => num, others => '0'); --"0000000000" & num;
            	den_reg <= '0' & den & (Qda-1 downto 0 => '0');--(N+Qda-1 downto Qda => den, others => '0');
            	quo_reg <= (others => '0');
                count_reg <= 0;
            elsif start = '1' then
            	if enable = true then
            		num_reg <= num_cmb(3*N+2*Qda-1 downto N+Qda);  --49 downto 20
            		den_reg <= den_cmb(2*N+2*Qda downto N+Qda);  --40 downto 20
                    count_reg <= count_cmb;
            	else
            		done <= '1';
            		quo_reg	<= num_cmb(3*N+2*Qda-1 downto N+2*Qda);
            	end if;
            end if;
        end if;
    end process p_reg;

    p_cmb_iter : process(all)
        variable F_tmp : unsigned(N+Qda+1 downto 0); 

    begin
        F_tmp := TWO - ('0' & den_reg);
        den_cmb <= den_reg * F_tmp(N+Qda downto 0);
        num_cmb <= num_reg * F_tmp(N+Qda downto 0);
    	if den_reg = ONE then--if count_reg = iter then
    		enable <= false;
    	else 
            
            enable <= true;
    	end if;
    end process p_cmb_iter;

    quo <= quo_reg(2*N-1 downto N-Qprec);

end architecture behavioral;
