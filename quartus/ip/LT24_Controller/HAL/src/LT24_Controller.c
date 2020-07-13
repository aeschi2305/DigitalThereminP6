/*----------------------------------------------------
 * File    : LT24_Controller.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "LT24_Controller_regs.h"
#include "LT24_Controller.h"



/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/
void Delay_Ms(alt_u16 count_ms)
{
    while(count_ms--)
    {
        usleep(1000);
    }
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void LCD_SetCursor(alt_u16 Xpos, alt_u16 Ypos)
{
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002A);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Xpos>>8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Xpos&0XFF);
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002B);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Ypos>>8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Ypos&0XFF);
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002C);

}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void LCD_SetRect(alt_u16 Xposstart, alt_u16 Yposstart,alt_u16 Xposend, alt_u16 Yposend)
{
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002A);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Xposstart>>8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Xposstart&0XFF);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Xposend>>8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Xposend&0XFF);
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002B);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Yposstart>>8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Yposstart&0XFF);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Yposend>>8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Yposend&0XFF);
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002C);

}
/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void LCD_Clear(alt_u16 Color)
{
        alt_u32 index=0;
        LCD_SetCursor(0x00,0x0000);
        IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002C);
        for(index=0;index<76800;index++)
        {
        	IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,Color);
        }
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void LCD_DrawPoint(alt_u16 x,alt_u16 y,alt_u16 color )
{
        LCD_SetCursor(x,y);
        IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002C);
        IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,color);
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void LCD_DrawRect(alt_u16 xs,alt_u16 ys,alt_u16 xe,alt_u16 ye,alt_u16 color )
{
        LCD_SetRect(xs,ys,xe,ye);
        IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002C);
        for(int i = 0; i < (xe-xs)*(ye-ys);i++){
        	IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,color);
        }

}


void vid_set_pixel(int horiz, int vert, unsigned int color)
{

	alt_u16 color16;


	// encode to RGB  5 6 5
	color16 = (color & 0xFF) >> 3; // blue
	color16 |= (color & 0xFC00) >> 5; // green
	color16 |= (color & 0xF80000) >> 8; // blue
	LCD_DrawPoint(horiz, vert, color16);
}

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void LCD_Init()
{
	alt_u16 data1,data2;
	alt_u16 data3,data4;

	IOWR_LT24_AVALON_Set_LCD_RST(LCD_RESET_N_BASE); //	Set_LCD_RST;
	Delay_Ms(1);
	IOWR_LT24_AVALON_Clr_LCD_RST(LCD_RESET_N_BASE);
	Delay_Ms(10);       // Delay 10ms // This delay time is necessary
	IOWR_LT24_AVALON_Set_LCD_RST(LCD_RESET_N_BASE); //	Set_LCD_RST;
	Delay_Ms(120);       // Delay 120 ms
//	Clr_LCD_CS;


	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x0011);//Exit Sleep
	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00CF);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0081);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0X00c0);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00ED);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0064);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0003);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0X0012);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0X0081);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00E8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0085);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0001);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x00798);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00CB);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0039);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x002C);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0034);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0002);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00F7);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0020);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00EA);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00B1);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x001b);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00B6);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000A);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x00A2);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00C0); //Power control
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0005);  //VRH[5:0]

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00C1); //Power control
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0011);  //SAP[2:0];BT[3:0]

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00C5); //VCM control
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0045);  //3F
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0045);  //3C

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00C7); //VCM control2
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0X00a2);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x0036); // Memory Access Control
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0008);//48

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00F2);  // 3Gamma Function Disable
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x0026);  //Gamma curve selected
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0001);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00E0);  //Set Gamma
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000F);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0026);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0024);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000b);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000E);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0008);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x004b);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0X00a8);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x003b);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000a);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0014);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0006);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0010);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0009);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0X00E1);  //Set Gamma
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x001c);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0020);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0004);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0010);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0008);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0034);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0047);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0044);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0005);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000b);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0009);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x002f);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0036);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x000f);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002A);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x00ef);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002B);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0001);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x003f);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x003A);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0055);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x00f6);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0001);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0030);
		IOWR_LT24_AVALON_LCD_WR_DATA(LCD_CONTROLLER_BASE,0x0000);

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x0029);  //display on

	IOWR_LT24_AVALON_LCD_WR_REG(LCD_CONTROLLER_BASE,0x002c);  // 0x2C


}
