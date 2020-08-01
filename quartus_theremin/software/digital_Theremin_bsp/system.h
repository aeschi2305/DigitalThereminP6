/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'digital_theremin'
 * SOPC Builder design path: C:/Users/andre/OneDrive/Dokumente/GitHub/DigitalThereminP6/quartus_theremin/digital_theremin.sopcinfo
 *
 * Generated: Fri Jul 31 17:08:23 CEST 2020
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x0a000820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1c
#define ALT_CPU_DCACHE_BYPASS_MASK 0x80000000
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x04000020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 1
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_DIVISION_ERROR_EXCEPTION
#define ALT_CPU_HAS_EXTRA_EXCEPTION_INFO
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x1c
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x097f0000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x0a000820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x1c
#define NIOS2_DCACHE_BYPASS_MASK 0x80000000
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x04000020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 1
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_DIVISION_ERROR_EXCEPTION
#define NIOS2_HAS_EXTRA_EXCEPTION_INFO
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x1c
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x097f0000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SPI
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_EPCQ_CONTROLLER
#define __ALTERA_NIOS2_GEN2
#define __ALTERA_UP_AVALON_AUDIO_AND_VIDEO_CONFIG
#define __LT24_CONTROLLER
#define __PITCH_GENERATION
#define __VOLUME_GENERATION


/*
 * LCD_Controller configuration
 *
 */

#define ALT_MODULE_CLASS_LCD_Controller LT24_Controller
#define LCD_CONTROLLER_BASE 0xa0010d0
#define LCD_CONTROLLER_IRQ -1
#define LCD_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LCD_CONTROLLER_NAME "/dev/LCD_Controller"
#define LCD_CONTROLLER_SPAN 8
#define LCD_CONTROLLER_TYPE "LT24_Controller"


/*
 * LCD_reset_n configuration
 *
 */

#define ALT_MODULE_CLASS_LCD_reset_n altera_avalon_pio
#define LCD_RESET_N_BASE 0xa0010a0
#define LCD_RESET_N_BIT_CLEARING_EDGE_REGISTER 0
#define LCD_RESET_N_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LCD_RESET_N_CAPTURE 0
#define LCD_RESET_N_DATA_WIDTH 1
#define LCD_RESET_N_DO_TEST_BENCH_WIRING 0
#define LCD_RESET_N_DRIVEN_SIM_VALUE 0
#define LCD_RESET_N_EDGE_TYPE "NONE"
#define LCD_RESET_N_FREQ 15000000
#define LCD_RESET_N_HAS_IN 0
#define LCD_RESET_N_HAS_OUT 1
#define LCD_RESET_N_HAS_TRI 0
#define LCD_RESET_N_IRQ -1
#define LCD_RESET_N_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LCD_RESET_N_IRQ_TYPE "NONE"
#define LCD_RESET_N_NAME "/dev/LCD_reset_n"
#define LCD_RESET_N_RESET_VALUE 0
#define LCD_RESET_N_SPAN 16
#define LCD_RESET_N_TYPE "altera_avalon_pio"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone V"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag"
#define ALT_STDERR_BASE 0xa0010d8
#define ALT_STDERR_DEV jtag
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag"
#define ALT_STDIN_BASE 0xa0010d8
#define ALT_STDIN_DEV jtag
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag"
#define ALT_STDOUT_BASE 0xa0010d8
#define ALT_STDOUT_DEV jtag
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "digital_theremin"


/*
 * audio_and_video_config_0 configuration
 *
 */

#define ALT_MODULE_CLASS_audio_and_video_config_0 altera_up_avalon_audio_and_video_config
#define AUDIO_AND_VIDEO_CONFIG_0_BASE 0xa0010b0
#define AUDIO_AND_VIDEO_CONFIG_0_IRQ -1
#define AUDIO_AND_VIDEO_CONFIG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define AUDIO_AND_VIDEO_CONFIG_0_NAME "/dev/audio_and_video_config_0"
#define AUDIO_AND_VIDEO_CONFIG_0_SPAN 16
#define AUDIO_AND_VIDEO_CONFIG_0_TYPE "altera_up_avalon_audio_and_video_config"


