//
//  UIColor+WHColor.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/31.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "UIColor+WHColor.h"
char charToHex(char hexChar);
CGFloat floatFromHexString(NSString* hexStr);


CGFloat floatFromHexString(NSString* hexStr){
    if (hexStr.length>2) {
        return 0;
    }else {
        CGFloat hexToDigit = 0;
        for (int i = 0; i < hexStr.length; i++) {
            char hexC = [hexStr characterAtIndex:i];
            hexC = charToHex(hexC);
            long count16 = 1;
            for (int j = (int)hexStr.length-1; j>i; j--) {
                count16 *= 16;
            }
            hexToDigit += count16 * hexC;
        }
        
        return hexToDigit;
    }
}
char charToHex(char hexChar){
    if (hexChar>='0' && hexChar<='9') {
        return hexChar -'0';
    }else if (hexChar >= 'a' && hexChar <= 'f'){
        return hexChar -'a' + 10;
    }else if (hexChar >= 'A' && hexChar <= 'F'){
        return hexChar -'A' + 10;
    }
    
    return 0;
    
}
char hexToChar(char hexChar,BOOL isLargeCase){
    char a;
    if (isLargeCase) {
        a = 'A';
    }else{
        a = 'a';
    }
    if (hexChar>=0 && hexChar <= 9) {
        return hexChar +'0';
    }else if(hexChar >= 10){
        return hexChar -10 + a;
    }
    return 0;
}
NSString* colorCGFloatToHexNSString(CGFloat hexFloat,HEXCOLOR_TYPE type,BOOL isLargeCase){
    NSString *str ;
    
    if (type == HEX_24) {
        char num = ((char)(hexFloat*255)) / 17;
        num = hexToChar(num, isLargeCase);
        str = [NSString stringWithFormat:@"%c",num];
        
    }else{
        char num1 = ((int)(hexFloat*255)) / 16;
        char num2 = ((int)(hexFloat*255)) % 16;
        
        num1 = hexToChar(num1, isLargeCase);
        num2 = hexToChar(num2, isLargeCase);
        str = [NSString stringWithFormat:@"%c%c",num1,num2];
    }
    return str;
}

@implementation UIColor (WHColor)
+(UIColor*)colorWithHexColor:(NSString*)hexColor{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    if (hexColor.length<=5) {
        red = floatFromHexString([hexColor substringWithRange:(NSRange){1,1}])*17;
        green = floatFromHexString([hexColor substringWithRange:(NSRange){2,1}])*17;
        blue = floatFromHexString([hexColor substringWithRange:(NSRange){3,1}])*17;
        alpha = 255;
        if (hexColor.length==5) {
            alpha = floatFromHexString([hexColor substringWithRange:(NSRange){4,1}])*17;
        }
    }else{
        red = floatFromHexString([hexColor substringWithRange:(NSRange){1,2}]);
        green = floatFromHexString([hexColor substringWithRange:(NSRange){3,2}]);
        blue = floatFromHexString([hexColor substringWithRange:(NSRange){5,2}]);
        alpha = 255;
        if (hexColor.length==9) {
            alpha = floatFromHexString([hexColor substringWithRange:(NSRange){7,2}]);
        }
        
    }
    red = red / 255.0;
    green = green /255.0;
    blue = blue /255.0;
    alpha = alpha /255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}
+(NSString*)hexStringWithColor:(UIColor *)color withAlpha:(BOOL)hasAlpha withHexLengthType:(HEXCOLOR_TYPE)hexLengthType isLargeCase:(BOOL)isLargeCase{
    CGFloat red ;
    CGFloat green ;
    CGFloat blue ;
    CGFloat alpha ;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSString *hexString;
    
    NSString *redS = colorCGFloatToHexNSString(red, hexLengthType, isLargeCase);
    NSString *greenS = colorCGFloatToHexNSString(green, hexLengthType, isLargeCase);
    NSString *blueS = colorCGFloatToHexNSString(blue, hexLengthType, isLargeCase);
    NSString *alphaS = nil;
    if (hasAlpha) {
        alphaS = colorCGFloatToHexNSString(alpha, hexLengthType, isLargeCase);
    }else{
        alphaS = @"";
    }
    hexString = [NSString stringWithFormat:@"#%@%@%@%@",redS,greenS,blueS,alphaS];
    
    
    return hexString;
}
/**默认字母小写，48位色*/
+(NSString*)hexStringWithColor:(UIColor *)color withAlpha:(BOOL)hasAlpha{
    return [self hexStringWithColor:color withAlpha:hasAlpha withHexLengthType:HEX_48 isLargeCase:NO];
}
/**默认不带alpha通道，字母小写，48位色*/
+(NSString*)hexStringWithColor:(UIColor *)color{
    return [self hexStringWithColor:color withAlpha:NO];
}
@end
