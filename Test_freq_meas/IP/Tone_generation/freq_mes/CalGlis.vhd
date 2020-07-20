-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : CalGlis.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : controls the calibration process and the glissando effect
-----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity goldschmidt is
  generic (
    N : natural := 10; --Number of numerator Bits (precision)
    D : natural := 10; --Number of denominator Bits (precision)
    Qda : natural := 10;  --Number of quotients Bits after the decimal point (precision)
    iter : natural := 30  --Number of Iterations
  );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    init : in std_ulogic;
    start : in std_ulogic;
    num : in unsigned(N-1 downto 0);
    den : in unsigned(D-1 downto 0);
    quo : out unsigned(Q-1 downto 0);
    done : out std_ulogic
  );
end entity goldschmidt;
	
architecture behavioral of goldschmidt is



signal num_cmb : unsigned(N+2*D downto 0); --50
signal den_cmb : unsigned(2*D+1 downto 0); --41

signal num_reg : unsigned(N+D-1 downto 0);	--29
signal den_reg : unsigned(D downto 0); --20
signal quo_reg : unsigned(-1 downto 0); --19
signal count_cmb : natural range 0 to iter + 1;
signal count_reg : natural range 0 to iter;
constant TWO : unsigned(D+1 downto 0) := (D+1 => '1', others => '0'); --21

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
            	num_reg <= (N-1 downto 0 => num, others => '0'); --"0000000000" & num;
            	den_reg <= (D-1 downto 0 => den, others => '0');
            	quo_reg <= (others => '0');
                count_reg <= 0;
            elsif start = '1' then
            	if enable = true then
            		num_reg <= num_cmb(2*N+D downto 0);  --49 downto 20
            		den_reg <= den_cmb(2*N downto 0);  --40 downto 20
                    count_reg <= count_cmb;
            	else
            		done <= '1';
            		quo_reg	<= num_cmb(49 downto 30);
                    count_reg <= 0;
            	end if;
            end if;
        end if;
    end process p_reg;

    p_cmb_iter : process(all)
        variable F_tmp : unsigned(D+Qda+1 downto 0); 

    begin
        F_tmp := TWO - ('0' & den_reg);
        den_cmb <= den_reg * F_tmp(20 downto 0);
        num_cmb <= num_reg * F_tmp(20 downto 0);
    	if count_reg = 20 then
    		enable <= false;
    	else 
            
            enable <= true;
    	end if;
        count_cmb <= count_reg + 1;
    end process p_cmb_iter;

    quo <= quo_reg;

end architecture behavioral;
