/*----------------------------------------------------
 * File    : gui.c
 * Author  : Andreas Frei
 * Date    : Aug. 14 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : GUI design of the different menus
 *--------------------------------------------------*/

#include "gui.h"

#define GREY 0x4228//0xBDBD
#define GREY_SOFT 0xCCCC
#define RED 0xf800
#define GREEN 0x07e0
#define BLUE 0x001f
#define BLACK  0x0000
#define WHITE 0xffff
#define WHITE_32 0xffffffff

alt_16 pixel_accuracy_old = 0;


/*----------------------------------------------------
 * Function: void draw_main_screen(void)
 * Purpose : Draws the main screen
 * Return  : none
 *--------------------------------------------------*/
void draw_main_screen(void)
{
	LCD_DrawRect(15,10,75,310,GREY);
	print_string(80,34,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"Calibrate");
	LCD_DrawRect(90,10,150,310,GREY);
	print_string(80,109,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"Volume");
	LCD_DrawRect(165,10,225,310,GREY);
	print_string(80,184,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"Play Help");
}

/*----------------------------------------------------
 * Function: void draw_calibrating_screen(alt_u8 cntrl_reg_pitch, alt_u8 cntrl_reg_vol)
 * Purpose : Draws the calibration screen
 * Return  : none
 *--------------------------------------------------*/
void draw_calibrating_screen(alt_u8 cntrl_reg_pitch, alt_u8 cntrl_reg_vol)
{
	alt_u8 cnt_point = 0;
	print_string(160 - get_string_width("position hands!"),109,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"position hands!");
	usleep(2000000);
	set_calibration_pitch(cntrl_reg_pitch);
	set_calibration_vol_gen(cntrl_reg_vol);
	LCD_Clear(WHITE);

	while(((done_calibration_pitch()&2) == 2 && (done_calibration_vol_gen()&2) == 2) || cnt_point <= 5){
		print_string(160 - get_string_width("calibrating"),50,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"calibrating");
		for(int i = 0; i < cnt_point; i++){
			print_string((138+i*10),100,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,".");
		}
		usleep(1000000);
		cnt_point += 1;
		if (cnt_point > 10){
			cnt_point = 0;
		}
	}
	LCD_Clear(WHITE);
	draw_calibrating_screen_done();

}
/*----------------------------------------------------
 * Function: void draw_calibrating_screen_done(void)
 * Purpose : Draws the calibration screen done
 * Return  : none
 *--------------------------------------------------*/
