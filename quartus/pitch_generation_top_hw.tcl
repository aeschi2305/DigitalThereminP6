# TCL File Generated by Component Editor 17.1
# Thu Jul 30 08:52:13 CEST 2020
# DO NOT MODIFY


# 
# pitch_generation_top "pitch_generation_top" v1.0
#  2020.07.30.08:52:13
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module pitch_generation_top
# 
set_module_property DESCRIPTION ""
set_module_property NAME pitch_generation_top
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME pitch_generation_top
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pitch_generation_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file pitch_generation_top.vhd VHDL PATH ../vhdl/Pitch_generation/pitch_generation_top.vhd TOP_LEVEL_FILE
add_fileset_file cordic_control.vhd VHDL PATH ../vhdl/Pitch_generation/cordic/cordic_control.vhd
add_fileset_file FIR_Decimation.vhd VHDL PATH ../vhdl/Pitch_generation/filter/FIR_Decimation.vhd
add_fileset_file Filter.vhd VHDL PATH ../vhdl/Pitch_generation/filter/Filter.vhd
add_fileset_file cic.vhd VHDL PATH ../vhdl/Pitch_generation/filter/cic.vhd
add_fileset_file filter_streaming.vhd VHDL PATH ../vhdl/Pitch_generation/filter/filter_streaming.vhd
add_fileset_file CalGlis.vhd VHDL PATH ../vhdl/Pitch_generation/freq_mes/Cal_Glis/CalGlis.vhd
add_fileset_file goldschmidt.vhd VHDL PATH ../vhdl/Pitch_generation/freq_mes/Goldschmidt/goldschmidt.vhd
add_fileset_file FIR_pitch.vhd VHDL PATH ../vhdl/Pitch_generation/freq_mes/FIR_pitch.vhd
add_fileset_file count_freq_meas.vhd VHDL PATH ../vhdl/Pitch_generation/freq_mes/count_freq_meas.vhd
add_fileset_file freq_meas_pitch.vhd VHDL PATH ../vhdl/Pitch_generation/freq_mes/freq_meas_pitch.vhd
add_fileset_file mixer.vhd VHDL PATH ../vhdl/Pitch_generation/mixer/mixer.vhd
add_fileset_file cordic_pipelined.vhd VHDL PATH ../vhdl/Pitch_generation/cordic/cordic_pipelined.vhd


# 
# parameters
# 
add_parameter dat_len_avl NATURAL 32
set_parameter_property dat_len_avl DEFAULT_VALUE 32
set_parameter_property dat_len_avl DISPLAY_NAME dat_len_avl
set_parameter_property dat_len_avl TYPE NATURAL
set_parameter_property dat_len_avl UNITS None
set_parameter_property dat_len_avl ALLOWED_RANGES 0:2147483647
set_parameter_property dat_len_avl HDL_PARAMETER true
add_parameter cic1Bits NATURAL 21
set_parameter_property cic1Bits DEFAULT_VALUE 21
set_parameter_property cic1Bits DISPLAY_NAME cic1Bits
set_parameter_property cic1Bits TYPE NATURAL
set_parameter_property cic1Bits UNITS None
set_parameter_property cic1Bits ALLOWED_RANGES 0:2147483647
set_parameter_property cic1Bits HDL_PARAMETER true
add_parameter cic2Bits NATURAL 25
set_parameter_property cic2Bits DEFAULT_VALUE 25
set_parameter_property cic2Bits DISPLAY_NAME cic2Bits
set_parameter_property cic2Bits TYPE NATURAL
set_parameter_property cic2Bits UNITS None
set_parameter_property cic2Bits ALLOWED_RANGES 0:2147483647
set_parameter_property cic2Bits HDL_PARAMETER true
add_parameter cic3Bits NATURAL 28
set_parameter_property cic3Bits DEFAULT_VALUE 28
set_parameter_property cic3Bits DISPLAY_NAME cic3Bits
set_parameter_property cic3Bits TYPE NATURAL
set_parameter_property cic3Bits UNITS None
set_parameter_property cic3Bits ALLOWED_RANGES 0:2147483647
set_parameter_property cic3Bits HDL_PARAMETER true


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
# connection point stg
# 
add_interface stg avalon end
set_interface_property stg addressUnits WORDS
set_interface_property stg associatedClock clock
set_interface_property stg associatedReset reset
set_interface_property stg bitsPerSymbol 8
set_interface_property stg burstOnBurstBoundariesOnly false
set_interface_property stg burstcountUnits WORDS
set_interface_property stg explicitAddressSpan 0
set_interface_property stg holdTime 0
set_interface_property stg linewrapBursts false
set_interface_property stg maximumPendingReadTransactions 0
set_interface_property stg maximumPendingWriteTransactions 0
set_interface_property stg readLatency 0
set_interface_property stg readWaitTime 1
set_interface_property stg setupTime 0
set_interface_property stg timingUnits Cycles
set_interface_property stg writeWaitTime 0
set_interface_property stg ENABLED true
set_interface_property stg EXPORT_OF ""
set_interface_property stg PORT_NAME_MAP ""
set_interface_property stg CMSIS_SVD_VARIABLES ""
set_interface_property stg SVD_ADDRESS_GROUP ""

add_interface_port stg avs_sTG_write write Input 1
add_interface_port stg avs_sTG_address address Input 2
add_interface_port stg avs_sTG_writedata writedata Input dat_len_avl
add_interface_port stg avs_sTG_readdata readdata Output dat_len_avl
set_interface_assignment stg embeddedsw.configuration.isFlash 0
set_interface_assignment stg embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment stg embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment stg embeddedsw.configuration.isPrintableDevice 0


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
add_interface_port se aso_se_data data Output 24


# 
# connection point conduit_end_0
# 
add_interface conduit_end_0 conduit end
set_interface_property conduit_end_0 associatedClock clock
set_interface_property conduit_end_0 associatedReset reset
set_interface_property conduit_end_0 ENABLED true
set_interface_property conduit_end_0 EXPORT_OF ""
set_interface_property conduit_end_0 PORT_NAME_MAP ""
set_interface_property conduit_end_0 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_0 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_0 coe_square_freq coe_square_freq Input 1
add_interface_port conduit_end_0 coe_freq_up_down coe_freq_up_down Input 2
add_interface_port conduit_end_0 coe_Cal_Glis coe_cal_glis Input 2

