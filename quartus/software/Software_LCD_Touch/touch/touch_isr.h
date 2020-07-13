/* File    : touch_isr.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
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


/*
 * Define
 */


#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */


/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void touch_isr(void * context);

void touch_init(void* context);

void get_xy (void * context);



#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
