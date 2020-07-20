# TCL File Generated by Component Editor 17.1
# Fri Jul 17 16:16:40 CEST 2020
# DO NOT MODIFY


# 
# Volume_dummy "Volume_dummy" v1.0
#  2020.07.17.16:16:40
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Volume_dummy
# 
set_module_property DESCRIPTION ""
set_module_property NAME Volume_dummy
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME Volume_dummy
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL volume_dummy
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file volume_dummy.vhd VHDL PATH ip/Volume_dummy/hdl/volume_dummy.vhd TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter dat_len_avl NATURAL 31
set_parameter_property dat_len_avl DEFAULT_VALUE 31
set_parameter_property dat_len_avl DISPLAY_NAME dat_len_avl
set_parameter_property dat_len_avl TYPE NATURAL
set_parameter_property dat_len_avl UNITS None
set_parameter_property dat_len_avl HDL_PARAMETER true
add_parameter data_freq STD_LOGIC_VECTOR 64000
set_parameter_property data_freq DEFAULT_VALUE 64000
set_parameter_property data_freq DISPLAY_NAME data_freq
set_parameter_property data_freq WIDTH 32
set_parameter_property data_freq TYPE STD_LOGIC_VECTOR
set_parameter_property data_freq UNITS None
set_parameter_property data_freq ALLOWED_RANGES 0:4294967295
set_parameter_property data_freq HDL_PARAMETER true
add_parameter data_freq1 STD_LOGIC_VECTOR 32000
set_parameter_property data_freq1 DEFAULT_VALUE 32000
set_parameter_property data_freq1 DISPLAY_NAME data_freq1
set_parameter_property data_freq1 WIDTH 32
set_parameter_property data_freq1 TYPE STD_LOGIC_VECTOR
set_parameter_property data_freq1 UNITS None
set_parameter_property data_freq1 ALLOWED_RANGES 0:4294967295
set_parameter_property data_freq1 HDL_PARAMETER true


# 
# display items
# 


# 
# connection point sp
# 
add_interface sp avalon end
set_interface_property sp addressUnits WORDS
set_interface_property sp associatedClock clock
set_interface_property sp associatedReset reset
set_interface_property sp bitsPerSymbol 8
set_interface_property sp burstOnBurstBoundariesOnly false
set_interface_property sp burstcountUnits WORDS
set_interface_property sp explicitAddressSpan 0
set_interface_property sp holdTime 0
set_interface_property sp linewrapBursts false
set_interface_property sp maximumPendingReadTransactions 0
set_interface_property sp maximumPendingWriteTransactions 0
set_interface_property sp readLatency 0
set_interface_property sp readWaitTime 1
set_interface_property sp setupTime 0
set_interface_property sp timingUnits Cycles
set_interface_property sp writeWaitTime 0
set_interface_property sp ENABLED true
set_interface_property sp EXPORT_OF ""
set_interface_property sp PORT_NAME_MAP ""
set_interface_property sp CMSIS_SVD_VARIABLES ""
set_interface_property sp SVD_ADDRESS_GROUP ""

add_interface_port sp avs_sP_address address Input 1
add_interface_port sp avs_sP_readdata readdata Output "(dat_len_avl) - (0) + 1"
add_interface_port sp avs_sP_write write Input 1
add_interface_port sp avs_sP_writedata writedata Input "(dat_len_avl) - (0) + 1"
set_interface_assignment sp embeddedsw.configuration.isFlash 0
set_interface_assignment sp embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment sp embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment sp embeddedsw.configuration.isPrintableDevice 0


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

add_interface_port conduit_end_0 coe_led_vol export Output 1


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