/*
 * dram_cntrl configuration
 *
 */

#define ALT_MODULE_CLASS_dram_cntrl altera_avalon_new_sdram_controller
#define DRAM_CNTRL_BASE 0x4000000
#define DRAM_CNTRL_CAS_LATENCY 3
#define DRAM_CNTRL_CONTENTS_INFO
#define DRAM_CNTRL_INIT_NOP_DELAY 0.0
#define DRAM_CNTRL_INIT_REFRESH_COMMANDS 2
#define DRAM_CNTRL_IRQ -1
#define DRAM_CNTRL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DRAM_CNTRL_IS_INITIALIZED 1
#define DRAM_CNTRL_NAME "/dev/dram_cntrl"
#define DRAM_CNTRL_POWERUP_DELAY 100.0
#define DRAM_CNTRL_REFRESH_PERIOD 7.8125
#define DRAM_CNTRL_REGISTER_DATA_IN 1
#define DRAM_CNTRL_SDRAM_ADDR_WIDTH 0x19
#define DRAM_CNTRL_SDRAM_BANK_WIDTH 2
#define DRAM_CNTRL_SDRAM_COL_WIDTH 10
#define DRAM_CNTRL_SDRAM_DATA_WIDTH 16
#define DRAM_CNTRL_SDRAM_NUM_BANKS 4
#define DRAM_CNTRL_SDRAM_NUM_CHIPSELECTS 1
#define DRAM_CNTRL_SDRAM_ROW_WIDTH 13
#define DRAM_CNTRL_SHARED_DATA 0
#define DRAM_CNTRL_SIM_MODEL_BASE 0
#define DRAM_CNTRL_SPAN 67108864
#define DRAM_CNTRL_STARVATION_INDICATOR 0
#define DRAM_CNTRL_TRISTATE_BRIDGE_SLAVE ""
#define DRAM_CNTRL_TYPE "altera_avalon_new_sdram_controller"
#define DRAM_CNTRL_T_AC 5.4
#define DRAM_CNTRL_T_MRD 3
#define DRAM_CNTRL_T_RCD 15.0
#define DRAM_CNTRL_T_RFC 70.0
#define DRAM_CNTRL_T_RP 15.0
#define DRAM_CNTRL_T_WR 14.0


/*
 * epcs_cntl_avl_csr configuration
 *
 */

#define ALT_MODULE_CLASS_epcs_cntl_avl_csr altera_epcq_controller
#define EPCS_CNTL_AVL_CSR_BASE 0xa001000
#define EPCS_CNTL_AVL_CSR_FLASH_TYPE "EPCS128"
#define EPCS_CNTL_AVL_CSR_IRQ 2
#define EPCS_CNTL_AVL_CSR_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCS_CNTL_AVL_CSR_IS_EPCS 1
#define EPCS_CNTL_AVL_CSR_NAME "/dev/epcs_cntl_avl_csr"
#define EPCS_CNTL_AVL_CSR_NUMBER_OF_SECTORS 256
#define EPCS_CNTL_AVL_CSR_PAGE_SIZE 256
#define EPCS_CNTL_AVL_CSR_SECTOR_SIZE 65536
#define EPCS_CNTL_AVL_CSR_SPAN 32
#define EPCS_CNTL_AVL_CSR_SUBSECTOR_SIZE 4096
#define EPCS_CNTL_AVL_CSR_TYPE "altera_epcq_controller"


/*
 * epcs_cntl_avl_mem configuration
 *
 */

#define ALT_MODULE_CLASS_epcs_cntl_avl_mem altera_epcq_controller
#define EPCS_CNTL_AVL_MEM_BASE 0x9000000
#define EPCS_CNTL_AVL_MEM_FLASH_TYPE "EPCS128"
#define EPCS_CNTL_AVL_MEM_IRQ -1
#define EPCS_CNTL_AVL_MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define EPCS_CNTL_AVL_MEM_IS_EPCS 1
#define EPCS_CNTL_AVL_MEM_NAME "/dev/epcs_cntl_avl_mem"
#define EPCS_CNTL_AVL_MEM_NUMBER_OF_SECTORS 256
#define EPCS_CNTL_AVL_MEM_PAGE_SIZE 256
#define EPCS_CNTL_AVL_MEM_SECTOR_SIZE 65536
#define EPCS_CNTL_AVL_MEM_SPAN 16777216
#define EPCS_CNTL_AVL_MEM_SUBSECTOR_SIZE 4096
#define EPCS_CNTL_AVL_MEM_TYPE "altera_epcq_controller"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK TIMER
#define ALT_TIMESTAMP_CLK none


