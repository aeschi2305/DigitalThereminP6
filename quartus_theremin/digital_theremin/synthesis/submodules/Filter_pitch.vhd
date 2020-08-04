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
   cic2Bits : natural := 25;
   cic3Bits : natural := 28
	);
  	port (
  	 reset_n  	    : in  std_ulogic; -- asynchronous reset
     clk      	    : in  std_ulogic; -- clock
     mixer_out 	    : in signed(N-1 downto 0);				--Input signal
     -- Streaming Source
     audio_out      : out std_logic_vector(23 downto 0);	--Output signal
     valid          : out std_logic;  --Control Signals
     ready          : in std_logic;

     cic1o          : out signed(cic1Bits-1 downto 0);
     cic2o          : out signed(cic2Bits-1 downto 0);
     cic3o          : out signed(cic3Bits-1 downto 0);

     cic1_en        : out boolean;
     cic2_en        : out boolean;
     cic3_en        : out boolean;

     vol_cntrl    : in std_logic

  );
end entity filter_pitch;



architecture rtl of filter_pitch is


constant FIRBits : natural := 27;

signal cic1out : signed(cic1Bits-1 downto 0);
signal cic2out : signed(cic2Bits-1 downto 0);
signal cic3out : signed(cic3Bits-1 downto 0);
signal FIRout : signed(FIRBits-1 downto 0);
signal enable1 : boolean;
signal enable2 : boolean;
signal enable3 : boolean;
signal enable4 : boolean;

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

component fir_filter_dec is
generic (
    N : natural := 11; --Number of Filter Coefficients
    M : natural := 29; --Number of Input Bits
    O : natural := 27; --Number of Output Bits
    dec : natural := 5);   --Decimation Factor);
port (
  clk        : in  std_logic;
  reset_n       : in  std_logic;
  -- enable
  en_in        : in boolean;
  en_out       : out boolean;
  -- data input
  i_data       : in  signed( N-1 downto 0);
  -- filtered data 
  o_data       : out signed( N-1 downto 0));

end component fir_filter_dec;

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

     vol_cntrl    : in std_logic;

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

  cic_3 : entity work.cic_calc
    generic map (
      Bin => cic2Bits, --Number of Bits of the sine wave (precision)
      Bout => cic3Bits,
      M => 1,
      R => 5
    )
    port map (
      reset_n    =>  reset_n, 
      clk        =>  clk,
      cic_in     =>  cic2out,
      cic_out    =>  cic3out,
      enable_out =>  enable3,
      enable_in  =>  enable2
    ); 

  fir_1 : entity work.fir_filter_dec
    generic map (
      N => 22, --Number of Filter Coefficients
      M => cic3Bits, --Number of Input Bits
      O => 27, --Number of Output Bits
      dec => 5
    )
    port map (
      clk         =>  clk,
      reset_n     =>  reset_n,
      en_in       =>  enable3,
      en_out      =>  enable4,
      i_data      =>  cic3out,
      o_data      =>  FIRout
    ); 

  cic_streaming1 : entity work.filter_streaming
    generic map (
      N => 27,
      M => 24
          )
    port map (
      reset_n       =>  reset_n, 
      clk           =>  clk,
      cic_out       =>  FIRout,
      streaming     =>  audio_out, 
      valid         =>  valid,
      ready         =>  ready,

      vol_cntrl     => vol_cntrl,

      enable        =>  enable4
    ); 

    cic1_en <= enable1;
    cic2_en <= enable2;
    cic3_en <= enable3;

    cic1o   <= cic1out;
    cic2o   <= cic2out;
    cic3o   <= cic3out;

 
end rtl;