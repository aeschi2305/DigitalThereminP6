/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "LT24_Controller.h"
#include "LT24_Controller_regs.h"
#include "graphics.h"
#include "alt_video_display.h"
#include "simple_text.h"
#include "arial_24.h"
#include "bahnschriftCondensed_24.h"
#include "bahnschriftCondensed_22.h"
#include "touch_isr.h"
#include "gui.h"

#define RED 0xf800
#define GREEN 0x07e0
#define BLUE 0x001f
#define BLACK  0x0000
#define WHITE 0xffff

typedef enum
 {
	  ST_main,
	  ST_cali,
	  ST_play_help,
	  ST_glissando,
	  ST_display_ton
  }state;

 typedef struct{
	  alt_u16 x_coord;
	  alt_u16 y_coord;
	  alt_u8 enable_xy;
	  alt_u32 next_active_time;
  }XY;
int main()
{
  //initialization
  XY xy;
  xy.x_coord = 0;
  xy.y_coord = 0;
  xy.enable_xy = 0;
  xy.next_active_time= 0;
  alt_u8 cali_enable = 1;
  touch_init(&xy);
  LCD_Init();
  LCD_Clear(WHITE);
  printf("Hello from Nios II!\n");


  alt_u16 xs, ys ,xe, ye;
  int count = 0;
  int enable = 0;

 state state = ST_main;
 draw_main_screen();

while(1){



if(xy.enable_xy == 1){
 xy.enable_xy = 0;

  switch(state){
  	  case ST_main:
  			if(xy.y_coord<=2000){
  				state = ST_cali;
  			    LCD_Clear(WHITE);
  				draw_calibrating_screen();
  				cali_enable = 1;
  			}
  			else if (xy.y_coord>2000){
  				state = ST_play_help;
  				printf("Hello from State Main >2000!\n");
  			}

  		break;

  	  case ST_cali:
  		if(cali_enable == 1){
  			cali_enable = 0;
  			state = ST_main;
  			LCD_Clear(WHITE);
  			draw_main_screen();

  		}
  		printf("Hello from State cali!\n");
  		state = ST_main;
  		break;

  	  case ST_play_help:
  		printf("Hello from State help!\n");
  		state = ST_main;
  	  	break;

  	  case ST_glissando:
  	  	break;

  	  case ST_display_ton:
  	  	break;
  }
}

}
}





