/*----------------------------------------------------
 * File    : gui.c
 * Author  :
 * Date    : Dec 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/

#include "gui.h"

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_main_screen(void)
{
	LCD_DrawRect(10,10,110,310,GREEN);
	vid_print_string(80,50,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Kalibrieren");
	LCD_DrawRect(130,10,230,310,GREEN);
	vid_print_string(80,170,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"Hilfseffekt");
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void draw_calibrating_screen(void)
{

	vid_print_string(80,50,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"calibrating");
	vid_print_string(150,150,BLACK,&arial_22ptBitmaps,&arial_22ptDescriptors,"...");
	LCD_DrawRect(145,5,230,95,BLUE);
	LCD_DrawRect(150,10,225,90,GREEN);

}
