/* File    : LT24_Controller.h
 * Author  :
 * Date    :
 * Company : Institute of Microelectronics (IME) FHNW
 * Content :
 *--------------------------------------------------*/
#ifndef __GRAPHICS_H__
#define __GRAPHICS_H__

// JCJB:  Adding inclusion of the graphics driver header
//#include "alt_video_display.h"
//#include "vip_fr.h"
#include "fonts.h"  // modify this file to add/remove fonts
#include "alt_video_display.h"

// use this background colour when you don't want a filled in box behind the alpha blended text
#define CLEAR_BACKGROUND -1

#define TAB_SPACING 2

void Delay_Ms_1(alt_u16 count_ms);

void draw_horiz_line (alt_u16 Hstart, alt_u16 Hend, alt_u16 V, alt_u16 color);


void draw_line(alt_u16 horiz_start, alt_u16 vert_start, alt_u16 horiz_end, alt_u16 vert_end, alt_u16 width, alt_u16 color);

void draw_sloped_line( alt_u16 horiz_start,
                           alt_u16 vert_start,
                           alt_u16 horiz_end,
                           alt_u16 vert_end,
                           alt_u16 width,
                           alt_u16 color);

void paint_block (alt_u16 Hstart,alt_u16 Vstart, alt_u16 Hend, alt_u16 Vend, alt_u16 color);

int draw_box (alt_u16 horiz_start, alt_u16 vert_start, alt_u16 horiz_end, alt_u16 vert_end, alt_u16 color, int fill);




