-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cic.vhd
-- Author  : dennis.aeschbacher.fhnw.ch
-----------------------------------------------------
-- Description : single Decimation CIC-Filter 
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity cic_calc is
	generic (
	 Bin : natural := 16;	--Number of Bits of the sine wave (precision)
   Bout : natural := 22;
   M : natural := 2;
   R : natural := 8
	);
  	port (
  	 reset_n  	    : in  std_ulogic; -- asynchronous reset
     clk      	    : in  std_ulogic; -- clock
     cic_in 	    : in signed(Bin-1 downto 0);				--Input signal
     -- Streaming Source
     cic_out      : out signed(Bout-1 downto 0);	--Output signal

     enable_out : out boolean;  --enables the output
     enable_in  : in boolean    --enables the input
  );
end entity cic_calc;

architecture rtl of cic_calc is
  
  -- Internal signals:
  type stages is array (0 to M-1) of signed(Bout-1 downto 0);
  signal integrator_reg       : signed(Bout-1 downto 0);
  signal integrator_cmb       : stages;
  signal integrator_old_reg   : stages;
  signal integrator_old_cmb   : stages;
  --signal comb_in_reg          : stages;
  signal comb_old_reg         : stages;
  signal comb_old_cmb         : stages;
  signal comb_reg             : signed(Bout-1 downto 0);
  signal comb_cmb             : stages;
  signal en_comb              : boolean := false;
  signal count_reg                : integer range 0 to R;
  signal count_cmb                : integer range 0 to R+1;

begin
  ------------------------------------------------------------------------------
  -- Integrator Registerd Process 
  ------------------------------------------------------------------------------
  p_integrator_reg : process (reset_n, clk)
  begin
    if reset_n = '0' then
      integrator_reg <= (others => '0');
      l_stages1 : for ii in 0 to M-1 loop
          integrator_old_reg(ii) <= (others => '0'); 
      end loop l_stages1;
    elsif rising_edge(clk) then
      if enable_in = true then
       integrator_reg <= integrator_cmb(M-1); 
       l_stages2 : for ii in 0 to M-1 loop
          integrator_old_reg(ii) <= integrator_old_cmb(ii); 
       end loop l_stages2;
      end if;
    end if;
  end process p_integrator_reg;

  ------------------------------------------------------------------------------
  -- Integrator Combinatorial Process
  -- adds up the input over time with the previous result
  -----------------------------------------------------------------------------
  p_integrator_cmb : process (all)
  begin
    integrator_cmb(0) <= integrator_old_reg(0) + resize(cic_in,Bout);
    integrator_old_cmb(0) <= integrator_cmb(0);
    l_stages3 : for ii in 1 to M-1 loop
          integrator_cmb(ii) <= integrator_cmb(ii-1) + integrator_old_reg(ii); 
          integrator_old_cmb(ii) <= integrator_cmb(ii);
    end loop l_stages3;
  end process p_integrator_cmb;

  ------------------------------------------------------------------------------
  -- Comb Registerd Process 
  ------------------------------------------------------------------------------
  p_comb_reg : process (reset_n, clk)
  begin
    if reset_n = '0' then
      comb_reg <= (others => '0');
      l_stages4 : for ii in 0 to M-1 loop
        comb_old_reg(ii) <= (others => '0');
      end loop l_stages4;
      count_reg <= 0;
      en_comb <= false;
    elsif rising_edge(clk) then
        en_comb <= false;
        if count_reg = R-1 and enable_in = true then 
          en_comb <= true;
          count_reg <= 0;
          comb_reg <= comb_cmb(M-1); 
          l_stages5 : for ii in 0 to M-1 loop
            comb_old_reg(ii) <= comb_old_cmb(ii); 
          end loop l_stages5;
        elsif enable_in = true then
          count_reg <= count_cmb;
        end if;
    end if;
  end process p_comb_reg;
  ------------------------------------------------------------------------------
  -- Comb Combinatorial Process
  -- subtracts the old input value from the new
  ------------------------------------------------------------------------------
  p_comb_cmb : process (all)
  begin
    count_cmb <= count_reg + 1;


    comb_cmb(0) <= integrator_reg - comb_old_reg(0);
    l_stages6 : for ii in 1 to M-1 loop
          comb_cmb(ii) <= comb_cmb(ii-1) - comb_old_reg(ii); 
    end loop l_stages6;
    comb_old_cmb(0) <= integrator_reg;
    l_stages7 : for ii in 1 to M-1 loop
          comb_old_cmb(ii) <= comb_cmb(ii-1); 
    end loop l_stages7;
  end process p_comb_cmb;

  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  cic_out <= comb_reg ;
  enable_out <= en_comb;

end rtl;