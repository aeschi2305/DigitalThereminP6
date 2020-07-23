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

entity CalGlis is
  generic (
    freq_len : natural := 26;   -- bits of the freq signal
    glis_allow : boolean        -- enables the glissando functionality
  );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    freq : in unsigned(freq_len-1 downto 0);
    freq_diff : out signed(freq_len-1 downto 0);
    cal_enable : in std_ulogic;
    gli_enable : in std_ulogic;
    freq_enable : in std_ulogic;
    cal_done   : out std_ulogic;
    delay_index : in natural range 0 to 9;
    freq_meas	: in std_ulogic
  );
end entity CalGlis;
	
architecture behavioral of CalGlis is

type t_freq_array is array(integer range 0 to 48) of signed(freq_len-1 downto 0);
type t_threas_array is array(integer range 0 to 49) of signed(freq_len-1 downto 0);

constant pitch_values : t_freq_array :=     ("00000000000001000001011010",  --values of the frequencies of the pitches (three octaves)
                                            "00000000000001000101010011",
                                            "00000000000001001001011011",
                                            "00000000000001001101110010",
                                            "00000000000001010010011010",
                                            "00000000000001010111010100",
                                            "00000000000001011100100000",
                                            "00000000000001100010000000",
                                            "00000000000001100111110101",
                                            "00000000000001101110000000",
                                            "00000000000001110100100011",
                                            "00000000000001111011011110",
                                            "00000000000010000010110100",
                                            "00000000000010001010100110",
                                            "00000000000010010010110101",
                                            "00000000000010011011100100",
                                            "00000000000010100100110100",
                                            "00000000000010101110100111",
                                            "00000000000010111001000000",
                                            "00000000000011000100000000",
                                            "00000000000011001111101010",
                                            "00000000000011011100000000",
                                            "00000000000011101001000101",
                                            "00000000000011110110111100",
                                            "00000000000100000101101000",
                                            "00000000000100010101001100",
                                            "00000000000100100101101011",
                                            "00000000000100110111001000",
                                            "00000000000101001001101000",
                                            "00000000000101011101001111",
                                            "00000000000101110010000000",
                                            "00000000000110001000000000",
                                            "00000000000110011111010011",
                                            "00000000000110111000000000",
                                            "00000000000111010010001010",
                                            "00000000000111101101111001",
                                            "00000000001000001011010000",
                                            "00000000001000101010010111",
                                            "00000000001001001011010101",
                                            "00000000001001101110010000",
                                            "00000000001010010011010000",
                                            "00000000001010111010011101",
                                            "00000000001011100011111111",
                                            "00000000001100001111111111",
                                            "00000000001100111110100111",
                                            "00000000001101110000000000",
                                            "00000000001110100100010101",
                                            "00000000001111011011110001",
                                            "00000000010000010110100000");

constant freq_threas  : t_threas_array :=   ("00000000000000111111100011",   --threashold values of the frequencies of the pitches
                                            "00000000000001000011010101",
                                            "00000000000001000111010101",
                                            "00000000000001001011100100",
                                            "00000000000001010000000100",
                                            "00000000000001010100110101",
                                            "00000000000001011001110111",
                                            "00000000000001011111001101",
                                            "00000000000001100100111000",
                                            "00000000000001101010111000",
                                            "00000000000001110001001110",
                                            "00000000000001110111111101",
                                            "00000000000001111111000110",
                                            "00000000000010000110101001",
                                            "00000000000010001110101010",
                                            "00000000000010010111001001",
                                            "00000000000010100000001000",
                                            "00000000000010101001101001",
                                            "00000000000010110011101111",
                                            "00000000000010111110011011",
                                            "00000000000011001001101111",
                                            "00000000000011010101101111",
                                            "00000000000011100010011101",
                                            "00000000000011101111111010",
                                            "00000000000011111110001011",
                                            "00000000000100001101010011",
                                            "00000000000100011101010100",
                                            "00000000000100101110010001",
                                            "00000000000101000000010000",
                                            "00000000000101010011010010",
                                            "00000000000101100111011110",
                                            "00000000000101111100110110",
                                            "00000000000110010011011111",
                                            "00000000000110101011011110",
                                            "00000000000111000100111001",
                                            "00000000000111011111110101",
                                            "00000000000111111100010111",
                                            "00000000001000011010100101",
                                            "00000000001000111010100111",
                                            "00000000001001011100100011",
                                            "00000000001010000000011111",
                                            "00000000001010100110100101",
                                            "00000000001011001110111011",
                                            "00000000001011111001101011",
                                            "00000000001100100110111110",
                                            "00000000001101010110111101",
                                            "00000000001110001001110010",
                                            "00000000001110111111101001",
                                            "00000000001111111000101110",
                                            "00000000010000110101001011");--values for when the frequency is approximated enough


