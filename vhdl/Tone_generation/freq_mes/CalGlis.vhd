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
    freq_len : natural := 21;   -- bits of the freq signal
    glis_allow : boolean        -- enables the glissando functionality
  );
  port(
    reset_n : in std_ulogic;
    clk : in std_ulogic;
    freq : in unsigned(freq_len-1 downto 0);
    freq_diff : out unsigned(freq_len-1 downto 0);
    cal_enable : in std_ulogic;
    gli_enable : in std_ulogic;
    freq_enable : in std_ulogic;
    cal_done   : out std_ulogic
  );
end entity CalGlis;
	
architecture behavioral of CalGlis is

type t_freq_array is array(integer range <>) of signed(freq_len-1 downto 0);

constant pitch_values : t_freq_array :=     ("000000001000001011010",  --values of the frequencies of the pitches (three octaves)
                                            "000000001000101010011",
                                            "000000001001001011011",
                                            "000000001001101110010",
                                            "000000001010010011010",
                                            "000000001010111010100",
                                            "000000001011100100000",
                                            "000000001100010000000",
                                            "000000001100111110101",
                                            "000000001101110000000",
                                            "000000001110100100011",
                                            "000000001111011011110",
                                            "000000010000010110100",
                                            "000000010001010100110",
                                            "000000010010010110101",
                                            "000000010011011100100",
                                            "000000010100100110100",
                                            "000000010101110100111",
                                            "000000010111001000000",
                                            "000000011000100000000",
                                            "000000011001111101010",
                                            "000000011011100000000",
                                            "000000011101001000101",
                                            "000000011110110111100",
                                            "000000100000101101000",
                                            "000000100010101001100",
                                            "000000100100101101011",
                                            "000000100110111001000",
                                            "000000101001001101000",
                                            "000000101011101001111",
                                            "000000101110010000000",
                                            "000000110001000000000",
                                            "000000110011111010011",
                                            "000000110111000000000",
                                            "000000111010010001010",
                                            "000000111101101111001",
                                            "000001000001011010000",
                                            "000001000101010010111",
                                            "000001001001011010101",
                                            "000001001101110010000",
                                            "000001010010011010000",
                                            "000001010111010011101",
                                            "000001011100011111111",
                                            "000001100001111111111",
                                            "000001100111110100111",
                                            "000001101110000000000",
                                            "000001110100100010101",
                                            "000001111011011110001",
                                            "000010000010110100000");

constant freq_threas  : t_freq_array   :=   ("000000000111111100011",   --threashold values of the frequencies of the pitches
                                            "000000001000011010101",
                                            "000000001000111010101",
                                            "000000001001011100100",
                                            "000000001010000000100",
                                            "000000001010100110101",
                                            "000000001011001110111",
                                            "000000001011111001101",
                                            "000000001100100111000",
                                            "000000001101010111000",
                                            "000000001110001001110",
                                            "000000001110111111101",
                                            "000000001111111000110",
                                            "000000010000110101001",
                                            "000000010001110101010",
                                            "000000010010111001001",
                                            "000000010100000001000",
                                            "000000010101001101001",
                                            "000000010110011101111",
                                            "000000010111110011011",
                                            "000000011001001101111",
                                            "000000011010101101111",
                                            "000000011100010011101",
                                            "000000011101111111010",
                                            "000000011111110001011",
                                            "000000100001101010011",
                                            "000000100011101010100",
                                            "000000100101110010001",
                                            "000000101000000010000",
                                            "000000101010011010010",
                                            "000000101100111011110",
                                            "000000101111100110110",
                                            "000000110010011011111",
                                            "000000110101011011110",
                                            "000000111000100111001",
                                            "000000111011111110101",
                                            "000000111111100010111",
                                            "000001000011010100101",
                                            "000001000111010100111",
                                            "000001001011100100011",
                                            "000001010000000011111",
                                            "000001010100110100101",
                                            "000001011001110111011",
                                            "000001011111001101011",
                                            "000001100100110111110",
                                            "000001101010110111101",
                                            "000001110001001110010",
                                            "000001110111111101001",
                                            "000001111111000101110",
                                            "000010000110101001011");


