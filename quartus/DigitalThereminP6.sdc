#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 -name ref_clk [get_ports {clk_clk}]

# Automatically constrain PLL and other generated clocks
 derive_pll_clocks


# Manually constrain PLL and other generated clocks
#create_generated_clock \
#	-name clk \
#	-source {i0_system|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin} \
#	{i0_system|pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}
#
#create_generated_clock \
#	-name dram_clk_pll \
#	-offset -3.333 \
#	-source {i0_system|pll|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin} \
#	{i0_system|pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}
#
#create_clock -period 20 -name dram_clk [get_ports {dram_clk}]

# Add clock uncertainty
#derive_clock_uncertainty

#**************************************************************
# Set Input Delay
#**************************************************************
#set_input_delay  -clock clk 1                {sw[*]}
#set_input_delay  -clock clk 1                {key[*]}
0

#**************************************************************
# Set Output Delay
#**************************************************************
#set_output_delay -clock clk 1                {ledr[*]}
#set_output_delay -clock clk 1                {hex*[*]}

#**************************************************************
# Set SDRAM Timing
# - tDH : Data-in hold time (min) = 1
# - tDS : Data-in setup time (min) = 2
# - tHZ3: Data-out high-impedance time (max) = 5.5
# - tOH : Data-out hold time (min) = 2.5
#**************************************************************

# https://github.com/bsteinsbo/DE1-SoC-Sound/blob/master/DE1_SOC_Linux_Audio/DE1_SOC_Linux_Audio.sdc
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)
#set_input_delay -clock dram_clk -max -0.048   {dram_dq[*]}
#set_input_delay -clock dram_clk -min -0.057   {dram_dq[*]}

# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
set_output_delay -clock dram_clk -max 1.452   {dram_dq[*]}
set_output_delay -clock dram_clk -min -0.857  {dram_dq[*]}
set_output_delay -clock dram_clk -max 1.531   {dram_addr[*]}
set_output_delay -clock dram_clk -min -0.805  {dram_addr[*]}
set_output_delay -clock dram_clk -max 1.533   {dram_dqm[*]}
set_output_delay -clock dram_clk -min -0.805  {dram_dqm[*]}
set_output_delay -clock dram_clk -max 1.510   {dram_ba[*]}
set_output_delay -clock dram_clk -min -0.800  {dram_ba[*]}
set_output_delay -clock dram_clk -max 1.520   {dram_ras_n}
set_output_delay -clock dram_clk -min -0.780  {dram_ras_n}
set_output_delay -clock dram_clk -max 1.5000  {dram_cas_n}
set_output_delay -clock dram_clk -min -0.800  {dram_cas_n}
set_output_delay -clock dram_clk -max 1.545   {dram_we_n}
set_output_delay -clock dram_clk -min -0.755  {dram_we_n}
set_output_delay -clock dram_clk -max 1.496   {dram_cke}
set_output_delay -clock dram_clk -min -0.804  {dram_cke}
set_output_delay -clock dram_clk -max 1.508   {dram_cs_n}
set_output_delay -clock dram_clk -min -0.792  {dram_cs_n}

#**************************************************************
# Set False Path
#**************************************************************
# set_false_path   -from                       {hex*[*]}


#**************************************************************
# Set Output Delay
#**************************************************************
# from asynchronous reset
#set_false_path -from {ime_reset:i0_ime_reset|sys_rst}

# Clock to the SDRAM
# set_false_path -from {i0_system|pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -to {dram_clk}

# InOut-Data of SDRAM
# set_false_path -from {dram_dq[*]} -to {system:i0_system|system_dram_ctrl:dram_ctrl|za_data[*]}
