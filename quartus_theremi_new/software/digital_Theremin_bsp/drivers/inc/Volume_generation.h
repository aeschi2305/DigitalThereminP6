/* File    : LT24_Controller.h
 * Author  :
 * Date    :
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

void set_calibration_vol_gen(alt_u8 cntrl_reg_vol);

alt_u32 done_calibration_vol_gen(void);

void set_vol_gen(alt_u8 vol_bar);





#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __VOLUME_GENERATION_H__*/
