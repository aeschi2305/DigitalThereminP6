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
	 N : natural := 16	--Number of Bits of the sine wave (precision)
	);
  	port (
  	 reset_n  	    : in  std_ulogic; -- asynchronous reset
     clk      	    : in  std_ulogic; -- clock
     mixer_out 	    : in signed(N-1 downto 0);				--Input signal
     -- Streaming Source
     audio_out      : out std_logic_vector(23 downto 0);	--Output signal
     valid_R        : out std_logic;	--Control Signals
     valid_L        : out std_logic;  --Control Signals
     ready_R        : in std_logic;		
     ready_L        : in std_logic;

     DACLRC 		: in std_logic
  );
end entity cic;

architecture rtl of cic is
  constant rc_factor : natural := 1000; --Rate Change Factor
  -- Internal signals:
  signal integrator_reg       : signed(N+9 downto 0);
  signal integrator_cmb       : signed(N+9 downto 0);
  signal comb_in_reg          : signed(N+9 downto 0);
  signal comb_old_reg         : signed(N+9 downto 0);
  signal comb_reg             : signed(N+9 downto 0);
  signal comb_cmb             : signed(N+9 downto 0);
  signal en_comb              : boolean := false;
  signal audio_cmb            : std_logic_vector(23 downto 0);
  signal audio_reg            : std_logic_vector(23 downto 0);
  signal DACLRC_cmb			  : std_logic_vector(2 downto 0);
  signal DACLRC_reg			  : std_logic_vector(2 downto 0);
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
      audio_reg <= (others => '0');
      DACLRC_reg <= (others => '0');
      en_comb <= false;
    elsif rising_edge(clk) then
    	DACLRC_reg <= DACLRC_cmb;
        if DACLRC_reg(2) = '0' and DACLRC_reg(1) = '1' then 
          en_comb <= true;
          audio_reg <= audio_cmb;
        else
          en_comb <= false;
        end if;
        if en_comb = true then  
          comb_reg <= comb_cmb;
          comb_in_reg <= integrator_reg;
          comb_old_reg <= comb_in_reg;
        end if;
        
        
    end if;
  end process p_comb_reg;
  ------------------------------------------------------------------------------
  -- Comb Combinatorial Process
  -- subtracts the old input value from the new
  ------------------------------------------------------------------------------
  p_comb_cmb : process (all)
  variable audio_tmp : std_logic_vector(23 downto 0);
  begin
    comb_cmb <= comb_in_reg - comb_old_reg;
    --audio_cmb <= std_logic_vector(comb_reg); with further signal processing
    --without further siganl processing
    audio_tmp := std_logic_vector(comb_reg(25 downto 2) );
    audio_tmp(audio_tmp'high) := not audio_tmp(audio_tmp'high);
    audio_cmb <= audio_tmp;

    DACLRC_cmb <= DACLRC_reg(1 downto 0) & DACLRC;
  end process p_comb_cmb;


  ------------------------------------------------------------------------------
  -- ST Process Process
  -- Handles the communication with the Streaming Interface Right Channel
  ------------------------------------------------------------------------------


  p_st_r : process (reset_n, clk)
  
  begin
  if reset_n = '0' then
        valid_R <= '0';
  elsif rising_edge(clk) then
        if en_comb = true then
          valid_R <= '1';
        elsif ready_R = '1' then
          valid_R <= '0';
        end if;
  end if;
  end process p_st_r;

   ------------------------------------------------------------------------------
  -- ST Process Process
  -- Handles the communication with the Streaming Interface Left Channel
  ------------------------------------------------------------------------------


  p_st_l : process (reset_n, clk)
  
  begin
  if reset_n = '0' then
        valid_L <= '0';
  elsif rising_edge(clk) then
        if en_comb = true then
          valid_L <= '1';
        elsif ready_L = '1' then
          valid_L <= '0';
        end if;
  end if;
  end process p_st_l;

  ------------------------------------------------------------------------------
  -- Output Assignments
  ------------------------------------------------------------------------------
  audio_out <= audio_reg ;

end rtl;