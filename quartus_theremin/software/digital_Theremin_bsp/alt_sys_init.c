/*
 * alt_sys_init.c - HAL initialization source
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'digital_theremin'
 * SOPC Builder design path: D:/GitHub/Projekt6/DigitalTheremin/DigitalThereminP6/quartus_theremin/digital_theremin.sopcinfo
 *
 * Generated: Mon Aug 10 09:54:23 CEST 2020
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

#include "system.h"
#include "sys/alt_irq.h"
#include "sys/alt_sys_init.h"

#include <stddef.h>

/*
 * Device headers
 */

#include "altera_nios2_gen2_irq.h"
#include "LT24_Controller.h"
#include "altera_avalon_jtag_uart.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_sysid_qsys.h"
#include "altera_avalon_timer.h"
#include "altera_epcq_controller.h"
#include "altera_up_avalon_audio_and_video_config.h"
#include "pitch_generation.h"
#include "volume_generation.h"

/*
 * Allocate the device storage
 */

ALTERA_NIOS2_GEN2_IRQ_INSTANCE ( CPU, cpu);
ALTERA_AVALON_JTAG_UART_INSTANCE ( JTAG, jtag);
ALTERA_AVALON_SPI_INSTANCE ( TOUCH_PANEL_SPI, touch_panel_spi);
ALTERA_AVALON_SYSID_QSYS_INSTANCE ( SYSID, sysid);
ALTERA_AVALON_TIMER_INSTANCE ( TIMER, timer);
ALTERA_EPCQ_CONTROLLER_AVL_MEM_AVL_CSR_INSTANCE ( EPCS_CNTL, EPCS_CNTL_AVL_MEM, EPCS_CNTL_AVL_CSR, epcs_cntl);
ALTERA_UP_AVALON_AUDIO_AND_VIDEO_CONFIG_INSTANCE ( AUDIO_AND_VIDEO_CONFIG_0, audio_and_video_config_0);
LT24_CONTROLLER_INSTANCE ( LCD_CONTROLLER, LCD_Controller);
PITCH_GENERATION_INSTANCE ( PITCH_GENERATION_0, pitch_generation_0);
VOLUME_GENERATION_INSTANCE ( VOLUME_GENERATION_0, volume_generation_0);

/*
 * Initialize the interrupt controller devices
 * and then enable interrupts in the CPU.
 * Called before alt_sys_init().
 * The "base" parameter is ignored and only
 * present for backwards-compatibility.
 */

void alt_irq_init ( const void* base )
{
    ALTERA_NIOS2_GEN2_IRQ_INIT ( CPU, cpu);
    alt_irq_cpu_enable_interrupts();
}

/*
 * Initialize the non-interrupt controller devices.
 * Called after alt_irq_init().
 */

void alt_sys_init( void )
{
    ALTERA_AVALON_TIMER_INIT ( TIMER, timer);
    ALTERA_AVALON_JTAG_UART_INIT ( JTAG, jtag);
    ALTERA_AVALON_SPI_INIT ( TOUCH_PANEL_SPI, touch_panel_spi);
    ALTERA_AVALON_SYSID_QSYS_INIT ( SYSID, sysid);
    ALTERA_EPCQ_CONTROLLER_INIT ( EPCS_CNTL, epcs_cntl);
    ALTERA_UP_AVALON_AUDIO_AND_VIDEO_CONFIG_INIT ( AUDIO_AND_VIDEO_CONFIG_0, audio_and_video_config_0);
    LT24_CONTROLLER_INIT ( LCD_CONTROLLER, LCD_Controller);
    PITCH_GENERATION_INIT ( PITCH_GENERATION_0, pitch_generation_0);
    VOLUME_GENERATION_INIT ( VOLUME_GENERATION_0, volume_generation_0);
}