constant tolerance_values : t_freq_array := ("000000000000000100010",     --values for when the frequency is approximated enough
                                            "000000000000000100100",
                                            "000000000000000100110",
                                            "000000000000000101000",
                                            "000000000000000101011",
                                            "000000000000000101101",
                                            "000000000000000110000",
                                            "000000000000000110011",
                                            "000000000000000110110",
                                            "000000000000000111001",
                                            "000000000000000111101",
                                            "000000000000001000000",
                                            "000000000000001000100",
                                            "000000000000001001000",
                                            "000000000000001001100",
                                            "000000000000001010001",
                                            "000000000000001010110",
                                            "000000000000001011011",
                                            "000000000000001100000",
                                            "000000000000001100110",
                                            "000000000000001101100",
                                            "000000000000001110010",
                                            "000000000000001111001",
                                            "000000000000010000000",
                                            "000000000000010001000",
                                            "000000000000010010000",
                                            "000000000000010011001",
                                            "000000000000010100010",
                                            "000000000000010101011",
                                            "000000000000010110101",
                                            "000000000000011000000",
                                            "000000000000011001100",
                                            "000000000000011011000",
                                            "000000000000011100101",
                                            "000000000000011110010",
                                            "000000000000100000001",
                                            "000000000000100010000",
                                            "000000000000100100000",
                                            "000000000000100110001",
                                            "000000000000101000011",
                                            "000000000000101010111",
                                            "000000000000101101011",
                                            "000000000000110000001",
                                            "000000000000110010111",
                                            "000000000000110110000",
                                            "000000000000111001001",
                                            "000000000000111100100",
                                            "000000000001000000001",
                                            "000000000001000100000");


constant freq_step  : t_freq_array :=       ("000000000000000000010",  -- values for the frequency steps for the glissando effect (1 cent of the desired frequency)
                                            "000000000000000000011",
                                            "000000000000000000011",
                                            "000000000000000000011",
                                            "000000000000000000011",
                                            "000000000000000000011",
                                            "000000000000000000011",
                                            "000000000000000000100",
                                            "000000000000000000100",
                                            "000000000000000000100",
                                            "000000000000000000100",
                                            "000000000000000000101",
                                            "000000000000000000101",
                                            "000000000000000000101",
                                            "000000000000000000101",
                                            "000000000000000000110",
                                            "000000000000000000110",
                                            "000000000000000000110",
                                            "000000000000000000111",
                                            "000000000000000000111",
                                            "000000000000000001000",
                                            "000000000000000001000",
                                            "000000000000000001001",
                                            "000000000000000001001",
                                            "000000000000000001010",
                                            "000000000000000001010",
                                            "000000000000000001011",
                                            "000000000000000001100",
                                            "000000000000000001100",
                                            "000000000000000001101",
                                            "000000000000000001110",
                                            "000000000000000001110",
                                            "000000000000000001111",
                                            "000000000000000010000",
                                            "000000000000000010001",
                                            "000000000000000010010",
                                            "000000000000000010011",
                                            "000000000000000010100",
                                            "000000000000000010110",
                                            "000000000000000010111",
                                            "000000000000000011000",
                                            "000000000000000011010",
                                            "000000000000000011011",
                                            "000000000000000011101",
                                            "000000000000000011111",
                                            "000000000000000100001",
                                            "000000000000000100010",
                                            "000000000000000100101",
                                            "000000000000000100111");


type t_max_count_array is array(integer range <>) of natural range <>;

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
signal delay_count_cmb : natural range 0 to 1048575;

