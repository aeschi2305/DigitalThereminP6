/* File    : LT24_Controller.h
 * Author  : Andreas Frei
 * Date    : 14.08.2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#ifndef __LT24_CONTROLLER_H__
#define __LT24_CONTROLLER_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "LT24_Controller_regs.h"

/*
 * Define
 */
#define RED 0xf800
#define GREEN 0x07e0
#define BLUE 0x001f
#define BLACK  0x0000
#define GREY 0xBDBD
#define WHITE 0xffff

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define LT24_CONTROLLER_INSTANCE(name, device) extern int alt_no_storage
#define LT24_CONTROLLER_INIT(name, device) while (0)

/*----------------------------------------------------
 * Function: void LCD_SetCursor(alt_u16 Xpos, alt_u16 Ypos)
 * Purpose : to set the cursor of the LCD
 * Return  : none
 *--------------------------------------------------*/

void LCD_SetCursor(alt_u16 Xpos, alt_u16 Ypos);
/*----------------------------------------------------
 * Function: void LCD_SetRect(alt_u16 Xposstart, 
 *           alt_u16 Yposstart,alt_u16 Xposend, 
 *			 alt_u16 Yposend)
 * Purpose : To set the LCD cursor for an entire 
 *			 rectangle
 * Return  : none
 *--------------------------------------------------*/
void LCD_SetRect(alt_u16 Xposstart, alt_u16 Yposstart,alt_u16 Xposend, alt_u16 Yposend);
/*----------------------------------------------------
 * Function: void LCD_Clear(alt_u16 Color)
 * Purpose : to clear the LCD
 * Return  : none
 *--------------------------------------------------*/
void LCD_Clear(alt_u16 Color);
/*----------------------------------------------------
 * Function: void LCD_DrawPoint(alt_u16 x,alt_u16 y,
 *           alt_u16 color )
 * Purpose : to draw a point on the LCD
 * Return  : none
 *--------------------------------------------------*/
void LCD_DrawPoint(alt_u16 x,alt_u16 y,alt_u16 color );
/*----------------------------------------------------
 * Function: void LCD_DrawRect(alt_u16 xs,alt_u16 ys,
 *           alt_u16 xe,alt_u16 ye,alt_u16 color )
 * Purpose : to draw a rect
 * Return  : none
 *--------------------------------------------------*/
void LCD_DrawRect(alt_u16 xs,alt_u16 ys,alt_u16 xe,alt_u16 ye,alt_u16 color );
/*----------------------------------------------------
 * Function: void vid_set_pixel(int horiz, int vert,
 * unsigned int color)
 * Purpose : Is used by the pirnt_string function 
 *           to filter the passed color
 * Return  : none
 *--------------------------------------------------*/
void vid_set_pixel(int horiz, int vert, unsigned int color);
/*----------------------------------------------------
 * Function: void LCD_Init()
 * Purpose : to initialise the LCD
 * Return  : none
 *--------------------------------------------------*/
void LCD_Init (void);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
