

#ifndef WuFamily_ColorFontMacro_h
#define WuFamily_ColorFontMacro_h

//界面颜色值
#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]


#define COLOR_AppWhite                          RGB(253.0f, 253.0f, 253.0f)
#define COLOR_ViewBg                            RGB(236.0f, 239.0f, 240.0f)
#define COLOR_LightViewBg                       RGB(241.0f, 244.0f, 245.0f)

#define COLOR_TextDark                          RGB(5.0f, 5.0f, 5.0f)
#define COLOR_TextLightDark                     RGB(30.0f, 30.0f, 30.0f)
#define COLOR_TextDarkGray                      RGB(89.0f, 99.0f, 113.0f)
#define COLOR_TextGray                          RGB(113.0f, 112.0f, 113.0f)
#define COLOR_TextMidLightGray                  RGB(126.0f, 139.0f, 139.0f)
#define COLOR_TextLightGray                     RGB(140.0f, 140.0f, 140.0f)
#define COLOR_TextGreen                         RGB(81.0f, 181.0f, 123.0f)
#define COLOR_TextRed                           RGB(240.0f, 0.0f, 0.0f)
#define COLOR_TextDarkRed                       RGB(183.0f, 57.0f, 43.0f)
#define COLOR_TextAppOrange                     RGB(224.0f, 83.0f, 51.0f)
#define COLOR_TextOrange                        RGB(245.0f, 91.0f, 26.0f)
#define COLOR_BtnLightGray                      RGB(235.0f, 235.0f, 235.0f)
#define COLOR_BtnGray                           RGB(120.0f, 120.0f, 120.0f)
#define COLOR_BtnOrange                         RGB(245.0f, 91.0f, 26.0f)
#define COLOR_BtnGreen                          RGB(62.0f, 160.0f, 68.0f)
#define COLOR_BtnRed                            RGB(193.0f, 57.0f, 43.0f)
#define COLOR_BtnLightGreen                     RGB(82.0f, 190.0f, 128.0f)
#define COLOR_PopupCardBg                       RGB(245.0f, 245.0f, 245.0f)
#define COLOR_PopupCardBgDark                   RGB(230.0f, 230.0f, 230.0f)
#define COLOR_PopupCardTitleBg                  RGB(220.0f, 220.0f, 220.0f)
#define COLOR_PopupCardTitleLine                RGB(150.0f, 150.0f, 150.0f)
#define COLOR_BgGreen                           RGB(81.0f, 181.0f, 123.0f)
#define COLOR_BgLightGray                       RGB(236.0f, 239.0f, 240.0f)
#define COLOR_BgOrange                          RGB(223.0f, 141.0f, 57.0f)

#define Color_black                          RGB(31.f, 31.f, 31.f)
#define Color_grey                          RGB(140.f, 140.f, 140.f)

//我页面
#define colorWithHex(color) [UIColor colorWithHexString:color]
#define COLOR_background_f1f1f1 RGB(237.0f, 236.0f, 241.0f)   //背景颜色

#define COLOR_line_05          RGB(221.0f, 222.0f, 223.0f)     //tableView 线的颜色

#define COLOR_tableView_separator           RGB(221.0f, 221.0f, 221.0f)     //tableView 线的颜色
#define COLOR_black_33333         [UIColor colorWithHexString:@"#333333"]   //黑色
#define COLOR_black_666666        [UIColor colorWithHexString:@"#666666"]   //稍微黑色
#define COLOR_black_999999        [UIColor colorWithHexString:@"#999999"]    //小黑色

#define COLOR_black_000000        [UIColor colorWithHexString:@"#1F1F1F"]   //超级黑色//000000

#define COLOR_black_1f1f1f        [UIColor colorWithHexString:@"#1f1f1f"]   //黑色31 31 31

#define COLOR_black_8c8c8c        [UIColor colorWithHexString:@"#8c8c8c"]   //灰色140 140 140
#define COLOR_gray_929292         [UIColor colorWithHexString:@"#929292"]   //灰色
#define COLOR_gray_808080         [UIColor colorWithHexString:@"#808080"]   //灰色
#define COLOR_lightGray_f2f2f2    [UIColor colorWithHexString:@"#f7f7f7"]   //tableView 背景色
#define COLOR_blue_00B4FF         [UIColor colorWithHexString:@"#00B4FF"]   //蓝色
#define COLOR_reg_FF0000          [UIColor colorWithHexString:@"#FF0000"]   //红色
#define COLOR_reg_FF0055         [UIColor colorWithHexString:@"#FF4055"]   //delete红色
#define COLOR_lightGray_CCCCCC    [UIColor colorWithHexString:@"#CCCCCC"]   //浅灰色
#define COLOR_lightGray_4D4D4D   [UIColor colorWithHexString:@"#4D4D4D"]   //浅灰色

#define COLOR_blue_B167A5        [UIColor colorWithHexString:@"#B167A5"]   //ZISE
#define COLOR_reddish_FA9B9B   [UIColor colorWithHexString:@"#FA9B9B"]    //微红色 赞的颜色
#define COLOR_red_FF4055        [UIColor colorWithHexString:@"#FF4055"]   //红包附言
#define COLOR_pieceBlue_00B4FF [UIColor colorWithHexString:@"#00B4FF"]     //片蓝色 怜的颜色
#define COLOR_pieceBlue_17B1C0 [UIColor colorWithHexString:@"#17B1C0"]     //片蓝色 //用于密室回复
#define COLOR_pieceRed_EF97B0 [UIColor colorWithHexString:@"#EF97B0"]    //浅红色 //用于密室回复
#define COLOR_gray_102 RGB(102,102,102)  //深灰色


//界面字体值
#define SIZE_TextSmall                          10.0f
#define SIZE_TextContentNormal                  13.0f
#define SIZE_TextTitleMini                      15.0f
#define SIZE_TextTitleNormal                    17.0f
#define SIZE_TextTitleLarge                     20.0f
#define SIZE_TextLarge                          16.0f
#define SIZE_TextHuge                           18.0f
#define SIZE_TextTitleFour                      14.0f


//界面字体值
#define SIZE_FONT_10                            10.0f
#define SIZE_FONT_11                            11.0f
#define SIZE_FONT_12                            12.0f
#define SIZE_FONT_13                            13.0f
#define SIZE_FONT_14                            14.0f
#define SIZE_FONT_15                            15.0f
#define SIZE_FONT_16                            16.0f
#define SIZE_FONT_17                            17.0f
#define SIZE_FONT_18                            18.0f


#endif
