/*----------------------------------------------------
 * File    : Volume_generation.h
 * Author  : Andreas Frei
 * Date    : 14.08.2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#ifndef __VOLUME_GENERATION_H__
#define __VOLUME_GENERATION_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "volume_generation_regs.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define VOLUME_GENERATION_INSTANCE(name, device) extern int alt_no_storage
#define VOLUME_GENERATION_INIT(name, device) while (0)
/*----------------------------------------------------
 * Function: void set_calibration_vol_gen(alt_u8 cntrl_reg_vol)
 * Purpose : set the vol generation calibration in the control register
 * Return  : none
 *--------------------------------------------------*/
void set_calibration_vol_gen(alt_u8 cntrl_reg_vol);
/*----------------------------------------------------
 * Function: alt_u32 done_calibration_vol_gen(void)
 * Purpose : checks if the calibration has been done
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 done_calibration_vol_gen(void);
/*----------------------------------------------------
 * Function: void set_vol_gen(alt_u8 vol_bar)
 * Purpose : to set the vol gain
 * Return  : none
 *--------------------------------------------------*/
void set_vol_gen(alt_u8 vol_bar);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __VOLUME_GENERATION_H__*/
