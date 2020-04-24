/*----------------------------------------------------
 * File    : ime_avalon_keypad_regs.h
 * Author  : michael.pichler@fhnw.ch
 * Date    : Dec 09 2015
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : Register Description
 *--------------------------------------------------*/
#ifndef __IME_AVALON_KEYPAD_REGS_H__
#define __IME_AVALON_KEYPAD_REGS_H__

#include <io.h>

// Register 0: DATA
#define IME_AVALON_KEYPAD_DATA_REG                  0
#define IOADDR_IME_AVALON_KEYPAD_DATA(base)         __IO_CALC_ADDRESS_NATIVE(base, IME_AVALON_KEYPAD_DATA_REG)
#define IORD_IME_AVALON_KEYPAD_DATA(base)           IORD(base, IME_AVALON_KEYPAD_DATA_REG) 
#define IOWR_IME_AVALON_KEYPAD_DATA(base, data)     IOWR(base, IME_AVALON_KEYPAD_DATA_REG, data)

#define KEYPAD_DATA_DIGIT_MSK                       (0xF)
#define KEYPAD_DATA_DIGIT_OFST                      (0)
#define KEYPAD_DATA_CLEAR_MSK                       (0x10)
#define KEYPAD_DATA_CLEAR_OFST                      (4)
#define KEYPAD_DATA_ENTER_MSK                       (0x20)
#define KEYPAD_DATA_ENTER_OFST                      (5)

// Register 1: INTERRUPT
// #define IME_AVALON_KEYPAD_IRQ_REG                   1
// #define IOADDR_IME_AVALON_KEYPAD_IRQ(base)          __IO_CALC_ADDRESS_NATIVE(base, IME_AVALON_KEYPAD_IRQ_REG)
// #define IORD_IME_AVALON_KEYPAD_IRQ(base)            IORD(base, IME_AVALON_KEYPAD_IRQ_REG) 
// #define IOWR_IME_AVALON_KEYPAD_IRQ(base, data)      IOWR(base, IME_AVALON_KEYPAD_IRQ_REG, data) 

// #define KEYPAD_IRQ_EVENT_MSK                        (0x1)
// #define KEYPAD_IRQ_EVENT_OFST                       (0)

// Register 2: DIV_COUNTER
#define IME_AVALON_KEYPAD_DIV_REG                   1
#define IOADDR_IME_AVALON_KEYPAD_DIV(base)          __IO_CALC_ADDRESS_NATIVE(base, IME_AVALON_KEYPAD_DIV_REG)
#define IORD_IME_AVALON_KEYPAD_DIV(base)            IORD(base, IME_AVALON_KEYPAD_DIV_REG) 
#define IOWR_IME_AVALON_KEYPAD_DIV(base, data)      IOWR(base, IME_AVALON_KEYPAD_DIV_REG, data)

#define KEYPAD_DIV_MSK                              (0xFFFF)
#define KEYPAD_DIV_OFST                             (0)

#endif /* __IME_AVALON_KEYPAD_REGS_H__ */
