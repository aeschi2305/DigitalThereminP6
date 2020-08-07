/* File    : LT24_Controller.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#ifndef __PITCH_GENERATION_H__
#define __PITCH_GENERATION_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "Pitch_generation_regs.h"

/*
 * Define
 */


#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define PITCH_GENERATION_INSTANCE(name, device) extern int alt_no_storage
#define PITCH_GENERATION_INIT(name, device) while (0)


void set_glissando_delay(alt_u8 delay);

void set_cntrl_reg(alt_u8 cntrl_reg);

void set_calibration_pitch(alt_u8 cntrl_reg_pitch);

alt_u32 done_calibration_pitch(void);

alt_u32 read_freq_pitch(void);

alt_u32 read_delay_gli(void);

alt_16 get_pixel_pitch_accuracy(alt_u8 penta_on_off, alt_u32 tmp);



#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