void draw_calibrating_screen_done(void)
{
	print_string(160 - get_string_width("calibration"),50,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"calibration");
	print_string(160 - get_string_width("done"),100,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"done");
	LCD_DrawRect(170,10,230,110,GREY);
	print_string(244,189,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}

/*----------------------------------------------------
 * Function: void draw_volume_screen(void)
 * Purpose : Draws the volume screen done
 * Return  : none
 *--------------------------------------------------*/
void draw_volume_screen(void)
{
	print_string(10,10,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Volume");
	LCD_DrawRect(39,195,99,310,GREY_SOFT);
	LCD_DrawRect(39,10,99,90,GREY);
	print_string(261,44,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"_");
	LCD_DrawRect(39,100,99,180,GREY);
	print_string(169,55,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"~");

	LCD_DrawRect(175,10,235,110,GREY);
	print_string(249,189,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}

/*----------------------------------------------------
 * Function: void draw_update_volume_bar(alt_u8 vol_bar)
 * Purpose : Draws the volume bar update done
 * Return  : none
 *--------------------------------------------------*/
void draw_update_volume_bar(alt_u8 vol_bar)
{
	alt_u8 i;
	LCD_DrawRect(39,195,99,310,GREY_SOFT);
	for(i = 0; i < vol_bar+1; i++){
		LCD_DrawRect(44,(299-i*6-i*5),94,(299-i*6-i*5+6),GREEN);
	}
}
/*----------------------------------------------------
 * Function: void draw_vol_antenna_on_off(alt_u8 on_off)
 * Purpose : Draws the button antenna vol on off and update
 * Return  : none
 *--------------------------------------------------*/
void draw_vol_antenna_on_off(alt_u8 on_off)
{
	if((on_off & 1) == 1){
		LCD_DrawRect(107,10,167,310,GREEN);
		print_string(15,126,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"vol antenna on");
	}else{
		LCD_DrawRect(107,10,167,310,GREY);
		print_string(15,126,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"vol antenna off");
	}
}
/*----------------------------------------------------
 * Function: void draw_help_screen(void)
 * Purpose : Draws the help screen
 * Return  : none
 *--------------------------------------------------*/
void draw_help_screen(void)
{

	LCD_DrawRect(15,10,75,90,GREY);
	print_string(235,34,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"Set");
	LCD_DrawRect(90,110,150,310,GREY);
	print_string(15,109,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"display pitch");

	LCD_DrawRect(170,10,230,110,GREY);
	print_string(244,189,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");

}
/*----------------------------------------------------
 * Function: void draw_glissando_on_off(alt_u8 on_off)
 * Purpose : Draws the button glissando on off and update
 * Return  : none
 *--------------------------------------------------*/
void draw_glissando_on_off(alt_u8 on_off)
{
	if(on_off == 1){
		LCD_DrawRect(15,110,75,310,GREEN);
		print_string(15,34,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Glissando on");
	}else{
		LCD_DrawRect(15,110,75,310,GREY);
		print_string(15,34,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"Glissando off");
	}
}

/*----------------------------------------------------
 * Function: void draw_glissando_set(void)
 * Purpose : Draws the glissando set screen
 * Return  : none
 *--------------------------------------------------*/
void draw_glissando_set(void)
{
	print_string(10,10,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Delay");
	LCD_DrawRect(39,195,99,310,GREY_SOFT);
	LCD_DrawRect(39,10,99,90,GREY);
	print_string(261,44,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"_");
	LCD_DrawRect(39,100,99,180,GREY);
	print_string(169,55,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"~");

	LCD_DrawRect(175,10,235,110,GREY);
	print_string(244,194,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}
/*----------------------------------------------------
 * Function: void draw_update_glissando_delay(alt_u8 gli_delay)
 * Purpose : Draws the glissando delay screen
 * Return  : none
 *--------------------------------------------------*/
void draw_update_glissando_delay(alt_u8 gli_delay)
{
	alt_u8 i;
	LCD_DrawRect(39,195,99,310,GREY_SOFT);
	for(i = 0; i < gli_delay; i++){
		LCD_DrawRect(44,(299-i*6-i*5),94,(299-i*6-i*5+6),GREEN);
	}
}
/*----------------------------------------------------
 * Function: void draw_penta_on_off(alt_u8 on_off)
 * Purpose : Draws the button penta on off and update
 * Return  : none
 *--------------------------------------------------*/
void draw_penta_on_off(alt_u8 on_off){
	if((on_off & 4) == 4){
		LCD_DrawRect(107,10,167,310,GREEN);
		print_string(15,126,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"pentatonic on");
	}else{
		LCD_DrawRect(107,10,167,310,GREY);
		print_string(15,126,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"pentatonic off");
	}
}
/*----------------------------------------------------
 * Function: void draw_display_ton(alt_u8 cntrl_reg_pitch)
 * Purpose : Draws the display ton screen
 * Return  : none
 *--------------------------------------------------*/
void draw_display_ton(alt_u8 cntrl_reg_pitch)
{
	LCD_Clear(WHITE);
	if((cntrl_reg_pitch & 4) == 4)
	{
		LCD_DrawRect(153,10,155,310,BLACK);
		LCD_DrawRect(60,159,155,161,BLACK);
		LCD_DrawRect(10,130,60,180,WHITE);
		LCD_DrawRect(170,120,230,310,GREEN);
		print_string(20,189,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"penta. on");
	}
	else
	{
		LCD_DrawRect(170,120,230,310,GREY);
		print_string(20,189,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"penta. off");
	}
	LCD_DrawRect(170,10,230,110,GREY);
	print_string(244,189,WHITE_32,&arial_22ptBitmaps,&arial_22ptDescriptors,"@");
}
/*----------------------------------------------------
 * Function: void draw_display_ton_update(alt_u8 cntrl_reg_pitch)
 * Purpose : Draws the display ton update screen
 * Return  : none
 *--------------------------------------------------*/
void draw_display_ton_update(alt_u8 cntrl_reg_pitch)
{
	alt_u32 tmp = read_freq_pitch();
	alt_u8 index = (alt_u8)((tmp & 0xFC000000)>>26);
	alt_u32 freq = tmp & 0xFFFFF;
	alt_u8 index_old;
	alt_16 pixel_accuracy=0;
	alt_16 pixel_accuracy_mean=0;
	char penta_string[21][4] = {{"C#3\0"},{"D#3\0"},{"F#3\0"},{"G#3\0"},{"A#3\0"},{"C#4\0"},{"D#4\0"},{"F#4\0"},{"G#4\0"},{"A#4\0"},{"C#5\0"},{"D#5\0"},{"F#5\0"},{"G#5\0"},{"A#5\0"},{"C#6\0"},{"D#6\0"},{"F#6\0"},{"G#6\0"},{"A#6\0"},{"C#7\0"}};
	char ton_string[49][4] = {{"C3 \0"},{"C#3\0"},{"D3 \0"},{"D#3\0"},{"E3 \0"},{"F3 \0"},{"F#3\0"},{"G3 \0"},{"G#3\0"},{"A3 \0"},{"A#3\0"},{"B3 \0"},{"C4 \0"},{"C#4\0"},{"D4 \0"},{"D#4\0"},{"E4 \0"},{"F4 \0"},{"F#4\0"},{"G4 \0"},{"G#4\0"},{"A4 \0"},{"A#4\0"},{"B4 \0"},{"C5 \0"},{"C#5\0"},{"D5 \0"},{"D#5\0"},{"E5 \0"},{"F5 \0"},{"F#5\0"},{"G5 \0"},{"G#5\0"},{"A5 \0"},{"A#5\0"},{"B5 \0"},{"C6 \0"},{"C#6\0"},{"D6 \0"},{"D#6\0"},{"E6 \0"},{"F6 \0"},{"F#6\0"},{"G6 \0"},{"G#6\0"},{"A6 \0"},{"A#6\0"},{"B6 \0"},{"C7 \0"}};
	char display_string[4];

	printf("freq ton_update %ld\n", freq);

	pixel_accuracy = get_pixel_pitch_accuracy((cntrl_reg_pitch & 4) >> 2,tmp);
	if((freq > 75178) && ((cntrl_reg_pitch & 4) == 4))
	{
		index = 20;
		pixel_accuracy = 150;
	}
	if((freq > 68939) && ((cntrl_reg_pitch & 4) == 0))
	{
		index = 48;
		pixel_accuracy = 150;
	}
	if(index_old != index){
		LCD_DrawRect(10,90,60,200,WHITE);
		if ((cntrl_reg_pitch & 4) == 4 ){

			for(int i = 0; i < 4;i++){
				display_string[i] = penta_string[index][i];
			}
			print_string(160 - get_string_width(penta_string[index]),35,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,&display_string);
		}else{
			for(int i = 0; i < 4;i++){
					display_string[i] = ton_string[index][i];
				}
			print_string(160 - get_string_width(ton_string[index]),35,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,&display_string);
		}
		pixel_accuracy_mean = pixel_accuracy;
	}
	else
	{
		pixel_accuracy_mean = ((pixel_accuracy_mean + pixel_accuracy) >> 1);
	}
	if((cntrl_reg_pitch & 4) == 4)
	{
		//clear cursor
		LCD_DrawRect(133,(160 -pixel_accuracy_old),152,(160 - pixel_accuracy_old+2),WHITE);

		LCD_DrawRect(60,159,155,161,BLACK);
		//draw cursor
		LCD_DrawRect(133,(160 - pixel_accuracy_mean),152,(160 - pixel_accuracy_mean+2),BLACK);
	}
	pixel_accuracy_old = pixel_accuracy_mean;
	index_old = index;
}
