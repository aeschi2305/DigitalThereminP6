/* File    : audio.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#ifndef __AUDIO_H__
#define __AUDIO_H__

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <altera_up_avalon_audio_and_video_config.h>
#include "system.h"
#include "stdio.h"
#include "alt_types.h"




#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define altera_up_avalon_audio_and_video_config_INSTANCE(name, device) extern int alt_no_storage
#define altera_up_avalon_audio_and_video_config_INIT(name, device) while (0)

void codec_wm8731_init(void);

void set_vol(alt_u32 vol_gain);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __LT24_CONTROLLER_H__ */
