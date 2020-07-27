/*----------------------------------------------------
 * File    : simple_text.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "simple_text.h"
#include "LT24_Controller.h"


#define SCREEN_WIDTH	240
#define SCREEN_HEIGHT	320

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






