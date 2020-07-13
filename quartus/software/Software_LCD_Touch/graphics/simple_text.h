/*----------------------------------------------------
 * File    : simple_text.h
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#ifndef __SIMPLE_TEXT_H__
#define __SIMPLE_TEXT_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "LT24_Controller_regs.h"
#include "graphics.h"
#include "fonts.h"
#include "bahnschriftCondensed_22.h"
#include "alt_video_display.h"
#include "arial_24.h"

#define FONT_offset 64//124 Arial


#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

int vid_print_string_alpha(int horiz_offset, int vert_offset, int color, int background_color, struct abc_font_struct font[], alt_video_display * display, char string[]);

int seperate_color_channels(int color_depth, unsigned char * color, unsigned char * red, unsigned char * green, unsigned char * blue);

int merge_color_channels(int color_depth, unsigned char red, unsigned char green, unsigned char blue, unsigned char * color);

int alpha_blending (int horiz_offset, int vert_offset, int background_color, unsigned char alpha, unsigned char *red, unsigned char *green, unsigned char *blue, alt_video_display * display);

int vid_print_char_alpha (int horiz_offset, int vert_offset, int color, char character, int background_color, struct abc_font_struct font[], alt_video_display * display);

// functions used by vid_print_string_alpha
int vid_print_string(int horiz_offset, int vert_offset, int color, const alt_u8 *font, const alt_u16 (*font_descriptor)[2], char string[]);

int vid_print_char (int horiz_offset, int vert_offset, int color, char character, const alt_u8 *font, const alt_u16 (*font_descriptor)[2]);


int vid_string_pixel_length_alpha( struct abc_font_struct font[], char string[] );


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
