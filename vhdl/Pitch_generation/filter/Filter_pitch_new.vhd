-- altera vhdl_input_version vhdl_2008
-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cic_codec.vhd
-- Author  : andreas.frei@students.fhnw.ch
-----------------------------------------------------
-- Description : Decimation CIC-Filter with Streaming Interface
-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity filter_pitch is
	generic (
	 N : natural := 16;	--Number of Bits of the sine wave (precision)
   cic1Bits : natural := 21;
   cic2Bits : natural := 25
	);
  	port (
  	 reset_n  	    : in  std_ulogic; -- asynchronous reset
     clk      	    : in  std_ulogic; -- clock
     mixer_out 	    : in signed(N-1 downto 0);				--Input signal
     -- Streaming Source
     audio_out      : out std_logic_vector(23 downto 0);	--Output signal
     valid          : out std_logic;  --Control Signals
     ready          : in std_logic;

     volume_out     : in unsigned(17 downto 0);
     volume_enable  : in std_logic;

     fir            : out signed(17 downto 0);
     fir_en         : out std_ulogic


  );
end entity filter_pitch;



architecture rtl of filter_pitch is


constant FIRBits : natural := 18;

signal cic1out : signed(cic1Bits-1 downto 0);
signal cic2out : signed(cic2Bits-1 downto 0);
signal FIRout : signed(FIRBits-1 downto 0);
signal enable1 : boolean;
signal enable2 : boolean;
signal enable4 : std_ulogic;

component cic_calc is
  generic (
   Bin : natural := 16; --Number of Bits of the sine wave (precision)
   Bout : natural := 22;
   M : natural := 2;
   R : natural := 8

  );
    port (
     reset_n        : in  std_ulogic; -- asynchronous reset
     clk            : in  std_ulogic; -- clock
     cic_in       : in signed(Bin-1 downto 0);        --Input signal
     -- Streaming Source
     cic_out      : out signed(Bout-1 downto 0);  --Output signal

     enable_out : out boolean;
     enable_in  : in boolean
  );
end component cic_calc;

component fir_filter_pitch is
generic (
    N : natural := 13; --Number of Filter Coefficients
    M : natural := 29; --Number of Input Bits
    O : natural := 27 --Number of Output Bits
);
port (
  clk        : in  std_ulogic;
  reset_n       : in  std_ulogic;
  en_in        : in boolean;                  -- input enable
  en_out       : out std_ulogic;                 -- output enable
  en_out_dec   : out std_ulogic;                 -- output enable decimation
  i_data       : in  signed( M-1 downto 0);   -- data input
  o_data_dec   : out signed( O-1 downto 0);  -- data output
  o_data       : out signed( O-1 downto 0)  -- data output
);
end component fir_filter_pitch;

component filter_streaming is
  generic (
   N : natural := 27; --Input Bits
   M : natural := 24  --Output Bits
  );
    port (
     reset_n        : in  std_ulogic; -- asynchronous reset
     clk            : in  std_ulogic; -- clock
     cic_out      : in signed(N-1 downto 0);        --Input signal
     -- Streaming Source
     streaming     : out std_logic_vector(M-1 downto 0);  --Output signal
     valid        : out std_logic;  --Control Signals
     ready        : in std_logic;

     volume_out    : in unsigned(17 downto 0);
     volume_enable : in std_logic;

     enable         : boolean
  );
end component filter_streaming;


begin

  cic_1 : entity work.cic_calc
    generic map (
      Bin => 16, --Number of Bits of the sine wave (precision)
      Bout => cic1Bits,
      M => 2,
      R => 5
    )
    port map (
      reset_n    =>  reset_n, 
      clk        =>  clk,
      cic_in     =>  mixer_out,
      cic_out    =>  cic1out,
      enable_out =>  enable1,
      enable_in  =>  true
    ); 

  cic_2 : entity work.cic_calc
    generic map (
      Bin => cic1Bits, --Number of Bits of the sine wave (precision)
      Bout => cic2Bits,
      M => 1,
      R => 9
    )
    port map (
      reset_n    =>  reset_n, 
      clk        =>  clk,
      cic_in     =>  cic1out,
      cic_out    =>  cic2out,
      enable_out =>  enable2,
      enable_in  =>  enable1
    ); 


  fir_1 : entity work.fir_filter_pitch
    generic map (
      N => 37, --Number of Filter Coefficients
      M => 18, --Number of Input Bits
      O => 18 --Number of Output Bits
    )
    port map (
      clk         =>  clk,
      reset_n     =>  reset_n,
      en_in       =>  enable2,
      en_out      =>  fir_en,
      en_out_dec  =>  enable4,
      i_data      =>  cic2out(cic2out'high downto cic2out'high-17),
      o_data_dec  =>  FIRout,
      o_data      =>  fir
    ); 

  cic_streaming1 : entity work.filter_streaming
    generic map (
      N => 18,
      M => 24
          )
    port map (
      reset_n       =>  reset_n, 
      clk           =>  clk,
      cic_out       =>  FIRout,
      streaming     =>  audio_out, 
      valid         =>  valid,
      ready         =>  ready,

      volume_out    => volume_out,
      volume_enable => volume_enable,

      enable        =>  enable4
    ); 




 
end rtl;