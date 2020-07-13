/*----------------------------------------------------
 * File    : graphics.c
 * Author  :
 * Date    : Dec 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "LT24_Controller_regs.h"
#include "graphics.h"
#include "LT24_Controller.h"

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void Delay_Ms_1(alt_u16 count_ms)
{
    while(count_ms--)
    {
        usleep(1000);
    }
}

/*----------------------------------------------------
 * Function: draw_horiz_line
 * Purpose : Drawing horizontal line
 * Return  : none
 *--------------------------------------------------*/

void draw_horiz_line (alt_u16 Hstart, alt_u16 Hend, alt_u16 V, alt_u16 color)
{
	int x;
	for(x=Hstart;x<Hend;x++){

		LCD_DrawPoint(x, V, color);
	}
}

/*----------------------------------------------------
 * Function: draw_sloped_line
 * Purpose : Drawing sloped line
 * Return  : none
 *--------------------------------------------------*/

void draw_sloped_line( alt_u16 horiz_start,
                           alt_u16 vert_start,
                           alt_u16 horiz_end,
                           alt_u16 vert_end,
                           alt_u16 width,
                           alt_u16 color)
{
  // Find the vertical and horizontal distance between the two points
  int horiz_delta = abs(horiz_end-horiz_start);
  int vert_delta = abs(vert_end-vert_start);

  // Find out what direction we are going
  int horiz_incr, vert_incr;
  if (horiz_start > horiz_end) { horiz_incr=-1; } else { horiz_incr=1; }
  if (vert_start > vert_end) { vert_incr=-1; } else { vert_incr=1; }

  // Find out which axis is always incremented when drawing the line
  // If it's the horizontal axis
  if (horiz_delta >= vert_delta) {
    int dPr   = vert_delta<<1;
    int dPru  = dPr - (horiz_delta<<1);
    int P     = dPr - horiz_delta;

    // Process the line, one horizontal point at at time
    for (; horiz_delta >= 0; horiz_delta--) {
      // plot the pixel
    	LCD_DrawPoint(horiz_start, vert_start, color);
      // If we're moving both up and right
      if (P > 0) {
        horiz_start+=horiz_incr;
        vert_start+=vert_incr;
        P+=dPru;
      } else {
        horiz_start+=horiz_incr;
        P+=dPr;
      }
    }
  // If it's the vertical axis
  } else {
    int dPr   = horiz_delta<<1;
    int dPru  = dPr - (vert_delta<<1);
    int P     = dPr - vert_delta;

    // Process the line, one vertical point at at time
    for (; vert_delta>=0; vert_delta--) {
      // plot the pixel
    	LCD_DrawPoint(horiz_start, vert_start, color);
      // If we're moving both up and right
      if (P > 0) {
        horiz_start+=horiz_incr;
        vert_start+=vert_incr;
        P+=dPru;
      } else {
        vert_start+=vert_incr;
        P+=dPr;
      }
    }
  }
}

/*----------------------------------------------------
 * Function: draw_line
 * Purpose : Drawing line
 * Return  : none
 *--------------------------------------------------*/


void draw_line(alt_u16 horiz_start, alt_u16 vert_start, alt_u16 horiz_end, alt_u16 vert_end, alt_u16 width, alt_u16 color)
{

  if( vert_start == vert_end )
  {

    draw_horiz_line( horiz_start,
                         horiz_end,
                         vert_start,
                         color);
  }
  else
  {
    draw_sloped_line( horiz_start,
                          vert_start,
                          horiz_end,
                          vert_end,
                          width,
                          color);

  }
}

/*----------------------------------------------------
 * Function: paint_block
 * Purpose : Draws a block and fills it in
 * Return  : none
 *--------------------------------------------------*/

void paint_block (alt_u16 Hstart,alt_u16 Vstart, alt_u16 Hend, alt_u16 Vend, alt_u16 color)
{
	int x,y;
	for(y=Vstart;y<Vend;y++){
		for(x=Hstart;x<Hend;x++){
			LCD_DrawPoint(x, y, color);
		}
	}
}

/*----------------------------------------------------
 * Function: drow_box
 * Purpose : A filled or empty box can be drawn
 * Return  : none
 *--------------------------------------------------*/
int draw_box (alt_u16 horiz_start, alt_u16 vert_start, alt_u16 horiz_end, alt_u16 vert_end, alt_u16 color, int fill)
{

  // If we want to fill in our box
  if (fill) {
     paint_block (horiz_start, vert_start, horiz_end, vert_end, color);
  // If we're not filling in the box, just draw four lines.
  } else {
    draw_line(horiz_start, vert_start, horiz_start, vert_end-1, 1, color);
    draw_line(horiz_end-1, vert_start, horiz_end-1, vert_end-1, 1, color);
    draw_line(horiz_start, vert_start, horiz_end-1, vert_start, 1, color);
    draw_line(horiz_start, vert_end-1, horiz_end-1, vert_end-1, 1, color);
  }

  return (0);
}