constant tolerance_values : t_freq_array := ("00000000000000000000001111",
    										"00000000000000000000001111",
    										"00000000000000000000010000",
    										"00000000000000000000010001",
    										"00000000000000000000010010",
    										"00000000000000000000010011",
    										"00000000000000000000010101",
    										"00000000000000000000010110",
    										"00000000000000000000010111",
    										"00000000000000000000011000",
    										"00000000000000000000011010",
    										"00000000000000000000011011",
    										"00000000000000000000011101",
    										"00000000000000000000011111",
    										"00000000000000000000100001",
    										"00000000000000000000100011",
    										"00000000000000000000100101",
    										"00000000000000000000100111",
    										"00000000000000000000101001",
    										"00000000000000000000101100",
    										"00000000000000000000101110",
    										"00000000000000000000110001",
    										"00000000000000000000110100",
    										"00000000000000000000110111",
    										"00000000000000000000111010",
    										"00000000000000000000111110",
    										"00000000000000000001000001",
    										"00000000000000000001000101",
    										"00000000000000000001001001",
    										"00000000000000000001001110",
    										"00000000000000000001010010",
    										"00000000000000000001010111",
    										"00000000000000000001011100",
    										"00000000000000000001100010",
    										"00000000000000000001101000",
    										"00000000000000000001101110",
    										"00000000000000000001110100",
    										"00000000000000000001111011",
    										"00000000000000000010000010",
    										"00000000000000000010001010",
    										"00000000000000000010010010",
    										"00000000000000000010011011",
    										"00000000000000000010100100",
    										"00000000000000000010101110",
    										"00000000000000000010111001",
    										"00000000000000000011000100",
    										"00000000000000000011001111",
    										"00000000000000000011011011",
    										"00000000000000000011101001");




constant freq_step  : t_freq_array :=       ("00000000000000000000000010",  -- values for the frequency steps for the glissando effect (1 cent of the desired frequency)
                                            "00000000000000000000000011",
                                            "00000000000000000000000011",
                                            "00000000000000000000000011",
                                            "00000000000000000000000011",
                                            "00000000000000000000000011",
                                            "00000000000000000000000011",
                                            "00000000000000000000000100",
                                            "00000000000000000000000100",
                                            "00000000000000000000000100",
                                            "00000000000000000000000100",
                                            "00000000000000000000000101",
                                            "00000000000000000000000101",
                                            "00000000000000000000000101",
                                            "00000000000000000000000101",
                                            "00000000000000000000000110",
                                            "00000000000000000000000110",
                                            "00000000000000000000000110",
                                            "00000000000000000000000111",
                                            "00000000000000000000000111",
                                            "00000000000000000000001000",
                                            "00000000000000000000001000",
                                            "00000000000000000000001001",
                                            "00000000000000000000001001",
                                            "00000000000000000000001010",
                                            "00000000000000000000001010",
                                            "00000000000000000000001011",
                                            "00000000000000000000001100",
                                            "00000000000000000000001100",
                                            "00000000000000000000001101",
                                            "00000000000000000000001110",
                                            "00000000000000000000001110",
                                            "00000000000000000000001111",
                                            "00000000000000000000010000",
                                            "00000000000000000000010001",
                                            "00000000000000000000010010",
                                            "00000000000000000000010011",
                                            "00000000000000000000010100",
                                            "00000000000000000000010110",
                                            "00000000000000000000010111",
                                            "00000000000000000000011000",
                                            "00000000000000000000011010",
                                            "00000000000000000000011011",
                                            "00000000000000000000011101",
                                            "00000000000000000000011111",
                                            "00000000000000000000100001",
                                            "00000000000000000000100010",
                                            "00000000000000000000100101",
                                            "00000000000000000000100111");


type t_max_count_array is array(integer range 0 to 9) of natural range 0 to 1048576;

constant max_count : t_max_count_array := (100,     --kein Delay
                                           27000,   --ca. 50ms Delay
                                           54000,   --ca. 100ms Delay
                                           108000,   --ca. 200ms Delay
                                           216000,  --ca. 400ms Delay
                                           270000,  --ca. 500ms Delay
                                           432000,  --ca. 800 ms Delay
                                           540000,  --ca. 1s Delay
                                           810000,  --ca. 1.5s Delay
                                           1048575);--ca. 2s Delay (Number looks so weird so that "only" 20 bits are needed)

signal delay_count_reg : natural range 0 to 1048575;
signal delay_count_cmb : natural range 0 to 1048576;

