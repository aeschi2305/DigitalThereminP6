/*----------------------------------------------------
 * File    : lt24_controller_regs.h
 * Author  : Andreas Frei
 * Date    : 14.08.2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : Register description for lt24 controller
 *--------------------------------------------------*/
//#ifndef __LT24_CONTROLLER_REGS_H__
#define __LT24_CONTROLLER_REGS_H__

#include <io.h>
#include "altera_avalon_pio_regs.h"

#define  IOWR_LT24_AVALON_Set_LCD_RST(base)  		IOWR_ALTERA_AVALON_PIO_DATA(base,0x01)
#define  IOWR_LT24_AVALON_Clr_LCD_RST(base)  		IOWR_ALTERA_AVALON_PIO_DATA(base,0x00)

#define  IOWR_LT24_AVALON_LCD_WR_REG(base,value)  	IOWR(base,0x00,value)
#define  IOWR_LT24_AVALON_LCD_WR_DATA(base,value)  	IOWR(base,0x01,value)
