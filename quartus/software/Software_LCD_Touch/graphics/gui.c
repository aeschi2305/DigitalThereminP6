/*----------------------------------------------------
 * File    : gui.c
 * Author  :
 * Date    : Dec 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/

#include "gui.h"
#define GREY 0xBDBD
#define GREY_SOFT 0xCCCC

alt_u8 cnt_ton = 0;
/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_main_screen(void)
{
	LCD_DrawRect(15,10,75,310,GREY);
	vid_print_string(80,34,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Kalibrieren");
	LCD_DrawRect(90,10,150,310,GREY);
	vid_print_string(80,109,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Volume");
	LCD_DrawRect(165,10,225,310,GREY);
	vid_print_string(80,184,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Hilfseffekt");
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_calibrating_screen(void)
{
	vid_print_string(80,50,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"calibrating");
	vid_print_string(150,100,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"...");
}

void draw_calibrating_screen_done(void)
{
	vid_print_string(80,50,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"calibrating");
	vid_print_string(150,100,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"done");
	LCD_DrawRect(170,10,230,110,GREY);
	vid_print_string(244,189,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_volume_screen(void)
{
	vid_print_string(10,25,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Volume");
	LCD_DrawRect(55,10,115,90,GREY);
	vid_print_string(260,60,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"_");
	LCD_DrawRect(55,100,115,180,GREY);
	vid_print_string(175,74,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"+");

	LCD_DrawRect(170,10,230,110,GREY);
	vid_print_string(244,189,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}

void draw_update_volume_bar(alt_u8 vol_bar)
{
	alt_u8 i;
	LCD_DrawRect(55,195,115,310,GREY_SOFT);
	for(i = 0; i < vol_bar; i++){
		LCD_DrawRect(60,(299-i*6-i*5),110,(299-i*6-i*5+6),GREEN);
	}
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_help_screen(void)
{

	LCD_DrawRect(15,10,75,90,GREY);
	vid_print_string(235,34,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Set");
	LCD_DrawRect(90,110,150,310,GREY);
	vid_print_string(15,109,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Anzeige Ton");

	LCD_DrawRect(170,10,230,110,GREY);
	vid_print_string(244,189,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");

}

void draw_glissando_on_off(alt_u8 on_off){
	if(on_off == 1){
		LCD_DrawRect(15,110,75,310,GREEN);
		vid_print_string(15,34,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Glissando on");
	}else{
		LCD_DrawRect(15,110,75,310,GREY);
		vid_print_string(15,34,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Glissando off");
	}
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_glissando_set(void)
{
	vid_print_string(10,25,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Delay");
	LCD_DrawRect(55,195,115,310,GREY_SOFT);
	LCD_DrawRect(55,10,115,90,GREY);
	vid_print_string(260,60,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"_");
	LCD_DrawRect(55,100,115,180,GREY);
	vid_print_string(175,74,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"+");

	LCD_DrawRect(170,10,230,110,GREY);
	vid_print_string(244,189,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}

void draw_update_glissando_delay(alt_u8 gli_delay)
{
	LCD_DrawRect(55,195,115,310,GREY_SOFT);
	char gli_delay_str[3];
	sprintf(gli_delay_str,"%d ms",gli_delay);
	vid_print_string(15,74,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,gli_delay_str);
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_display_ton(void)
{
	LCD_DrawRect(153,10,155,310,BLACK);
	LCD_DrawRect(60,159,155,161,BLACK);
	LCD_DrawRect(10,130,60,180,WHITE);
	vid_print_string(149,38,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"C#");
	LCD_DrawRect(170,10,230,110,GREY);
	vid_print_string(244,189,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}
void draw_display_ton_update(void)
{
	//char gli_delay_str[3];
	//sprintf(gli_delay_str,"%d ms",cnt_ton);
	LCD_DrawRect(10,130,60,180,WHITE);
	vid_print_string(149,38,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"AH");
	cnt_ton ++;
	if(cnt_ton>=6){
		cnt_ton = 0;
	}
	printf ("ton update\n");
}
