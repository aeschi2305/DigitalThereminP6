/*----------------------------------------------------
 * File    : pitch_generation.h
 * Author  : Dennis Aeschbacher & Andreas Frei
 * Date    : 14.08.2020
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

/*----------------------------------------------------
 * Function: void set_glissando_delay(alt_u8 delay)
 * Purpose : to set glissando delay in the 
 *			 glissando delay register
 * Return  : none
 *--------------------------------------------------*/
void set_glissando_delay(alt_u8 delay);
/*----------------------------------------------------
 * Function: void set_cntrl_reg(alt_u8 cntrl_reg)
 * Purpose : to set the controll register
 * Return  : none
 *--------------------------------------------------*/
void set_cntrl_reg(alt_u8 cntrl_reg);
/*----------------------------------------------------
 * Function: void set_calibration_pitch(alt_u8 cntrl_reg_pitch)
 * Purpose : to set the calibration for the pitch antenna
 *           in the control register
 * Return  : none
 *--------------------------------------------------*/
void set_calibration_pitch(alt_u8 cntrl_reg_pitch);
/*----------------------------------------------------
 * Function: alt_u32 done_calibration_pitch(void)
 * Purpose : checks if the calibration has been done
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 done_calibration_pitch(void);
/*----------------------------------------------------
 * Function: alt_u32 read_freq_pitch(void)
 * Purpose : reads the frequency of the pitch antenna
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 read_freq_pitch(void);
/*----------------------------------------------------
 * Function: alt_u32 read_delay_gli(void)
 * Purpose : reads the glissando delay
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 read_delay_gli(void);
/*----------------------------------------------------
 * Function: alt_16 get_pixel_pitch_accuracy(alt_u8 penta_on_off, alt_u32 tmp)
 * Purpose : is used in the display pitch mode to draw 
 *           the cursor. The pass parameters must indicate 
             whether the pentatonic scale is active. 
             Additionally the value of the freq data 
             register must be passed. The function 
             calculates a ratio from the current 
             frequency (freq) and the distance to the 
             next tone, which is then converted into a 
             pixel value.
 * Return  : alt_16
 *--------------------------------------------------*/
alt_16 get_pixel_pitch_accuracy(alt_u8 penta_on_off, alt_u32 tmp);



#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
