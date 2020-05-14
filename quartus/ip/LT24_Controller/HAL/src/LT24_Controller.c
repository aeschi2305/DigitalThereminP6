/*----------------------------------------------------
 * File    : ime_avalon_keypad.c
 * Author  : michael.pichler@fhnw.ch
 * Date    : Dec 09 2015
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
//#include <stddef.h>
//#include "alt_types.h"
//#include "ime_avalon_keypad.h"
//
//
//int read_keypad (alt_u32 base) {
//	
//	static alt_u32 keypad_data;  // 32-Bit Register
//	static int digit;            // Value of the key
//	static int clear;
//	static int enter;
//	
//	keypad_data = IORD_IME_AVALON_KEYPAD_DATA(base);
//  
//	digit = (keypad_data & KEYPAD_DATA_DIGIT_MSK) >> KEYPAD_DATA_DIGIT_OFST;
//	clear = (keypad_data & KEYPAD_DATA_CLEAR_MSK) >> KEYPAD_DATA_CLEAR_OFST;
//	enter = (keypad_data & KEYPAD_DATA_ENTER_MSK) >> KEYPAD_DATA_ENTER_OFST;
//  
//	if (clear)
//		return 10;
//	else if (enter)
//		return 11;
//	else
//		return digit;
//}
//