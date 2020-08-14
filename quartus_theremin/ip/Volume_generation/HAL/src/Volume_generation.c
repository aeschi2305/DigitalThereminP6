/*----------------------------------------------------
 * File    : Volume_generation.c
 * Author  : Andreas Frei
 * Date    : 14.08.2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "Volume_generation_regs.h"
#include "Volume_generation.h"

/*----------------------------------------------------
 * Function: void set_calibration_vol_gen(alt_u8 cntrl_reg_vol)
 * Purpose : set the vol generation calibration in the control register
 * Return  : none
 *--------------------------------------------------*/
void set_calibration_vol_gen(alt_u8 cntrl_reg_vol)
{
	IOWR_VOLUME_GENERATION_AVALON_VOL_WR_CNTRL(VOLUME_GENERATION_0_BASE,(alt_u32) cntrl_reg_vol);
}
/*----------------------------------------------------
 * Function: alt_u32 done_calibration_vol_gen(void)
 * Purpose : checks if the calibration has been done
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 done_calibration_vol_gen(void)
{
	return IORD_VOLUME_GENERATION_AVALON_VOL_RD_CNTRL(VOLUME_GENERATION_0_BASE) & 2;
}
/*----------------------------------------------------
 * Function: void set_vol_gen(alt_u8 vol_bar)
 * Purpose : to set the vol gain
 * Return  : none
 *--------------------------------------------------*/
void set_vol_gen(alt_u8 vol_bar)
{
	IOWR_VOLUME_GENERATION_AVALON_VOL_WR_CNTRL(VOLUME_GENERATION_0_BASE,(alt_u32)vol_bar);
}