/*
 * jtag configuration
 *
 */

#define ALT_MODULE_CLASS_jtag altera_avalon_jtag_uart
#define JTAG_BASE 0xa0010d8
#define JTAG_IRQ 0
#define JTAG_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_NAME "/dev/jtag"
#define JTAG_READ_DEPTH 64
#define JTAG_READ_THRESHOLD 8
#define JTAG_SPAN 8
#define JTAG_TYPE "altera_avalon_jtag_uart"
#define JTAG_WRITE_DEPTH 64
#define JTAG_WRITE_THRESHOLD 8


/*
 * pitch_generation_0 configuration
 *
 */

#define ALT_MODULE_CLASS_pitch_generation_0 pitch_generation
#define PITCH_GENERATION_0_BASE 0xa001070
#define PITCH_GENERATION_0_IRQ -1
#define PITCH_GENERATION_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PITCH_GENERATION_0_NAME "/dev/pitch_generation_0"
#define PITCH_GENERATION_0_SPAN 16
#define PITCH_GENERATION_0_TYPE "pitch_generation"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0xa0010c8
#define SYSID_ID 1
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1596207273
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * timer configuration
 *
 */

#define ALT_MODULE_CLASS_timer altera_avalon_timer
#define TIMER_ALWAYS_RUN 0
#define TIMER_BASE 0xa001040
#define TIMER_COUNTER_SIZE 32
#define TIMER_FIXED_PERIOD 0
#define TIMER_FREQ 50000000
#define TIMER_IRQ 1
#define TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_LOAD_VALUE 49999
#define TIMER_MULT 0.001
#define TIMER_NAME "/dev/timer"
#define TIMER_PERIOD 1
#define TIMER_PERIOD_UNITS "ms"
#define TIMER_RESET_OUTPUT 0
#define TIMER_SNAPSHOT 1
#define TIMER_SPAN 32
#define TIMER_TICKS_PER_SEC 1000
#define TIMER_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_TYPE "altera_avalon_timer"


/*
 * touch_panel_busy configuration
 *
 */

#define ALT_MODULE_CLASS_touch_panel_busy altera_avalon_pio
#define TOUCH_PANEL_BUSY_BASE 0xa001080
#define TOUCH_PANEL_BUSY_BIT_CLEARING_EDGE_REGISTER 0
#define TOUCH_PANEL_BUSY_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TOUCH_PANEL_BUSY_CAPTURE 0
#define TOUCH_PANEL_BUSY_DATA_WIDTH 1
#define TOUCH_PANEL_BUSY_DO_TEST_BENCH_WIRING 0
#define TOUCH_PANEL_BUSY_DRIVEN_SIM_VALUE 0
#define TOUCH_PANEL_BUSY_EDGE_TYPE "NONE"
#define TOUCH_PANEL_BUSY_FREQ 15000000
#define TOUCH_PANEL_BUSY_HAS_IN 1
#define TOUCH_PANEL_BUSY_HAS_OUT 0
#define TOUCH_PANEL_BUSY_HAS_TRI 0
#define TOUCH_PANEL_BUSY_IRQ -1
#define TOUCH_PANEL_BUSY_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TOUCH_PANEL_BUSY_IRQ_TYPE "NONE"
#define TOUCH_PANEL_BUSY_NAME "/dev/touch_panel_busy"
#define TOUCH_PANEL_BUSY_RESET_VALUE 0
#define TOUCH_PANEL_BUSY_SPAN 16
#define TOUCH_PANEL_BUSY_TYPE "altera_avalon_pio"


/*
 * touch_panel_pen_irq_n configuration
 *
 */

