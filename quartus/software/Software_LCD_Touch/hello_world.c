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
#include "sys/alt_alarm.h"

#define RED 0xf800
#define GREEN 0x07e0
#define BLUE 0x001f
#define BLACK  0x0000
#define WHITE 0xffff
#define GREY 0xBDBD
#define ACTIVE_DELAY_TIME_1   (alt_ticks_per_second()/60)

alt_alarm my_alarm;
alt_u32 ton_delay = 0;

typedef enum
 {
	  ST_main,
	  ST_cali,
	  ST_volume,
	  ST_play_help,
	  ST_glissando_set,
	  ST_display_ton
  }state;

typedef struct{
	  alt_u16 x_coord;
	  alt_u16 y_coord;
	  alt_u8 enable_xy;
	  alt_u32 next_active_time;
  }XY;

//  callback function for alarm
 alt_u32 alarm_callback (void* context)
  {
  	//Set alarm flag
  	printf ("ALARM!!!\n");
  	draw_display_ton_update();

  	return context = 1000;
  }
int main()
{
  //initialization
  XY xy;
  xy.x_coord = 0;
  xy.y_coord = 0;
  xy.enable_xy = 0;
  xy.next_active_time= 0;
  alt_u8 cali_enable = 1;
  alt_u8 vol_bar = 0;
  alt_u8 glissando_on_off = 0;
  alt_u8  glissando_delay = 30;
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
  			if(xy.y_coord<=1400){
  				state = ST_cali;
  			    LCD_Clear(WHITE);
  				draw_calibrating_screen();
  				cali_enable = 1;
  				usleep(1000000);
  	  			LCD_Clear(WHITE);
  	  			draw_calibrating_screen_done();
  			}
  			else if (xy.y_coord<=2800){
  				state = ST_volume;
  				LCD_Clear(WHITE);
  				draw_volume_screen();
  				draw_update_volume_bar(vol_bar);
  			}
  			else if (xy.y_coord>2800){
  				state = ST_play_help;
  				LCD_Clear(WHITE);
  				draw_help_screen();
  				draw_glissando_on_off(glissando_on_off);
  			}
  		break;

  	  case ST_volume:
  		if((xy.y_coord >= 2800) && (xy.x_coord<=1100)){
  			state = ST_main;
  		  	LCD_Clear(WHITE);
  		  	draw_main_screen();
  		}else if((xy.y_coord <= 2050) && (xy.x_coord<=700)){
  			if(vol_bar <= 0){
  			  vol_bar = 1;
  			}
  			vol_bar --;
  			draw_update_volume_bar(vol_bar);
  		}else if((xy.y_coord <= 2050) && (xy.x_coord>=1300)){
  			vol_bar ++;
  			if(vol_bar >= 10){
  				vol_bar = 10;
  			}
  			draw_update_volume_bar(vol_bar);
  		}


  	  	break;

  	  case ST_cali:
  		if(cali_enable == 1){
  			if((xy.y_coord >= 2800) && (xy.x_coord<=1100)){
  				cali_enable = 0;
  				state = ST_main;
  				LCD_Clear(WHITE);
  				draw_main_screen();
  			}
  		}
  		break;

  	  case ST_play_help:
  		if((xy.y_coord >= 2800) && (xy.x_coord<=1100)){
  			state = ST_main;
  			LCD_Clear(WHITE);
  			draw_main_screen();
  		}else if((xy.y_coord <= 1200) && (xy.x_coord>=1300)){
  			draw_glissando_on_off(glissando_on_off ^ 0x01);
  			glissando_on_off = glissando_on_off ^ 0x01;
  		}else if((xy.y_coord <= 1200) && (xy.x_coord<=1300)){
  			state = ST_glissando_set;
  			LCD_Clear(WHITE);
  			draw_glissando_set();
  			draw_update_glissando_delay(glissando_delay);
  		}else if((xy.y_coord >= 1200) && (xy.x_coord>=1300)){
  			state = ST_display_ton;
  			//Configure alarm for 1 seconds
  			if (alt_alarm_start(&my_alarm,1000, alarm_callback, NULL) < 0){
  				printf ("No System Clock Available\n");
  			}
  			LCD_Clear(WHITE);
  			draw_display_ton();
  		}
  	  	break;

  	  case ST_glissando_set:
  		if((xy.y_coord >= 2800) && (xy.x_coord<=1100)){
  			state = ST_play_help;
  			LCD_Clear(WHITE);
  			draw_help_screen();
  			draw_glissando_on_off(glissando_on_off);
  		}else if((xy.y_coord <= 2050) && (xy.x_coord<=700)){
  			if(glissando_delay <= 20){
  				glissando_delay = 30;
  			}
  			glissando_delay = glissando_delay - 10;
  			draw_update_glissando_delay(glissando_delay);
  		}else if((xy.y_coord <= 2050) && (xy.x_coord>=1300)){
  			glissando_delay = glissando_delay + 10;
  			draw_update_glissando_delay(glissando_delay);
  		}
  	  	break;

  	  case ST_display_ton:
  		if((xy.y_coord >= 2800) && (xy.x_coord<=1100)){
  			state = ST_play_help;
  			LCD_Clear(WHITE);
  		  	draw_help_screen();
  		  	draw_glissando_on_off(glissando_on_off);
  		  	alt_alarm_stop(&my_alarm);
  		}
  	  	break;
  }
}


}
}





