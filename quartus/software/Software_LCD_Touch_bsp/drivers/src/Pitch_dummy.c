/*----------------------------------------------------
 * File    : LT24_Controller.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "Pitch_dummy_regs.h"
#include "Pitch_dummy.h"

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void set_glissando_delay(alt_u8 delay)
{
	IOWR_PITCH_DUMMY_AVALON_PITCH_WR_DELAY(PITCH_DUMMY_0_BASE,(alt_u32)delay);
}

void set_glissando(alt_u8 glissando_on_off)
{
	IOWR_PITCH_DUMMY_AVALON_PITCH_WR_CNTRL(PITCH_DUMMY_0_BASE,glissando_on_off);
}

void set_calibration_pitch(void)
{
	IOWR_PITCH_DUMMY_AVALON_PITCH_WR_CNTRL(PITCH_DUMMY_0_BASE,2);
}

alt_u32 done_calibration_pitch(void)
{
	return IORD_PITCH_DUMMY_AVALON_PITCH_RD_CNTRL(PITCH_DUMMY_0_BASE) & 2;
}


alt_u32 read_freq_pitch(void)
{
	return IORD_PITCH_DUMMY_AVALON_PITCH_RD_freq(PITCH_DUMMY_0_BASE);
}
