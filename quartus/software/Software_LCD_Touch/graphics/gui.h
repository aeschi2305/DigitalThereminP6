/* File    : gui.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#ifndef __GUI_H__
#define __GUI_H__

#include <stdio.h>
#include <unistd.h>
#include <system.h>
#include <sys/alt_irq.h>
#include "LT24_Controller.h"
#include "simple_text.h"



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
void draw_main_screen(void);

void draw_calibrating_screen(void);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
