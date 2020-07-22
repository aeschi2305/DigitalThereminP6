/* File    : LT24_Controller.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#ifndef __VOLUME_DUMMY_H__
#define __VOLUME_DUMMY_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "Volume_dummy_regs.h"



#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define VOLUME_DUMMY_INSTANCE(name, device) extern int alt_no_storage
#define VOLUME_DUMMY_INIT(name, device) while (0)

void set_calibration_vol(void);

alt_u32 done_calibration_vol(void);

void set_vol(alt_u8 vol_bar);

alt_u32 read_freq_vol(void);

alt_u32 read_cntrl_vol(void);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