//Color Definitions
 // #if(RGB == 1)  // Use these colours when in RGB format, otherwise BGR will be used instead
    #define ALICEBLUE_16  0xFFDE
    #define ANTIQUEWHITE_16 0xD75F
    #define AQUA_16 0xFFC0
    #define AQUAMARINE_16 0xD7CF
    #define AZURE_16  0xFFDE
    #define BEIGE_16  0xDF9E
    #define BISQUE_16 0xC71F
    #define BLACK_16  0x0000
    #define BLANCHEDALMOND_16 0xCF5F
    #define BLUE_16 0xF800
    #define BLUEVIOLET_16 0xE151
    #define BROWN_16  0x2954
    #define BURLYWOOD_16  0x85DB
    #define CADETBLUE_16  0xA4CB
    #define CHARTREUSE_16 0x07CF
    #define CHOCOLATE_16  0x1B5A
    #define CORAL_16  0x53DF
    #define CORNFLOWERBLUE_16 0xEC8C
    #define CORNSILK_16 0xDFDF
    #define CRIMSON_16  0x389B
    #define CYAN_16 0xFFC0
    #define DARKBLUE_16 0x8800
    #define DARKCYAN_16 0x8C40
    #define DARKGOLDENROD_16  0xC17
    #define DARKGRAY_16 0xAD55
    #define DARKGREEN_16  0x300
    #define DARKKHAKI_16  0x6D97
    #define DARKMAGENTA_16  0x8811
    #define DARKOLIVEGREEN_16 0x2B4A
    #define DARKORANGE_16 0x045F
    #define DARKORCHID_16 0xC993
    #define DARKRED_16  0x0011
    #define DARKSALMON_16 0x7C9D
    #define DARKSEAGREEN_16 0x8DD1
    #define DARKSLATEBLUE_16  0x89C9
    #define DARKSLATEGRAY_16  0x4A45
    #define DARKTURQUOISE_16  0xD640
    #define DARKVIOLET_16 0xD012
    #define DEEPPINK_16 0x909F
    #define DEEPSKYBLUE_16  0xFDC0
    #define DIMGRAY_16  0x6B4D
    #define DODGERBLUE_16 0xFC83
    #define FELDSPAR_16 0x749A
    #define FIREBRICK_16  0x2116
    #define FLORALWHITE_16  0xF7DF
    #define FORESTGREEN_16  0x2444
    #define FUCHSIA_16  0xF81F
    #define GAINSBORO_16  0xDEDB
    #define GHOSTWHITE_16 0xFFDF
    #define GOLD_16 0x069F
    #define GOLDENROD_16  0x251B
    #define GRAY_16 0x8410
    #define GRAY25_16 0x4208
    #define GRAY50_16 0x7BCF
    #define GRAY75_16 0xC618
    #define GREEN_16  0x0400
    #define GREENYELLOW_16  0x2FD5
    #define HONEYDEW_16 0xF7DE
    #define HOTPINK_16  0xB35F
    #define INDIANRED_16  0x5AD9
    #define INDIGO_16 0x8009
    #define IVORY_16  0xF7DF
    #define KHAKI_16  0x8F1E
    #define LAVENDER_16 0xFF1C
    #define LAVENDERBLUSH_16  0xF79F
    #define LAWNGREEN_16  0x07CF
    #define LEMONCHIFFON_16 0xCFDF
    #define LIGHTBLUE_16  0xE6D5
    #define LIGHTCORAL_16 0x841E
    #define LIGHTCYAN_16  0xFFDC
    #define LIGHTGOLDENRODYELLOW_16 0xD7DF
    #define LIGHTGREEN_16 0x9752
    #define LIGHTGREY_16  0xD69A
    #define LIGHTPINK_16  0xC59F
    #define LIGHTSALMON_16  0x7D1F
    #define LIGHTSEAGREEN_16  0xAD84
    #define LIGHTSKYBLUE_16 0xFE50
    #define LIGHTSLATEBLUE_16 0xFB90
    #define LIGHTSLATEGRAY_16 0x9C4E
    #define LIGHTSTEELBLUE_16 0xDE16
    #define LIGHTYELLOW_16  0xE7DF
    #define LIME_16 0x7C0
    #define LIMEGREEN_16  0x3646
    #define LINEN_16  0xE79F
    #define MAGENTA_16  0xF81F
    #define MAROON_16 0x0010
    #define MEDIUMAQUAMARINE_16 0xAE4C
    #define MEDIUMBLUE_16 0xC800
    #define MEDIUMORCHID_16 0xD297
    #define MEDIUMPURPLE_16 0xDB92
    #define MEDIUMSEAGREEN_16 0x7587
    #define MEDIUMSLATEBLUE_16  0xEB4F
    #define MEDIUMSPRINGGREEN_16  0x9FC0
    #define MEDIUMTURQUOISE_16  0xCE89
    #define MEDIUMVIOLETRED_16  0x8098
    #define MIDNIGHTBLUE_16 0x70C3
    #define MINTCREAM_16  0xFFDE
    #define MISTYROSE_16  0xE71F
    #define MOCCASIN_16 0xB71F
    #define NAVAJOWHITE_16  0xAEDF
    #define NAVY_16 0x8000
    #define OLDLACE_16  0xE79F
    #define OLIVE_16  0x0410
    #define OLIVEDRAB_16  0x244D
    #define ORANGE_16 0x051F
    #define ORANGERED_16  0x021F
    #define ORCHID_16 0xD39B
    #define PALEGOLDENROD_16  0xAF5D
    #define PALEGREEN_16  0x9FD3
    #define PALETURQUOISE_16  0xEF55
    #define PALEVIOLETRED_16  0x939B
    #define PAPAYAWHIP_16 0xD75F
    #define PEACHPUFF_16  0xBEDF
    #define PERU_16 0x3C19
    #define PINK_16 0xCE1F
    #define PLUM_16 0xDD1B
    #define POWDERBLUE_16 0xE716
    #define PURPLE_16 0x8010
    #define RED_16  0x001F
    #define ROSYBROWN_16  0x8C57
    #define ROYALBLUE_16  0x9080
    #define SADDLEBROWN_16  0x1211
    #define SALMON_16 0x741F
    #define SANDYBROWN_16 0x651E
    #define SEAGREEN_16 0x5445
    #define SEASHELL_16 0xEF9F
    #define SIENNA_16 0x2A94
    #define SILVER_16 0xC618
    #define SKYBLUE_16  0xEE50
    #define SLATEBLUE_16  0xCACD
    #define SLATEGRAY_16  0x940E
    #define SNOW_16 0xFFDF
    #define SPRINGGREEN_16  0x7FC0
    #define STEELBLUE_16  0xB408
    #define TAN_16  0x8D9A
    #define TEAL_16 0x8400
    #define THISTLE_16  0xDDDB
    #define TOMATO_16 0x431F
    #define TURQUOISE_16  0xD708
    #define VIOLET_16 0xEC1D
    #define VIOLETRED_16  0x911A
    #define WHEAT_16  0xB6DE
    #define WHITE_16  0xFFDF
    #define WHITESMOKE_16 0xF79E
    #define YELLOW_16 0x07DF
    #define YELLOWGREEN_16  0x3653

    #define ALICEBLUE_24    0xF0F8FF
    #define ANTIQUEWHITE_24   0xFAEBD7
    #define AQUA_24   0x00FFFF
    #define AQUAMARINE_24   0x7FFFD4
    #define AZURE_24    0xF0FFFF
    #define BEIGE_24    0xF5F5DC
    #define BISQUE_24   0xFFE4C4
    #define BLACK_24    0x000000
    #define BLANCHEDALMOND_24   0xFFEBCD
    #define BLUE_24   0x0000FF
    #define BLUEVIOLET_24   0x8A2BE2
    #define BROWN_24    0xA52A2A
    #define BURLYWOOD_24    0xDEB887
    #define CADETBLUE_24    0x5F9EA0
    #define CHARTREUSE_24   0x7FFF00
    #define CHOCOLATE_24    0xD2691E
    #define CORAL_24    0xFF7F50
    #define CORNFLOWERBLUE_24   0x6495ED
    #define CORNSILK_24   0xFFF8DC
    #define CRIMSON_24    0xDC143C
    #define CYAN_24   0x00FFFF
    #define DARKBLUE_24   0x00008B
    #define DARKCYAN_24   0x008B8B
    #define DARKGOLDENROD_24    0xB8860B
    #define DARKGRAY_24   0xA9A9A9
    #define DARKGREY_24   0xA9A9A9
    #define DARKGREEN_24    0x006400
    #define DARKKHAKI_24    0xBDB76B
    #define DARKMAGENTA_24    0x8B008B
    #define DARKOLIVEGREEN_24   0x556B2F
    #define DARKORANGE_24   0xFF8C00
    #define DARKORCHID_24   0x9932CC
    #define DARKRED_24    0x8B0000
    #define DARKSALMON_24   0xE9967A
    #define DARKSEAGREEN_24   0x8FBC8F
    #define DARKSLATEBLUE_24    0x483D8B
    #define DARKSLATEGRAY_24    0x2F4F4F
    #define DARKSLATEGREY_24    0x2F4F4F
    #define DARKTURQUOISE_24    0x00CED1
    #define DARKVIOLET_24   0x9400D3
    #define DEEPPINK_24   0xFF1493
    #define DEEPSKYBLUE_24    0x00BFFF
    #define DIMGRAY_24    0x696969
    #define DIMGREY_24    0x696969
    #define DODGERBLUE_24   0x1E90FF
    #define FIREBRICK_24    0xB22222
    #define FLORALWHITE_24    0xFFFAF0
    #define FORESTGREEN_24    0x228B22
    #define FUCHSIA_24  0xFF00FF
    #define GAINSBORO_24    0xDCDCDC
    #define GHOSTWHITE_24   0xF8F8FF
    #define GOLD_24   0xFFD700
    #define GOLDENROD_24    0xDAA520
    #define GRAY_24   0x808080
    #define GREY_24   0x808080
    #define GREEN_24    0x008000
    #define GREENYELLOW_24    0xADFF2F
    #define HONEYDEW_24   0xF0FFF0
    #define HOTPINK_24    0xFF69B4
    #define INDIANRED_24    0xCD5C5C
    #define INDIGO_24     0x4B0082
    #define IVORY_24    0xFFFFF0
    #define KHAKI_24    0xF0E68C
    #define LAVENDER_24   0xE6E6FA
    #define LAVENDERBLUSH_24    0xFFF0F5
    #define LAWNGREEN_24    0x7CFC00
    #define LEMONCHIFFON_24   0xFFFACD
    #define LIGHTBLUE_24    0xADD8E6
    #define LIGHTCORAL_24   0xF08080
    #define LIGHTCYAN_24    0xE0FFFF
    #define LIGHTGOLDENRODYELLOW_24   0xFAFAD2
    #define LIGHTGRAY_24    0xD3D3D3
    #define LIGHTGREY_24    0xD3D3D3
    #define LIGHTGREEN_24   0x90EE90
    #define LIGHTPINK_24    0xFFB6C1
    #define LIGHTSALMON_24    0xFFA07A
    #define LIGHTSEAGREEN_24    0x20B2AA
    #define LIGHTSKYBLUE_24   0x87CEFA
    #define LIGHTSLATEGRAY_24   0x778899
    #define LIGHTSLATEGREY_24   0x778899
    #define LIGHTSTEELBLUE_24   0xB0C4DE
    #define LIGHTYELLOW_24    0xFFFFE0
    #define LIME_24   0x00FF00
    #define LIMEGREEN_24    0x32CD32
    #define LINEN_24    0xFAF0E6
    #define MAGENTA_24    0xFF00FF
    #define MAROON_24   0x800000
    #define MEDIUMAQUAMARINE_24   0x66CDAA
    #define MEDIUMBLUE_24   0x0000CD
    #define MEDIUMORCHID_24   0xBA55D3
    #define MEDIUMPURPLE_24   0x9370D8
    #define MEDIUMSEAGREEN_24_24    0x3CB371
    #define MEDIUMSLATEBLUE_24    0x7B68EE
    #define MEDIUMSPRINGGREEN_24    0x00FA9A
    #define MEDIUMTURQUOISE_24    0x48D1CC
    #define MEDIUMVIOLETRED_24    0xC71585
    #define MIDNIGHTBLUE_24   0x191970
    #define MINTCREAM_24    0xF5FFFA
    #define MISTYROSE_24    0xFFE4E1
    #define MOCCASIN_24   0xFFE4B5
    #define NAVAJOWHITE_24    0xFFDEAD
    #define NAVY_24   0x000080
    #define OLDLACE_24    0xFDF5E6
    #define OLIVE_24    0x808000
    #define OLIVEDRAB_24    0x6B8E23
    #define ORANGE_24   0xFFA500
    #define ORANGERED_24    0xFF4500
    #define ORCHID_24   0xDA70D6
    #define PALEGOLDENROD_24    0xEEE8AA
    #define PALEGREEN_24    0x98FB98
    #define PALETURQUOISE_24    0xAFEEEE
    #define PALEVIOLETRED_24    0xD87093
    #define PAPAYAWHIP_24   0xFFEFD5
    #define PEACHPUFF_24    0xFFDAB9
    #define PERU_24   0xCD853F
    #define PINK_24   0xFFC0CB
    #define PLUM_24   0xDDA0DD
    #define POWDERBLUE_24   0xB0E0E6
    #define PURPLE_24   0x800080
    #define RED_24    0xFF0000
    #define ROSYBROWN_24    0xBC8F8F
    #define ROYALBLUE_24    0x4169E1
    #define SADDLEBROWN_24    0x8B4513
    #define SALMON_24   0xFA8072
    #define SANDYBROWN_24   0xF4A460
    #define SEAGREEN_24   0x2E8B57
    #define SEASHELL_24   0xFFF5EE
    #define SIENNA_24   0xA0522D
    #define SILVER_24   0xC0C0C0
    #define SKYBLUE_24    0x87CEEB
    #define SLATEBLUE_24    0x6A5ACD
    #define SLATEGRAY_24    0x708090
    #define SLATEGREY_24    0x708090
    #define SNOW_24   0xFFFAFA
    #define SPRINGGREEN_24    0x00FF7F
    #define STEELBLUE_24    0x4682B4
    #define TAN_24    0xD2B48C
    #define TEAL_24   0x008080
    #define THISTLE_24    0xD8BFD8
    #define TOMATO_24   0xFF6347
    #define TURQUOISE_24    0x40E0D0
    #define VIOLET_24   0xEE82EE
    #define WHEAT_24    0xF5DEB3
    #define WHITE_24    0xFFFFFF
    #define WHITESMOKE_24   0xF5F5F5
    #define YELLOW_24   0xFFFF00
    #define YELLOWGREEN_24    0x9ACD32

#endif
