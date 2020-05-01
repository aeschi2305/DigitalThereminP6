# TCL File Generated by Component Editor 17.1
# Wed Apr 29 14:28:01 CEST 2020
# DO NOT MODIFY


# 
# Tone_generation "Tone_generation" v1.0
#  2020.04.29.14:28:01
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Tone_generation
# 
set_module_property DESCRIPTION ""
set_module_property NAME Tone_generation
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME Tone_generation
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL Tone_generation_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file Tone_generation_top.vhd VHDL PATH IP/Tone_generation/Tone_generation_top.vhd TOP_LEVEL_FILE
add_fileset_file cic_codec.vhd VHDL PATH IP/Tone_generation/cic_codec.vhd
add_fileset_file cordic_control.vhd VHDL PATH IP/Tone_generation/cordic_control.vhd
add_fileset_file cordic_pipelined.vhd VHDL PATH IP/Tone_generation/cordic_pipelined.vhd
add_fileset_file freq_mes.vhd VHDL PATH IP/Tone_generation/freq_mes.vhd
add_fileset_file mixer.vhd VHDL PATH IP/Tone_generation/mixer.vhd


# 
# parameters
# 
add_parameter dat_len_avl NATURAL 31
set_parameter_property dat_len_avl DEFAULT_VALUE 31
set_parameter_property dat_len_avl DISPLAY_NAME dat_len_avl
set_parameter_property dat_len_avl TYPE NATURAL
set_parameter_property dat_len_avl UNITS None
set_parameter_property dat_len_avl ALLOWED_RANGES 0:2147483647
set_parameter_property dat_len_avl HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock csi_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rsi_reset_n reset_n Input 1


# 
# connection point se
# 
add_interface se avalon_streaming start
set_interface_property se associatedClock clock
set_interface_property se associatedReset reset
set_interface_property se dataBitsPerSymbol 8
set_interface_property se errorDescriptor ""
set_interface_property se firstSymbolInHighOrderBits true
set_interface_property se maxChannel 0
set_interface_property se readyLatency 0
set_interface_property se ENABLED true
set_interface_property se EXPORT_OF ""
set_interface_property se PORT_NAME_MAP ""
set_interface_property se CMSIS_SVD_VARIABLES ""
set_interface_property se SVD_ADDRESS_GROUP ""

add_interface_port se aso_se_ready ready Input 1
add_interface_port se aso_se_valid valid Output 1
add_interface_port se aso_se_data data Output 32


# 
# connection point conduit_end_0
# 
add_interface conduit_end_0 conduit end
set_interface_property conduit_end_0 associatedClock clock
set_interface_property conduit_end_0 associatedReset ""
set_interface_property conduit_end_0 ENABLED true
set_interface_property conduit_end_0 EXPORT_OF ""
set_interface_property conduit_end_0 PORT_NAME_MAP ""
set_interface_property conduit_end_0 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_0 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_0 coe_square_freq export Input 1