#define ALT_MODULE_CLASS_touch_panel_pen_irq_n altera_avalon_pio
#define TOUCH_PANEL_PEN_IRQ_N_BASE 0xa001090
#define TOUCH_PANEL_PEN_IRQ_N_BIT_CLEARING_EDGE_REGISTER 0
#define TOUCH_PANEL_PEN_IRQ_N_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TOUCH_PANEL_PEN_IRQ_N_CAPTURE 1
#define TOUCH_PANEL_PEN_IRQ_N_DATA_WIDTH 1
#define TOUCH_PANEL_PEN_IRQ_N_DO_TEST_BENCH_WIRING 0
#define TOUCH_PANEL_PEN_IRQ_N_DRIVEN_SIM_VALUE 0
#define TOUCH_PANEL_PEN_IRQ_N_EDGE_TYPE "FALLING"
#define TOUCH_PANEL_PEN_IRQ_N_FREQ 15000000
#define TOUCH_PANEL_PEN_IRQ_N_HAS_IN 1
#define TOUCH_PANEL_PEN_IRQ_N_HAS_OUT 0
#define TOUCH_PANEL_PEN_IRQ_N_HAS_TRI 0
#define TOUCH_PANEL_PEN_IRQ_N_IRQ 3
#define TOUCH_PANEL_PEN_IRQ_N_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TOUCH_PANEL_PEN_IRQ_N_IRQ_TYPE "EDGE"
#define TOUCH_PANEL_PEN_IRQ_N_NAME "/dev/touch_panel_pen_irq_n"
#define TOUCH_PANEL_PEN_IRQ_N_RESET_VALUE 0
#define TOUCH_PANEL_PEN_IRQ_N_SPAN 16
#define TOUCH_PANEL_PEN_IRQ_N_TYPE "altera_avalon_pio"


/*
 * touch_panel_spi configuration
 *
 */

#define ALT_MODULE_CLASS_touch_panel_spi altera_avalon_spi
#define TOUCH_PANEL_SPI_BASE 0xa001020
#define TOUCH_PANEL_SPI_CLOCKMULT 1
#define TOUCH_PANEL_SPI_CLOCKPHASE 0
#define TOUCH_PANEL_SPI_CLOCKPOLARITY 0
#define TOUCH_PANEL_SPI_CLOCKUNITS "Hz"
#define TOUCH_PANEL_SPI_DATABITS 8
#define TOUCH_PANEL_SPI_DATAWIDTH 16
#define TOUCH_PANEL_SPI_DELAYMULT "1.0E-9"
#define TOUCH_PANEL_SPI_DELAYUNITS "ns"
#define TOUCH_PANEL_SPI_EXTRADELAY 0
#define TOUCH_PANEL_SPI_INSERT_SYNC 0
#define TOUCH_PANEL_SPI_IRQ 4
#define TOUCH_PANEL_SPI_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TOUCH_PANEL_SPI_ISMASTER 1
#define TOUCH_PANEL_SPI_LSBFIRST 0
#define TOUCH_PANEL_SPI_NAME "/dev/touch_panel_spi"
#define TOUCH_PANEL_SPI_NUMSLAVES 1
#define TOUCH_PANEL_SPI_PREFIX "spi_"
#define TOUCH_PANEL_SPI_SPAN 32
#define TOUCH_PANEL_SPI_SYNC_REG_DEPTH 2
#define TOUCH_PANEL_SPI_TARGETCLOCK 32000u
#define TOUCH_PANEL_SPI_TARGETSSDELAY "0.0"
#define TOUCH_PANEL_SPI_TYPE "altera_avalon_spi"


/*
 * volume_generation_0 configuration
 *
 */

#define ALT_MODULE_CLASS_volume_generation_0 volume_generation
#define VOLUME_GENERATION_0_BASE 0xa001060
#define VOLUME_GENERATION_0_IRQ -1
#define VOLUME_GENERATION_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define VOLUME_GENERATION_0_NAME "/dev/volume_generation_0"
#define VOLUME_GENERATION_0_SPAN 16
#define VOLUME_GENERATION_0_TYPE "volume_generation"

#endif /* __SYSTEM_H_ */
