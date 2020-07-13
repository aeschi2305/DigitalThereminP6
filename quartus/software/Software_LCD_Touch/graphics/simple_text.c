/*----------------------------------------------------
 * File    : simple_text.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "simple_text.h"
#include "LT24_Controller.h"




int vid_print_string_alpha(int horiz_offset, int vert_offset, int color, int background_color, struct abc_font_struct font[], alt_video_display * display, char string[])
{
  int i = 0;
  int tab;
  int original_horiz_offset;

  original_horiz_offset = horiz_offset;

  // Print until we hit the '\0' char.
  while (string[i]) {
    //Handle newline char here.
    if (string[i] == '\n') {
      horiz_offset = original_horiz_offset;
      vert_offset += font['|' - 33].bounds_height;  // we'll use "|" to add the line to line spacing
      i++;
      continue;
    }
    // Lay down that character and increment our offsets.
    if(string[i] == 32)  // this is a space in ASCII
    {
      if(background_color != CLEAR_BACKGROUND)  // need to fill in this spot (setting foreground to background color so that it looks like a drawn in box)
      {
        vid_print_char_alpha (horiz_offset, vert_offset, background_color, '-', background_color, font, display);
      }
      horiz_offset += font[45 - 33].bounds_width;  // using the width of the '-' character for the space width since it's not present in the font
    }
    else if(string[i] == '\t')  // this is a tab
    {
      for( tab = 0; tab < TAB_SPACING; tab++ )
      {
        if(background_color != CLEAR_BACKGROUND)  // need to fill in this spot (setting foreground to background color so that it looks like a drawn in box)
        {
          vid_print_char_alpha (horiz_offset, vert_offset, background_color, '-', background_color, font, display);
        }
        horiz_offset += font[45 - 33].bounds_width;  // using the width of the '-' character for the space width since it's not present in the font
      }
    }
    else
    {
      vid_print_char_alpha (horiz_offset, vert_offset, color, string[i], background_color, font, display);
      horiz_offset += font[string[i] - 33].bounds_width;
    }
    i++;
  }
  return (0);
}

/******************************************************************
*  Function: seperate_colour_channels
*
*  Author:  JCJB
*
*  Purpose: Takes a single colour pointer and break the value into
*           seperate channels.  It supports 16/24(packed/unpacked)
*           formats as inputs.  The results are passed back by
*           the function working on pointers.
*
******************************************************************/

int seperate_color_channels(int color_depth, unsigned char * color, unsigned char * red, unsigned char * green, unsigned char * blue)
{
  int return_value;  // error checking in case anyone is listening
  unsigned short temp_color = 0;

  if (color_depth == 16)  // R(5):G(6):B(5)
  {
    temp_color = *color++;        // get the first half of the 16 bit color
    temp_color += (*color << 8);  // get the second half of the 16 bit color
    *blue = temp_color & 0x1F;
    *green = (temp_color >> 5) & 0x3F;
    *red = (temp_color >> 11) & 0x1F;
    return_value = 1;
  }
  else if ((color_depth == 24) || (color_depth == 32))  // R(8):G(8):B(8) packed/unpacked
  {
    *blue = *color++;
    *green = *color++;
    *red = *color;
    return_value = 1;
  }
  else  // not a valid color depth for this function
  {
    *red = 0;
    *green = 0;
    *blue = 0;
    return_value = 0;
  }
  return return_value;
}
/******************************************************************
*  Function: merge_color_channels
*
*  Author:  JCJB
*
*  Purpose: Takes the seperate RGB channels and merges them into
*           a single 16/24/32 bit location.  The caller must
*           use an unsigned char * pointer to the destination
*           color allowing the same function to be used for
*           different color formats and packing.
*
******************************************************************/

int merge_color_channels(int color_depth, unsigned char red, unsigned char green, unsigned char blue, unsigned char * color)
{
  int return_value;  // error checking in case anyone is listening
  unsigned short temp_color;

  if (color_depth == 16)  // R(5):G(6):B(5)
  {
    temp_color = (blue & 0x1F) | ((green & 0x3F) << 5) | ((red & 0x1F) << 11);  // 16 bit color format
    *color++ = temp_color & 0xFF;
    *color = (temp_color >> 8) & 0xFF;
    return_value = 1;
  }
  else if ((color_depth == 24) || (color_depth == 32))  // R(8):G(8):B(8) packed/unpacked
  {
    *color++ = blue;
    *color++ = green;
    *color = red;
    return_value = 1;
  }
  else  // not a valid color depth for this function
  {
    *color++ = 0;
    *color++ = 0;
    *color = 0;
    return_value = 0;
  }
  return return_value;
}


/******************************************************************
*  Function: alpha_blending
*
*  Purpose: Takes in the alpha value (0-255) and uses that to mix
*           the font color with the background color.
*
******************************************************************/

