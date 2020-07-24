/*----------------------------------------------------
 * File    :
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
//#ifndef __VOLUME_DUMMY_REGS_H__
#define __VOLUME_DUMMY_REGS_H__

#include <io.h>
#include "altera_avalon_pio_regs.h"

#define  IORD_VOLUME_DUMMY_AVALON_VOL_RD_CNTRL(base)			IORD(base,0x00)
#define  IORD_VOLUME_DUMMY_AVALON_VOL_RD_freq(base)				IORD(base,0x01)
#define  IORD_VOLUME_DUMMY_AVALON_VOL_RD_vol_gain(base)			IORD(base,0x02)

#define  IOWR_VOLUME_DUMMY_AVALON_VOL_WR_CNTRL(base,value)  	IOWR(base,0x00,value)
#define  IOWR_VOLUME_DUMMY_AVALON_VOL_WR_VOL_GAIN(base,value)  	IOWR(base,0x02,value)
