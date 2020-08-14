/*----------------------------------------------------
 * File    : gui.c
 * Author  : Dennis Aeschbacher & Andreas Frei
 * Date    : Aug. 14 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : GUI design of the different menus
 *--------------------------------------------------*/
#ifndef __TOUCH_ISR_H__
#define __TOUCH_ISR_H__

#include <stdio.h>
#include <unistd.h>
#include <system.h>
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include <sys/alt_irq.h>
#include <sys/alt_alarm.h>


#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*----------------------------------------------------
 * Function: void touch_isr(void * context)
 * Purpose : Is called by the touch interrupt and reads
 * 			 out the x y coordinates of the touch
 * Return  : none
 *--------------------------------------------------*/
void touch_isr(void * context);
/*----------------------------------------------------
 * Function: void touch_init(void* context)
 * Purpose : Initializes the touch pen irq
 * Return  : none
 *--------------------------------------------------*/
void touch_init(void* context);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
