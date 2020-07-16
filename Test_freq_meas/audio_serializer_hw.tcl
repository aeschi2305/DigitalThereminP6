# TCL File Generated by Component Editor 17.1
# Wed Jul 15 14:28:42 CEST 2020
# DO NOT MODIFY


# 
# audio_serializer "audio_serializer" v1.0
#  2020.07.15.14:28:42
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module audio_serializer
# 
set_module_property DESCRIPTION ""
set_module_property NAME audio_serializer
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME audio_serializer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL audio_serializer
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file audio_serializer.vhd VHDL PATH IP/audio_serializer/audio_serializer.vhd TOP_LEVEL_FILE


# 
# parameters
# 


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

add_interface_port clock clk clk Input 1


# 
# connection point conduit_BCLK
# 
add_interface conduit_BCLK conduit end
set_interface_property conduit_BCLK associatedClock clock
set_interface_property conduit_BCLK associatedReset ""
set_interface_property conduit_BCLK ENABLED true
set_interface_property conduit_BCLK EXPORT_OF ""
set_interface_property conduit_BCLK PORT_NAME_MAP ""
set_interface_property conduit_BCLK CMSIS_SVD_VARIABLES ""
set_interface_property conduit_BCLK SVD_ADDRESS_GROUP ""

add_interface_port conduit_BCLK coe_AUD1_BCLK export Input 1


# 
# connection point conduit_DACLRCK
# 
add_interface conduit_DACLRCK conduit end
set_interface_property conduit_DACLRCK associatedClock clock
set_interface_property conduit_DACLRCK associatedReset ""
set_interface_property conduit_DACLRCK ENABLED true
set_interface_property conduit_DACLRCK EXPORT_OF ""
set_interface_property conduit_DACLRCK PORT_NAME_MAP ""
set_interface_property conduit_DACLRCK CMSIS_SVD_VARIABLES ""
set_interface_property conduit_DACLRCK SVD_ADDRESS_GROUP ""

add_interface_port conduit_DACLRCK coe_AUD3_DACLRCK export Input 1


# 
# connection point conduit_DACDAT
# 
add_interface conduit_DACDAT conduit end
set_interface_property conduit_DACDAT associatedClock clock
set_interface_property conduit_DACDAT associatedReset ""
set_interface_property conduit_DACDAT ENABLED true
set_interface_property conduit_DACDAT EXPORT_OF ""
set_interface_property conduit_DACDAT PORT_NAME_MAP ""
set_interface_property conduit_DACDAT CMSIS_SVD_VARIABLES ""
set_interface_property conduit_DACDAT SVD_ADDRESS_GROUP ""

add_interface_port conduit_DACDAT coe_AUD2_DACDAT export Output 1


# 
# connection point se
# 
add_interface se avalon_streaming end
set_interface_property se associatedClock clock
set_interface_property se dataBitsPerSymbol 24
set_interface_property se errorDescriptor ""
set_interface_property se firstSymbolInHighOrderBits true
set_interface_property se maxChannel 0
set_interface_property se readyLatency 0
set_interface_property se ENABLED true
set_interface_property se EXPORT_OF ""
set_interface_property se PORT_NAME_MAP ""
set_interface_property se CMSIS_SVD_VARIABLES ""
set_interface_property se SVD_ADDRESS_GROUP ""

add_interface_port se aso_se_data data Input 24
add_interface_port se aso_se_ready ready Output 1
add_interface_port se aso_se_valid valid Input 1


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

add_interface_port reset reset_n reset_n Input 1

