/* File    : LT24_Controller.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#ifndef __PITCH_DUMMY_H__
#define __PITCH_DUMMY_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "alt_types.h"
#include "Pitch_dummy_regs.h"

/*
 * Define
 */
#define RED 0xf800
#define GREEN 0x07e0
#define BLUE 0x001f
#define BLACK  0x0000
#define GREY 0xBDBD
#define WHITE 0xffff

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define PITCH_DUMMY_INSTANCE(name, device) extern int alt_no_storage
#define PITCH_DUMMY_INIT(name, device) while (0)


void set_glissando_delay(alt_u8 delay);

void set_glissando(alt_u8 glissando_on_off);

void set_calibration_pitch(void);

alt_u32 done_calibration_pitch(void);

alt_u32 read_freq_pitch(void);

alt_u32 read_delay_gli(void);



#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
