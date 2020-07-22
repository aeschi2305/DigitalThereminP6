/*----------------------------------------------------
 * File    : Volume_dummy.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "Volume_dummy_regs.h"
#include "Volume_dummy.h"

/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/


void set_calibration_vol(void)
{
	IOWR_VOLUME_DUMMY_AVALON_VOL_WR_CNTRL(VOLUME_DUMMY_0_BASE,2);
}

alt_u32 done_calibration_vol(void)
{
	return IORD_VOLUME_DUMMY_AVALON_VOL_RD_CNTRL(VOLUME_DUMMY_0_BASE) & 2;
}

void set_vol(alt_u8 vol_bar)
{
	IOWR_VOLUME_DUMMY_AVALON_VOL_WR_CNTRL(VOLUME_DUMMY_0_BASE,vol_bar);
}


alt_u32 read_freq_vol(void)
{
	return IORD_VOLUME_DUMMY_AVALON_VOL_RD_freq(VOLUME_DUMMY_0_BASE);
}

alt_u32 read_cntrl_vol(void)
{
	return IORD_VOLUME_DUMMY_AVALON_VOL_RD_CNTRL(VOLUME_DUMMY_0_BASE);
}