constant min_freq_val      : signed(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "110010000000";  -- corresponds to 100Hz
constant cal_val        : unsigned(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "111100000000";  -- corresponds to 120Hz
constant cal_stp        : signed(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "001000000000";  -- corresponds to 16Hz (for simulation purposes)
--constant cal_stp        : signed(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "000001000000";  -- corresponds to 2Hz

signal freq_diff_reg    : signed(freq_len-1 downto 0);
signal freq_diff_cmb    : signed(freq_len-1 downto 0);
signal freq_cal_reg     : signed(freq_len-1 downto 0);
signal freq_cal_cmb     : signed(freq_len-1 downto 0);
signal freq_check       : signed(freq_len downto 0);
signal freq_sign        : signed(freq_len-1 downto 0);
signal freq_sign_chn    : signed(freq_len-1 downto 0);
signal freq_gli_reg     : signed(freq_len-1 downto 0);
signal freq_gli_cmb     : signed(freq_len-1 downto 0);
signal freq_old         : signed(freq_len-1 downto 0);
signal freq_actual_reg  : signed(freq_len-1 downto 0);
signal freq_actual_cmb  : signed(freq_len-1 downto 0);
signal gli_diff_reg     : signed(freq_len-1 downto 0);
signal gli_diff_cmb     : signed(freq_len-1 downto 0);
signal gli_diff_neg_reg : signed(freq_len-1 downto 0);
signal gli_diff_neg_cmb : signed(freq_len-1 downto 0);
signal gli_diff_cmb_n   : signed(freq_len-1 downto 0);
signal gli_diff_neg_cmb_n   : signed(freq_len-1 downto 0);
signal gli_step         : signed(freq_len-1 downto 0);
signal gli_step_cmb     : signed(freq_len-1 downto 0);
signal meas             : std_ulogic;
signal done             : std_ulogic;
signal done_old         : std_ulogic;
signal gli_fast         : std_ulogic;
signal approx_done		: std_ulogic;
signal delay 			: std_ulogic;

signal gli_index_reg : integer range 0 to pitch_values'length;
signal gli_index_cmb : integer range 0 to pitch_values'length;

type state_type is (s_idle, s_check, s_sign, s_diff, s_freq_range, s_step, s_step_cnt);
signal state_ns : state_type; -- next state
signal state_cs : state_type; -- current state


begin


    p_fsm_nxt : process(all)

    begin
            -- default
        state_ns <= state_cs; 
        case state_cs is

            when s_idle => 
                if cal_enable = '1' and freq_enable = '1' then
                    state_ns <= s_check;
                elsif gli_enable = '1' and glis_allow = true and freq_enable = '1' then
                    state_ns <= s_freq_range;
                end if;

            when s_check => 
                if done = '1' and done_old = '0' then
                    state_ns <= s_sign;
                end if;

            when s_sign => 
                if done = '1' and done_old = '0' then
                    state_ns <= s_diff;
                end if;

            when s_diff => 
                if done = '1' and done_old = '0' then
                    state_ns <= s_idle;
                end if;

            when s_freq_range => 
            	if done = '1' and done_old = '0' then
            	    if (signed(freq) >= freq_threas(freq_threas'high)) or (signed(freq) <= freq_threas(freq_threas'low)) then
            	        state_ns <= s_idle;
            	    else
            	        state_ns <= s_step;
            	    end if;
            	end if;
            when s_step => 
                state_ns <= s_step_cnt;

            when s_step_cnt => 
                if gli_enable = '0' then
                    state_ns <= s_idle;
                elsif freq_enable = '1' and freq_meas = '0' then
                    state_ns <= s_freq_range;
                end if;

            when others => 
                null;
        end case;

    end process p_fsm_nxt;

    p_fsm_reg : process(reset_n,clk)
    
    begin
        if reset_n = '0' then
            freq_diff_reg   <= (others => '0');
            freq_cal_reg    <= (others => '0');
            freq_gli_reg    <= (others => '0');
            freq_old        <= (others => '0');
            freq_actual_reg <= (others => '0');
            gli_diff_reg    <= (others => '0');
            gli_diff_neg_reg<= (others => '0');
            gli_index_reg   <= 0;
            gli_step        <= (others => '0');
            delay_count_reg <= 0;
            done            <= '0';
            done_old		<= '0';
            cal_done		<= '0';
            meas            <= '0';
            state_cs        <= s_idle;
            delay 			<= '0';
        elsif rising_edge(clk) then
            freq_diff_reg <= freq_diff_cmb;
            state_cs  <= state_ns;
            done_old <= done;
            cal_done <= '0';
            approx_done <= '0';

            case state_ns is

                when s_idle =>          --idle state where no effect or calibration is happening
                	done <= '0';
                    if cal_enable = '0' then
                        cal_done <= '0';
                    end if;
                    freq_gli_reg <= (others => '0');

                when s_check =>                     --Used to check if the frequency is too low to measure
                    freq_cal_reg <= (others => '0');
                    done <= '0';

                    if freq_enable = '1' then
                        if signed(freq) = min_freq_val then
                            freq_cal_reg <= min_freq_val(freq_len-3 downto 0) & "00";
                        end if;
                        done <= '1';
                    end if;

                when s_sign =>                      --Used to determin if the frequency of the reference oscillator is bigger
                    done <= '0';
                    if freq_enable = '1' then
                        if meas = '0' then
                            freq_old <= signed(freq);                   --saves old value and subtracts 100Hz to check sign
                            freq_cal_reg <= freq_sign;          
                            meas <= '1';
                        else
                            if freq_old > signed(freq) then
                                freq_cal_reg <= freq_sign_chn;  --changes the sign
                            end if;
                            done <= '1';
                            meas <= '0';
                        end if;
                    end if;     

                when s_diff =>                  --sets the frequency so that the difference becomes 100Hz by reducing the ref. osc. in steps
                    done <= '0';
                    if freq_enable = '1' then
                        freq_cal_reg <= freq_cal_cmb;
                        if freq < cal_val then
                            cal_done <= '1';
                            done <= '1';
                        end if;
                    end if;

                when s_freq_range =>                --Calculates the nearest note and its index
                	delay <= '1';
                	done <= '0';
                	if delay = '1' then
                    	gli_diff_reg <= gli_diff_cmb;
                    	gli_diff_neg_reg <= gli_diff_neg_cmb;
                    	gli_index_reg <= gli_index_cmb;
                    	delay <= '0';
                    	done <= '1';
                    else
                    	freq_actual_reg <= freq_actual_cmb;
                    end if;


                when s_step =>                                             --calculates the frequency steps
                    if gli_diff_reg(gli_diff_reg'high) = '1' then
                        gli_step <= freq_step(gli_index_reg);
                    else
                         gli_step <= gli_step_cmb;
                    end if;
                    
                when s_step_cnt =>                                          --converges the actual pitch to the nearest note
                    if ((gli_diff_reg > tolerance_values(gli_index_reg)) or (gli_diff_neg_reg > tolerance_values(gli_index_reg))) and freq_meas = '0' then
                        if delay_count_reg /= max_count(delay_index) then
                            delay_count_reg <= delay_count_cmb;
                        else
                            freq_gli_reg <= freq_gli_cmb;
                            gli_diff_reg <= gli_diff_cmb_n;
                            gli_diff_neg_reg <= gli_diff_neg_cmb_n;
                            delay_count_reg <= 0;
                        end if;
                    elsif ((gli_diff_reg < tolerance_values(gli_index_reg)) and (gli_diff_neg_reg < tolerance_values(gli_index_reg))) and freq_meas = '0' then
                    	approx_done <= '1';

                    end if;
                    
                when others => 
                    null;
            end case;
        end if;
    end process p_fsm_reg;



    p_fsm_cmb : process(all)
    variable gli_index : integer range 0 to pitch_values'length;
    variable step_tmp : signed(freq_len downto 0);
    variable freq_gli_cmb_tmp : signed(freq_len-1 downto 0);
    begin
        --freq_check <= signed(freq(freq_len-2 downto 0)) + min_freq_val(freq_len-3 downto 0) & "00";           --freq + 400Hz
        freq_sign  <= freq_cal_reg + min_freq_val;                               --freq_cal_reg + 100Hz
        freq_sign_chn <= freq_cal_reg + signed(freq(freq_len-2 downto 0) & '0'); --freq_cal_reg + 2 * freq
        freq_cal_cmb <= freq_cal_reg - cal_stp;


        l_freq_range : for ii in 0 to pitch_values'length-1 loop
            if freq_threas(ii) < freq_actual_reg and freq_threas(ii+1) > freq_actual_reg then
                gli_index := ii;
            end if;
        end loop l_freq_range;
        gli_diff_cmb <= pitch_values(gli_index) - signed(freq);
        gli_diff_neg_cmb <= signed(freq) - pitch_values(gli_index);
        gli_index_cmb <= gli_index;
        step_tmp := not(freq_step(gli_index_reg)) + (freq_len-1 downto 1 => '0') & '1';
        gli_step_cmb <= step_tmp(freq_len-1 downto 0);
        freq_gli_cmb_tmp := freq_gli_reg - gli_step; 
        freq_gli_cmb <= freq_gli_cmb_tmp;
        gli_diff_cmb_n <= gli_diff_reg + gli_step;
        gli_diff_neg_cmb_n <= gli_diff_neg_reg - gli_step;
        delay_count_cmb <= delay_count_reg + 1;
        freq_actual_cmb <= signed(freq) - freq_gli_cmb_tmp;

        freq_diff_cmb <= freq_cal_reg + freq_gli_reg;
    end process p_fsm_cmb;

freq_diff <= freq_diff_reg;
 

end architecture behavioral;