constant 100Hz_val      : signed(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "110010000000";  -- corresponds to 100Hz
constant cal_val        : signed(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "111100000000";  -- corresponds to 120Hz
constant cal_stp        : signed(freq_len-1 downto 0) := (freq_len-1 downto 12 => '0') & "000001000000";  -- corresponds to 2Hz

signal freq_diff_reg    : signed(freq_len-1 downto 0);
signal freq_diff_cmb    : signed(freq_len-1 downto 0);
signal freq_cal_reg     : signed(freq_len-1 downto 0);
signal freq_check       : signed(freq_len-1 downto 0);
signal freq_sign        : signed(freq_len-1 downto 0);
signal freq_sign_chn    : signed(freq_len-1 downto 0);
signal freq_gli_reg     : signed(freq_len-1 downto 0);
signal freq_gli_cmb_f   : signed(freq_len-1 downto 0);
signal freq_gli_cmb_s   : signed(freq_len-1 downto 0);
signal freq_gli_cmb_n   : signed(freq_len-1 downto 0);
signal freq_old         : signed(freq_len-1 downto 0);
signal gli_diff_reg     : signed(freq_len-1 downto 0);
signal meas             : std_ulogic;
signal done             : std_ulogic;
signal gli_fast         : std_ulogic;

type state_type is (s_idle, s_check, s_sign, s_diff, s_freq_range, s_step_mode, s_step_cnt);
signal state_ns : state_type; -- next state
signal state_cs : state_type; -- current state


begin


    p_fsm_nxt : process(all)

    begin
            -- default
        state_ns <= state_cs; 
        case state_cs is

            when s_idle => 
                if cal_enable = '1' then
                    state_ns <= s_check;
                elsif gli_enable = '1' and glis_allow = true and freq_enable = '1' then
                    state_ns <= s_freq_range;
                end if;

            when s_check => 
                if done = '1' then
                    state_ns <= s_sign;
                end if;

            when s_sign => 
                if done = '1' then
                    state_ns <= s_diff;
                end if;

            when s_diff => 
                if freq < cal_val then
                    state_ns <= s_idle;
                end if;

            when s_freq_range => 
                if done = '1' then
                    if freq > freq_threas(freq_reas'high) or freq < freq_threas(freq_threas'low) then
                        state_ns <= s_idle;
                    else
                        state_ns <= s_step_mode;
                    end if;
                end if;

            when s_step_mode => 
                if gli_diff_reg < fast_freq(gli_index_reg) then
                    state_ns <= s_step_cnt;
                else
                    state_ns <= s_freq_step;
                end if;

            when s_step_cnt => 
                if gli_enable = '0' then
                    state_ns <= s_idle;
                elsif freq_enable = '1' then
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
            meas            <= '0';
            state_cs        <= s_idle;
        elsif rising_edge(clk) then
            freq_diff_reg <= freq_diff_cmb;
            state_cs  <= state_ns;
            case state_ns is

                when s_idle =>          --idle state where no effect or calibration is happening
                    cal_done <= '0';
                    freq_gli_reg <= (others => '0');

                when s_check =>                     --Used to check if the frequency is too low to measure
                    freq_cal_reg <= (others => '0');
                    done = '0';
                    if freq_enable = '1' then
                        if freq = 100Hz_val then
                            freq_cal_reg <= freq_check;
                        end if;
                        done <= '1';
                    end if;

                when s_sign =>                      --Used to determin if the frequency of the reference oscillator is bigger
                    done <= '0';
                    if freq_enable = '1' then
                        if meas = '0' then
                            freq_old <= freq;                   --saves old value and subtracts 100Hz to check sign
                            freq_cal_reg <= freq_sign;          
                            meas <= '1';
                        else
                            if freq_old > freq then
                                freq_cal_reg <= freq_sign_chn;  --changes the sign
                            end if;
                            done = '1';
                            meas <= '0';
                        end if;
                    end if;     

                when s_diff =>                  --sets the frequency so that the difference becomes 100Hz by reducing the ref. osc. in steps
                    if freq_enable = '1' then
                        gli_diff_reg <= gli_diff_cmb;
                    end if;

                when s_freq_range => 
                    gli_diff_reg <= gli_diff_cmb;
                    gli_index_reg <= gli_index_cmb;


                when s_step_mode => 
                    if gli_diff_reg(gli_diff_reg'high) < (others => '0') then
                        gli_step <= freq_step(gli_index_reg);
                    else
                        gli_step <= not(freq_step(gli_index_reg)) + (freq_len-1 downto 1 => '0') & '1';
                    end if;
                    
                when s_step_cnt => 
                    if gli_diff_reg > tolerance_valuesgli_index_reg) then
                        if delay_count_reg /= max_count(gli_index_reg) then
                            delay_count_reg <= delay_count_cmb;
                        else
                            freq_gli_reg <= freq_gli_cmb;
                        end if;
                    end if;
                    
                when others => 
                    null;
            end case;
        end if;
    end process p_fsm_reg;



    p_fsm_cmb : process(all)
    variable gli_index : integer range 0 to pitch_values'length;

    begin
        freq_check <= freq + 100Hz_val(freq_len-3 downto 2) & "00";           --freq + 400Hz
        freq_sign  <= freq_cal_reg + 100Hz_val;                               --freq_cal_reg + 100Hz
        freq_sign_chn <= freq_cal_reg + freq(freq_len-2 downto 1) & '0';
        freq_cal_stp <= freq_cal_reg - cal_stp;

        l_freq_range : for ii in 0 to pitch_values'length-1 loop
            if freq_threas(ii) < freq and freq_threas(ii+1) > freq then
                gli_index := ii;
            end if;
        end loop l_freq_range;
        gli_diff_cmb <= pitch_values(gli_index) - freq;
        gli_index_cmb <= gli_index;

        freq_gli_cmb <= freq_gli_reg + gli_step; 
        gli_diff_cmb_n <= gli_diff_reg + gli_step;
        delay_count_cmb <= delay_count_reg + 1;

        freq_diff_cmb <= freq_cal_reg + freq_gli_reg;
    end process p_fsm_cmb;


 

end architecture behavioral;
