#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 -name ref_clk [get_ports {clk_clk}]

# Automatically constrain PLL and other generated clocks
 derive_pll_clocks




#**************************************************************
# Set Input Delay
#**************************************************************


#**************************************************************
# Set Output Delay
#**************************************************************


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
set_output_delay -clock dram_clk -max 1.452   {dram_ctrl_wire_dq[*]}
set_output_delay -clock dram_clk -min -0.857  {dram_ctrl_wire_dq[*]}
set_output_delay -clock dram_clk -max 1.531   {dram_ctrl_wire_addr[*]}
set_output_delay -clock dram_clk -min -0.805  {dram_ctrl_wire_addr[*]}
set_output_delay -clock dram_clk -max 1.533   {dram_ctrl_wire_dqm[*]}
set_output_delay -clock dram_clk -min -0.805  {dram_ctrl_wire_dqm[*]}
set_output_delay -clock dram_clk -max 1.510   {dram_ctrl_wire_ba[*]}
set_output_delay -clock dram_clk -min -0.800  {dram_ctrl_wire_ba[*]}
set_output_delay -clock dram_clk -max 1.520   {dram_ctrl_wire_ras_n}
set_output_delay -clock dram_clk -min -0.780  {dram_ctrl_wire_ras_n}
set_output_delay -clock dram_clk -max 1.5000  {dram_ctrl_wire_cas_n}
set_output_delay -clock dram_clk -min -0.800  {dram_ctrl_wire_cas_n}
set_output_delay -clock dram_clk -max 1.545   {dram_ctrl_wire_we_n}
set_output_delay -clock dram_clk -min -0.755  {dram_ctrl_wire_we_n}
set_output_delay -clock dram_clk -max 1.496   {dram_ctrl_wire_cke}
set_output_delay -clock dram_clk -min -0.804  {dram_ctrl_wire_cke}
set_output_delay -clock dram_clk -max 1.508   {dram_ctrl_wire_cs_n}
set_output_delay -clock dram_clk -min -0.792  {dram_ctrl_wire_cs_n}

#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************
