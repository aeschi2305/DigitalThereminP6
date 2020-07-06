-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cic_codec.vhd
-- Author  : andreas.frei@students.fhnw.ch
-----------------------------------------------------
-- Description : Decimation CIC-Filter
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity cic is
	generic (
	 Bin : natural := 16;	--Number of Bits of the sine wave (precision)
   Bout : natural := 22;
   M : natural := 
	);
  	port (
  	 reset_n  	    : in  std_ulogic; -- asynchronous reset
     clk      	    : in  std_ulogic; -- clock
     mixer_out 	    : in signed(Bin-1 downto 0);				--Input signal
     -- Streaming Source
     cic_out      : out std_logic_vector(Bout-1 downto 0);	--Output signal

     enable : out boolean
  );
end entity cic;

architecture rtl of cic is
  
  -- Internal signals:
  signal integrator_reg       : signed(Bout-1 downto 0);
  signal integrator_cmb       : signed(Bout-1 downto 0);
  signal comb_in_reg          : signed(Bout-1 downto 0);
  signal comb_old_reg         : signed(Bout-1 downto 0);
  signal comb_reg             : signed(Bout-1 downto 0);
  signal comb_cmb             : signed(Bout-1 downto 0);
  signal en_comb              : boolean := false;
  signal audio_cmb            : std_logic_vector(Bout-1 downto 0);
  signal audio_reg            : std_logic_vector(Bout-1 downto 0);
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
    elsif rising_edge(clk) then
      integrator_reg <= integrator_cmb; 
    end if;
  end process p_integrator_reg;

  ------------------------------------------------------------------------------
  -- Integrator Combinatorial Process
  -- adds up the input over time
  -----------------------------------------------------------------------------
  p_integrator_cmb : process (all)
  begin
    integrator_cmb <= integrator_reg + resize(mixer_out,integrator_reg'length);
  end process p_integrator_cmb;

  ------------------------------------------------------------------------------
  -- Comb Registerd Process 
  -- Also handles the communication with the STEAMING SOURCE INTERFACE
  ------------------------------------------------------------------------------
  p_comb_reg : process (reset_n, clk)
  begin
    if reset_n = '0' then
      comb_reg <= (others => '0');
      comb_in_reg <= (others =>'0');
      comb_old_reg <= (others => '0');
      en_comb <= false;
    elsif rising_edge(clk) then
        if count = R then 
          en_comb <= true;
          comb_reg <= comb_cmb;
          comb_old_reg <= comb_in_reg;
        else
          en_comb <= false;
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
  comb_cmb <= integrator_reg - comb_old_reg;
  end process p_comb_cmb;

  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  cic_out <= comb_reg ;

end rtl;