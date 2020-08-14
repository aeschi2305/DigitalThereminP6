/*----------------------------------------------------
 * File    : Pitch_generation.c
 * Author  : Dennis Aeschbacher & Andreas Frei
 * Date    : 14.08.2020
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#include "system.h"
#include "stdio.h"
#include "Pitch_generation_regs.h"
#include "Pitch_generation.h"

/*----------------------------------------------------
 * Function: void set_glissando_delay(alt_u8 delay)
 * Purpose : to set glissando delay in the 
 *			 glissando delay register
 * Return  : none
 *--------------------------------------------------*/

void set_glissando_delay(alt_u8 delay)
{
	IOWR_PITCH_GENERATION_AVALON_PITCH_WR_DELAY(PITCH_GENERATION_0_BASE,(alt_u32)delay);
}
/*----------------------------------------------------
 * Function: void set_cntrl_reg(alt_u8 cntrl_reg)
 * Purpose : to set the control register
 * Return  : none
 *--------------------------------------------------*/
void set_cntrl_reg(alt_u8 cntrl_reg)
{
	IOWR_PITCH_GENERATION_AVALON_PITCH_WR_CNTRL(PITCH_GENERATION_0_BASE,(alt_u32)cntrl_reg);
}
/*----------------------------------------------------
 * Function: void set_calibration_pitch(alt_u8 cntrl_reg_pitch)
 * Purpose : to set the calibration for the pitch antenna
 *           in the control register
 * Return  : none
 *--------------------------------------------------*/
void set_calibration_pitch(alt_u8 cntrl_reg_pitch)
{
	IOWR_PITCH_GENERATION_AVALON_PITCH_WR_CNTRL(PITCH_GENERATION_0_BASE,(alt_u32) cntrl_reg_pitch);
}
/*----------------------------------------------------
 * Function: alt_u32 done_calibration_pitch(void)
 * Purpose : checks if the calibration has been done
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 done_calibration_pitch(void)
{
	return IORD_PITCH_GENERATION_AVALON_PITCH_RD_CNTRL(PITCH_GENERATION_0_BASE) & 2;
}
/*----------------------------------------------------
 * Function: alt_u32 read_freq_pitch(void)
 * Purpose : reads the frequency of the pitch antenna
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 read_freq_pitch(void)
{
	return IORD_PITCH_GENERATION_AVALON_PITCH_RD_freq(PITCH_GENERATION_0_BASE);
}
/*----------------------------------------------------
 * Function: alt_u32 read_delay_gli(void)
 * Purpose : reads the glissando delay
 * Return  : alt_u32
 *--------------------------------------------------*/
alt_u32 read_delay_gli(void)
{
	return IORD_PITCH_GENERATION_AVALON_PITCH_RD_gli_delay(PITCH_GENERATION_0_BASE);
}
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
alt_16 get_pixel_pitch_accuracy(alt_u8 penta_on_off, alt_u32 tmp)
{
	alt_32 freq_diff_calc = 0;
    alt_32  freq;
	alt_32	index;
	freq = (alt_32)(tmp & 0xFFFF); //Masks the frequency from the freq data register
	index = (alt_32)((tmp & 0xFC000000)>>26); //Masks the index from the freq data register
	/* The following arrays store the values of the threshold to the next tones 
	   for the normal and the pentatonic  scale.
	   alt_32 freq_diff [49][2]       => thresholds for the normal scale
	   alt_32 freq_int [49]           => frequencies of the normal scale
	   alt_32 freq_penta []           => frequencies of the pentatonic scale
	   alt_32 freq_diff_penta [21][2] => thresholds for the pentatonic scale
	*/
	alt_32 freq_diff [49][2] = {
			{119, 123},
			{126, 130},
			{134, 138},
			{142, 146},
			{150, 155},
			{159, 164},
			{169, 173},
			{179, 184},
			{189, 195},
			{200, 206},
			{212, 219},
			{225, 232},
			{238, 245},
			{253, 260},
			{268, 275},
			{283, 292},
			{300, 309},
			{318, 327},
			{337, 347},
			{357, 368},
			{378, 389},
			{401, 413},
			{425, 437},
			{450, 463},
			{477, 491},
			{505, 520},
			{535, 551},
			{567, 584},
			{601, 618},
			{636, 655},
			{674, 694},
			{714, 735},
			{757, 779},
			{802, 825},
			{849, 874},
			{900, 926},
			{953, 981},
			{1010, 1040},
			{1070, 1101},
			{1134, 1167},
			{1201, 1236},
			{1272, 1310},
			{1348, 1388},
			{1428, 1470},
			{1513, 1558},
			{1603, 1650},
			{1699, 1748},
			{1799, 1853},
			{1906, 1963}
	};
	alt_32 freq_int [49] = {
								4186, 4435, 4699, 4978, 5274, 5588, 5920, 6272, 6645, 7040, 7459, 7902, 8372, 8870, 9397, 9956, 10548, 11175, 11840, 12544, 13290, 14080, 14917, 15804, 16744, 17740, 18795, 19912, 21096, 22351, 23680, 25088, 26579, 28160, 29834, 31609, 33488, 35479, 37589, 39824, 42192, 44701, 47359, 50175, 53159, 56320, 59669, 63217, 66976
	};

	alt_32 freq_penta [] = {
								4435, 4978, 5920, 6645, 7459, 8870, 9956, 11840, 13290, 14917, 17740, 19912, 23680, 26579, 29834, 35479, 39824, 47359, 53159, 59669, 70959
	};

	alt_32 freq_diff_penta [21][2] = {
											{368, 264},
											{279, 451},
											{491, 352},
											{373, 395},
											{419, 675},
											{736, 527},
											{559, 901},
											{983, 704},
											{746, 790},
											{837, 1350},
											{1472, 1055},
											{1118, 1802},
											{1965, 1408},
											{1492, 1580},
											{1675, 2700},
											{2945, 2110},
											{2235, 3604},
											{3931, 2816},
											{2984, 3161},
											{3349, 5400},
											{5889, 4219}

	};

	if (penta_on_off ==1 ){
		//calculates the pixel for pentatonic
		freq_diff_calc = freq - freq_penta[index];
			if(freq_diff_calc < 0){
				//pixel for the left side
				return ((150*freq_diff_calc)/freq_diff_penta[index][0]);
			}else{
				//pixel for the right side
				return ((150*freq_diff_calc)/freq_diff_penta[index][1]);
			}
	}else{
		//calculates the pixel for normal scale
		freq_diff_calc = freq - freq_int[index];
			if(freq_diff_calc < 0){
				//pixel for the left side
				return ((150*freq_diff_calc)/freq_diff[index][0]);
			}else{
				//pixel for the right side
				return ((150*freq_diff_calc)/freq_diff[index][1]);
			}
	}

}

