/*----------------------------------------------------
 * File    : pitch_generation_regs.h
 * Author  : Andreas Frei
 * Date    : 14.08.2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : Register description for pitch generation
 *--------------------------------------------------*/
//#ifndef __PITCH_GENERATION_REGS_H__
#define __PITCH_GENERATION_REGS_H__

#include <io.h>
#include "altera_avalon_pio_regs.h"

#define  IORD_PITCH_GENERATION_AVALON_PITCH_RD_CNTRL(base)			IORD(base,0x00)
#define  IORD_PITCH_GENERATION_AVALON_PITCH_RD_freq(base)			IORD(base,0x01)
#define  IORD_PITCH_GENERATION_AVALON_PITCH_RD_gli_delay(base)		IORD(base,0x02)

#define  IOWR_PITCH_GENERATION_AVALON_PITCH_WR_CNTRL(base,value)  	IOWR(base,0x00,value)
#define  IOWR_PITCH_GENERATION_AVALON_PITCH_WR_DELAY(base,value)  	IOWR(base,0x02,value)

