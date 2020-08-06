/*----------------------------------------------------
 * File    :
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
//#ifndef __VOLUME_DUMMY_REGS_H__
#define __VOLUME_GENERATION_REGS_H__

#include <io.h>
#include "altera_avalon_pio_regs.h"

#define  IORD_VOLUME_GENERATION_AVALON_VOL_RD_CNTRL(base)			IORD(base,0x00)

#define  IOWR_VOLUME_GENERATION_AVALON_VOL_WR_CNTRL(base,value)  	IOWR(base,0x00,value)


