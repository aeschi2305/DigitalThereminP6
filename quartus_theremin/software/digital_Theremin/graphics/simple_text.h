/*----------------------------------------------------
 * File    : simple_text.h
 * Author  : Dennis Aeschbacher & Andreas Frei
 * Date    : Aug. 14 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : Draws a string with the Arial 22 bitmap
 *--------------------------------------------------*/
#ifndef __SIMPLE_TEXT_H__
#define __SIMPLE_TEXT_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "arial_22.h"
#include "LT24_Controller_regs.h"



#define FONT_offset 64

#define SCREEN_WIDTH	240
#define SCREEN_HEIGHT	320


#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*----------------------------------------------------
 * Function: int get_string_width(char string[])
 * Purpose : returns the pixel width of the given string
 * Return  : int
 *--------------------------------------------------*/
int get_string_width(char string[]);
/*----------------------------------------------------
 * Function: int print_string(int horiz_offset, int vert_offset, int color, const alt_u8 *font, const alt_u16 (*font_descriptor)[2], char string[])
 * Purpose : Prints a string to the specified location of the screen
*            using the specified font and color.
 * Return  : int
 *--------------------------------------------------*/
int print_string(int horiz_offset, int vert_offset, int color, const alt_u8 *font, const alt_u16 (*font_descriptor)[2], char string[]);
/*----------------------------------------------------
 * Function: int print_char (int horiz_offset, int vert_offset, int color, char character, const alt_u8 *font, const alt_u16 (*font_descriptor)[2])
 * Purpose : Prints a character to the specified location of the
 *           screen using the specified font and color.
 * Return  : int
 *--------------------------------------------------*/
int print_char (int horiz_offset, int vert_offset, int color, char character, const alt_u8 *font, const alt_u16 (*font_descriptor)[2]);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
