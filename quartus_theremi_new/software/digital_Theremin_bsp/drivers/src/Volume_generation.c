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


void set_calibration_vol_gen(alt_u8 cntrl_reg_vol)
{
	IOWR_VOLUME_GENERATION_AVALON_VOL_WR_CNTRL(VOLUME_GENERATION_0_BASE,(alt_u32) cntrl_reg_vol);
}

alt_u32 done_calibration_vol_gen(void)
{
	return IORD_VOLUME_GENERATION_AVALON_VOL_RD_CNTRL(VOLUME_GENERATION_0_BASE) & 2;
}

void set_vol_gen(alt_u8 vol_bar)
{
	IOWR_VOLUME_GENERATION_AVALON_VOL_WR_CNTRL(VOLUME_GENERATION_0_BASE,(alt_u32)vol_bar);
}

