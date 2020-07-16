#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 -name clk_clk [get_ports {clk_clk}] 


#**************************************************************
# Clock groups
#**************************************************************

# set_clock_groups -asynchronous -group [get_clocks pll_ip_1|pll_ip_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk] -group [get_clocks audio_clock_ip_1|audio_pll_0|audio_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk]

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -asynchronous -group [get_clocks {audio_pll_0|audio_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -group [get_clocks {pll_0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

#**************************************************************
# Set Input Delay
#**************************************************************
# set_false_path -from key[*]
set_false_path -from [get_ports {tone_generation_0_conduit_end_0_export}]


#**************************************************************
# Set Output Delay
#**************************************************************
# synchron or asynchron I2C I2S ?
