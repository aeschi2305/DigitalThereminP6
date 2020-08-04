/*----------------------------------------------------
 * File    : audio.c
 * Author  :
 * Date    : Jun 18 2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/

#include "audio.h"
#include "system.h"


alt_up_av_config_dev *i2c_dev; //Each instance of the driver uses one of these structures to hold its associated state.
alt_u8 cnt_zero;
alt_u8 zero_cross;
/*----------------------------------------------------
 * Function:
 * Purpose :
 * Return  : none
 *--------------------------------------------------*/

void codec_wm8731_init(void)
{
	i2c_dev = alt_up_av_config_open_dev("/dev/audio_and_video_config_0");//Opens the Audio/Video Configuration device specified by name
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x0F,0x000); //Reset
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x00,0x01A); //Left Line In Enable Mute 80
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x01,0x01A); //Right Line In Enable Mute
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x02,0x15B); //12FLeft Headphone Out mute Enable Simultaneous Load of LHPVOL[6:0] and LZCEN to RHPVOL[6:0] and RZCEN, zero crossing
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x03,0x15B); //Left Headphone Out mute Enable Simultaneous Load of LHPVOL[6:0] and LZCEN to RHPVOL[6:0] and RZCEN, zero crossing
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x04,0x010); //Analogue Audio Path Control DAC select
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x05,0x007);//DAC Path Control enable high pass filter, 48kHz
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x06,0x000); //Power Down Control enable Power Down for line input, mic input & ADC
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x07,0x079); //Digital Audio Interface Format Left Justified,  Right Channel DAC Data Left, enable Master Mode
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x08,0x001); //Sampling Control USB Mode 250fs
	alt_up_av_config_write_audio_cfg_register(i2c_dev,0x09,0x001); //activat DIGITAL AUDIO INTERFACE
}

void set_vol(alt_u32 vol_gain)
{
	int vol_gain_tmp = vol_gain;
	if(vol_gain_tmp == 0 && cnt_zero < 5)
	{
		cnt_zero++;
	}
	else if(vol_gain_tmp != 0)
	{
		if(zero_cross)
		{
			alt_up_av_config_write_audio_cfg_register(i2c_dev,0x02,((alt_u8)vol_gain_tmp + 47) | 256); //384
		}
		else
		{
			alt_up_av_config_write_audio_cfg_register(i2c_dev,0x02,((alt_u8)vol_gain_tmp + 47) | 256);
			zero_cross = 1;
		}
	}
	else
	{
		alt_up_av_config_write_audio_cfg_register(i2c_dev,0x02,256);
		zero_cross = 0;
		cnt_zero = 0;
	}
}
