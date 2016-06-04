//
//  WHColorSelectController.h
//  WHColorSelect
//
//  Created by Wayne on 16/6/3.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BLOCK)(UIColor* selectedColor);
@interface WHColorSelectController : UIViewController
-(instancetype)initWithBlock: (BLOCK)selectColor;
@property(nonatomic,strong) UIColor *defaultColor;
@property(nonatomic,strong) BLOCK sendColor;
@end
