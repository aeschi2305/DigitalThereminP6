/*----------------------------------------------------
 * File    : gui.h
 * Author  : Andreas Frei
 * Date    : Aug. 14 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : GUI design of the different menus
 *--------------------------------------------------*/
#ifndef __GUI_H__
#define __GUI_H__

#include <stdio.h>
#include <unistd.h>
#include <system.h>
#include <sys/alt_irq.h>
#include "LT24_Controller.h"
#include "simple_text.h"
#include "pitch_generation.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*----------------------------------------------------
 * Function: void draw_main_screen(void)
 * Purpose : Draws the main screen
 * Return  : none
 *--------------------------------------------------*/
void draw_main_screen(void);
/*----------------------------------------------------
 * Function: void draw_calibrating_screen(alt_u8 cntrl_reg_pitch, alt_u8 cntrl_reg_vol)
 * Purpose : Draws the calibration screen
 * Return  : none
 *--------------------------------------------------*/
void draw_calibrating_screen(alt_u8 cntrl_reg_pitch, alt_u8 cntrl_reg_vol);
/*----------------------------------------------------
 * Function: void draw_calibrating_screen_done(void)
 * Purpose : Draws the calibration screen done
 * Return  : none
 *--------------------------------------------------*/
void draw_calibrating_screen_done(void);
/*----------------------------------------------------
 * Function: void draw_volume_screen(void)
 * Purpose : Draws the volume screen done
 * Return  : none
 *--------------------------------------------------*/
void draw_volume_screen(void);
/*----------------------------------------------------
 * Function: void draw_update_volume_bar(alt_u8 vol_bar)
 * Purpose : Draws the volume bar update done
 * Return  : none
 *--------------------------------------------------*/
void draw_update_volume_bar(alt_u8 vol_bar);
/*----------------------------------------------------
 * Function: void draw_vol_antenna_on_off(alt_u8 on_off)
 * Purpose : Draws the button antenna vol on off and update
 * Return  : none
 *--------------------------------------------------*/
void draw_vol_antenna_on_off(alt_u8 on_off);
/*----------------------------------------------------
 * Function: void draw_help_screen(void)
 * Purpose : Draws the help screen
 * Return  : none
 *--------------------------------------------------*/
void draw_help_screen(void);
/*----------------------------------------------------
 * Function: void draw_glissando_on_off(alt_u8 on_off)
 * Purpose : Draws the button glissando on off and update
 * Return  : none
 *--------------------------------------------------*/
void draw_glissando_on_off(alt_u8 on_off);
/*----------------------------------------------------
 * Function: void draw_glissando_set(void)
 * Purpose : Draws the glissando set screen
 * Return  : none
 *--------------------------------------------------*/
void draw_glissando_set(void);
/*----------------------------------------------------
 * Function: void draw_update_glissando_delay(alt_u8 gli_delay)
 * Purpose : Draws the glissando delay screen
 * Return  : none
 *--------------------------------------------------*/
void draw_update_glissando_delay(alt_u8 gli_delay);
/*----------------------------------------------------
 * Function: void draw_penta_on_off(alt_u8 on_off)
 * Purpose : Draws the button penta on off and update
 * Return  : none
 *--------------------------------------------------*/
void draw_penta_on_off(alt_u8 on_off);
/*----------------------------------------------------
 * Function: void draw_display_ton(alt_u8 cntrl_reg_pitch)
 * Purpose : Draws the display ton screen
 * Return  : none
 *--------------------------------------------------*/
void draw_display_ton(alt_u8 cntrl_reg_pitch);
/*----------------------------------------------------
 * Function: void draw_display_ton_update(alt_u8 cntrl_reg_pitch)
 * Purpose : Draws the display ton update screen
 * Return  : none
 *--------------------------------------------------*/
void draw_display_ton_update(alt_u8 penta_on_off);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
