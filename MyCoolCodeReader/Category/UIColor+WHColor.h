//
//  UIColor+WHColor.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/31.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    HEX_24,
    HEX_48
}HEXCOLOR_TYPE;
@interface UIColor (WHColor)
/**
 *  从ASP颜色获取UIColor
 *
 *  @param hexColor ASP颜色编码，如@"#fff"、@"#ffffff"、@"#ffff"、@"#ffffffff"
 *
 *  @return UIColor
 */
+(UIColor*)colorWithHexColor:(NSString*)hexColor;
/**
 *  获取ASP颜色
 *
 *  @param color         UIColor
 *  @param hasAlpha      是否带透明通道
 *  @param hexLengthType 色彩类型：24位 or 48位
 *  @param isLargeCase   是否是大写字母输出
 *
 *  @return NSString 型的 ASP色彩 例如@"#ffffff"
 */
+(NSString*)hexStringWithColor:(UIColor *)color withAlpha:(BOOL)hasAlpha withHexLengthType:(HEXCOLOR_TYPE)hexLengthType isLargeCase:(BOOL)isLargeCase;
/**默认字母小写，48位色*/
+(NSString*)hexStringWithColor:(UIColor *)color withAlpha:(BOOL)hasAlpha;
/**默认不带alpha通道，字母小写，48位色*/
+(NSString*)hexStringWithColor:(UIColor *)color;
@end
