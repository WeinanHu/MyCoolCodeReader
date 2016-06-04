//
//  LineColorPickView.h
//  WHColorSelect
//
//  Created by Wayne on 16/6/3.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BLOCK)(UIColor* selectedColor);

@interface LineColorPickView : UIView
@property(nonatomic,strong) UIColor *contentColor;

+(instancetype)viewWithFrame:(CGRect)frame contentColor:(UIColor *)contentColor block: (BLOCK)selectColor;
@end