int alpha_blending (int horiz_offset, int vert_offset, int background_color, unsigned char alpha, unsigned char *red, unsigned char *green, unsigned char *blue, alt_video_display * display)
{
  int return_value;
  unsigned char background_red, background_green, background_blue;
  unsigned int blended_red, blended_green, blended_blue;  // short since there may be overflow to be clipped

  // set red, green, and blue of the background color
  if(background_color == CLEAR_BACKGROUND)
  {
    //read_from_frame (horiz_offset, vert_offset, &background_red, &background_green, &background_blue, display);
  }
  else
  {
    seperate_color_channels(display->color_depth, (unsigned char *)&background_color, &background_red, &background_green, &background_blue);
  }

  // these blended colors may need to be clipped to the maximum amounts the color depth supports
  blended_red = (((*red) * alpha) + (background_red * (255 - alpha)))/255;
  blended_green = (((*green) * alpha) + (background_green * (255 - alpha)))/255;
  blended_blue = (((*blue) * alpha) + (background_blue * (255 - alpha)))/255;


  if(display->color_depth == 16)
  {
    *red = (blended_red > 0x1F)? 0x1F: blended_red;
    *green = (blended_green > 0x3F)? 0x3F: blended_green;
    *blue = (blended_blue > 0x1F)? 0x1F: blended_blue;
    return_value = 1;
  }
  else if((display->color_depth == 24) || (display->color_depth == 32))
  {
    *red = (blended_red > 0xFF)? 0xFF: blended_red;
    *green = (blended_green > 0xFF)? 0xFF: blended_green;
    *blue = (blended_blue > 0xFF)? 0xFF: blended_blue;
    return_value = 1;
  }
  else
  {
    return_value = 0;
  }

  return return_value;
}


/******************************************************************
*  Function: vid_print_char_alpha
*
*  Purpose: Prints a character to the specified location of the
*           screen using the specified font and color.
*
******************************************************************/

int vid_print_char_alpha (int horiz_offset, int vert_offset, int color, char character, int background_color, struct abc_font_struct font[], alt_video_display * display)
{

  int i, j;
  unsigned char * alpha;
  unsigned char original_red, original_blue, original_green;
  unsigned char red, green, blue;
  int new_color;

  // Assign the pointer of the font bitmap
  alpha = font[character-33].char_alpha_map;

  // set red, green, and blue of the font color
  seperate_color_channels(display->color_depth, (char *)&color, &original_red, &original_green, &original_blue);

  for(i = 0; i < font[character-33].bounds_height; i++) {
    for (j = 0; j < font[character-33].bounds_width; j++) {


      if (alpha == 0x00){
    	  new_color = background_color;
      }
      else if (alpha == 0xFF){
         new_color = color;
      }
      else{
          red = original_red;
          green = original_green;
          blue = original_blue;
          // send in the font alpha channel and the colour channels for the blending to occur
          alpha_blending ((vert_offset + i), (SCREEN_HEIGHT-horiz_offset - j), background_color, *alpha, &red, &green, &blue, display);

          // take the blended pixel and merge the color channels back into a single pixel value
          merge_color_channels(display->color_depth, red, green, blue, (char *)&new_color);
      }
      // write the new pixel value out to memory overwriting the current background
      vid_set_pixel((vert_offset +i), (SCREEN_HEIGHT-horiz_offset - j), new_color);
      //vid_set_pixel((horiz_offset + j), (vert_offset + i), new_color);

      alpha++;
    }
  }

  return(0);
}

/******************************************************************
*  Function: vid_print_string
*
*  Purpose: Prints a string to the specified location of the screen
*           using the specified font and color.
*           Calls vid_print_char
*
******************************************************************/
int vid_print_string(int horiz_offset, int vert_offset, int color, const alt_u8 *font, const alt_u16 (*font_descriptor)[2], char string[])
{
  int i = 0;
  alt_u16 bit_num_char, temp_char;
  //int original_horiz_offset;

  //original_horiz_offset = horiz_offset;

  // Print until we hit the '\0' char.
  while (string[i]) {
    //Handle newline char here.
    if (string[i] == ' ') {
      horiz_offset += 10 ;
      i++;
      continue;
    }
    // Lay down that character and increment our offsets.
    temp_char = (string[i] - 0x21);
    bit_num_char = *(*(font_descriptor + temp_char));
    vid_print_char (horiz_offset, vert_offset, color, string[i], font, font_descriptor);
    horiz_offset += 4 + (int)bit_num_char;
    i++;

  }
  return (0);
}

/******************************************************************
*  Function: vid_print_char
*
*  Purpose: Prints a character to the specified location of the
*           screen using the specified font and color.
*
******************************************************************/

int vid_print_char (int horiz_offset, int vert_offset, int color, char character, const alt_u8 *font, const alt_u16 (*font_descriptor)[2])
{

  int i, j, k, j_end;

  alt_u32 temp_char;
  alt_u8 *char_row;
  alt_u16 row_offset;
  alt_u16 bit_num_char;
  alt_u16 bit_num_char_temp;
  alt_u8 byte_offset;
  // Convert the ASCII value to an array offset
  temp_char = (character - 0x21);
  row_offset = *(*(font_descriptor + temp_char)+ 1);
  bit_num_char = *(*(font_descriptor + temp_char));
  if(bit_num_char <=8){
	  byte_offset = 1;
  }else if(bit_num_char <= 16){
	  byte_offset = 2;
  }else if(bit_num_char <=24){
	  byte_offset = 3;
  }else{
	  byte_offset = 4;
  }

  //Each character is 32 pixels wide and 31 tall.
  for(i = 0; i < 28; i++) { //31 arial
      char_row = font + (row_offset) + i*byte_offset;//i*4 arial
      bit_num_char_temp = bit_num_char;
    for(k = 0; k < byte_offset; k++){//4 arila
    	if(bit_num_char_temp > 8){
    		j_end = 8;
    		bit_num_char_temp= bit_num_char_temp - 8;
    	}else{
    		j_end = bit_num_char_temp;
    	}
    	for (j = 0; j < j_end; j++) {
    		//If the font table says the pixel in this location is on for this character, then set it.
    		if (*(char_row+k) & (((alt_u8)0x80) >> j)) {
    			//vid_set_pixel((horiz_offset + j + k*8), (vert_offset + i), color); // plot the pixel
    			vid_set_pixel((vert_offset +i), (SCREEN_HEIGHT-horiz_offset - j -k*8), color);
    		}
    	}
    }
  }
  return(0);
}






