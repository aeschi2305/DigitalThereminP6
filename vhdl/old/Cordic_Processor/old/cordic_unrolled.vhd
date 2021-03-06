-----------------------------------------------------
-- Project : Digital Theremin
-----------------------------------------------------
-- File    : cordic_unrolled.vhd
-- Author  : dennis.aeschbacher@students.fhnw.ch
-----------------------------------------------------
-- Description : Calculates the sine value of a given angle phi in N parallel iterations
-----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_unrolled is
  generic (
    N : natural := 16 --Number of Bits of the sine wave (precision)
  );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    phi : in signed(N-1 downto 0);
    sine : out signed(N downto 0)
  );
end entity cordic_unrolled;

architecture behavioral of cordic_unrolled is
type atan_type is array (0 to 14) of signed (N-1 downto 0);
constant atan : atan_type :=     ("0100000000000000",  -- Lookuptable for the arcustangent of 2^-k
                                  "0010010111001000",
                                  "0001001111110110",
                                  "0000101000100010",
                                  "0000010100010110",
                                  "0000001010001011",
                                  "0000000101000101",
                                  "0000000010100010",
                                  "0000000001010001",
                                  "0000000000101000",
                                  "0000000000010100",
                                  "0000000000001010",
                                  "0000000000000101",
                                  "0000000000000010",
                                  "0000000000000001");


signal cnt : integer range 0 to 15;

type cordic_record is record
    x : signed (N downto 0);
    y : signed (N downto 0);
    z : signed (N-1 downto 0);
end record cordic_record;

type cordic_record_array is array (N-1 downto 0) of cordic_record;

signal cordic_rec_reg : cordic_record;
signal cordic_rec_init: cordic_record;
signal cordic_rec_cmb : cordic_record_array;

function calculateIteration (        --calculation of one Iteration
     cordic_rec : cordic_record;   -- iteration index
     k : integer
)
return cordic_record is
  variable v_record : cordic_record;
  variable xx : signed(N downto 0); --temprary variable
  begin
    v_record := cordic_rec;
    if v_record.z(v_record.z'left) = '0' then           -- is zk positive
        xx := v_record.x - shift_right(v_record.y,k);    
        v_record.y := v_record.y + shift_right(v_record.x,k);
        v_record.z := v_record.z - atan(k);
    else
        xx := v_record.x + shift_right(v_record.y,k);
        v_record.y := v_record.y - shift_right(v_record.x,k);
        v_record.z := v_record.z + atan(k);
    end if;
    v_record.x := xx;
    return v_record;
  end function calculateIteration;

begin

    p_reg : process(reset_n,clk)
    begin
        if reset_n = '0' then
            cordic_rec_reg.x <= (others => '0');   
            cordic_rec_reg.y <= (others => '0');
            cordic_rec_reg.z <= (others => '0');
        elsif rising_edge(clk) then
              cordic_rec_init.x <= (others => '1');           --only needed if pipelined
              cordic_rec_init.x(N downto N-1) <= "00";
              cordic_rec_init.y <= (others => '0');
              cordic_rec_init.z <= phi; 
              cordic_rec_reg.x <= cordic_rec_cmb(N-1).x;            --only needed if pipelined
              cordic_rec_reg.y <= cordic_rec_cmb(N-1).y;
              cordic_rec_reg.z <= cordic_rec_cmb(N-1).z;            --only needed if pipelined              
        end if;
    end process p_reg;

    p_cmb : process(all)

    begin 
    	cordic_rec_cmb(0) <= cordic_rec_init;
    	l_cordic : for i in 0 to N-2 loop
      		cordic_rec_cmb(i+1) <= calculateIteration(cordic_rec_cmb(i),i);
      	end loop l_cordic;
    end process p_cmb;

    sine <= cordic_rec_reg.y;

    
            
end architecture behavioral;
