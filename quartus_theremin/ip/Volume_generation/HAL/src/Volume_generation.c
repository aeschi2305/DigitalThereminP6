/*----------------------------------------------------
 * File    : VOLUME_GENERATION.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "Volume_generation_regs.h"
#include "Volume_generation.h"

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/


void set_calibration_vol_gen(void)
{
	IOWR_VOLUME_GENERATION_AVALON_VOL_WR_CNTRL(VOLUME_GENERATION_0_BASE,2);
}

alt_u32 done_calibration_vol_gen(void)
{
	return IORD_VOLUME_GENERATION_AVALON_VOL_RD_CNTRL(VOLUME_GENERATION_0_BASE) & 2;
}

void set_vol_gen(alt_u8 vol_bar)
{
	IOWR_VOLUME_GENERATION_AVALON_VOL_WR_VOL_GAIN(VOLUME_GENERATION_0_BASE,(alt_u32)vol_bar);
}


alt_u32 read_freq_vol_gen(void)
{
	return IORD_VOLUME_GENERATION_AVALON_VOL_RD_freq(VOLUME_GENERATION_0_BASE);
}

alt_u32 read_cntrl_vol_gen(void)
{
	return IORD_VOLUME_GENERATION_AVALON_VOL_RD_CNTRL(VOLUME_GENERATION_0_BASE);
}

alt_u32 read_vol_gain_gen(void)
{
	return IORD_VOLUME_GENERATION_AVALON_VOL_RD_vol_gain(VOLUME_GENERATION_0_BASE);	
}