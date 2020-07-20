#
# ime_avalon_keypad_driver.tcl
#

# Create a new driver
create_driver Volume_dummy_driver

# Associate it with some hardware known as "ime_avalon_keypad"
set_sw_property hw_class_name Volume_dummy

# The version of this driver
set_sw_property version 1.0

set_sw_property min_compatible_hw_version 1.0

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/Volume_dummy.c

# Include files
add_sw_property include_source HAL/inc/Volume_dummy.h
add_sw_property include_source inc/Volume_dummy_regs.h

# This driver supports HAL 
add_sw_property supported_bsp_type HAL

# add_sw_property supported_bsp_type UCOSII
add_sw_property supported_bsp_type UCOSII
# End of file
