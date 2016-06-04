//
//  RoundColorPickView.h
//  WHColorSelect
//
//  Created by Wayne on 16/6/2.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BLOCK)(UIColor* selectedColor);

@interface RoundColorPickView : UIView
+(instancetype)viewWithFrame:(CGRect)frame block:(BLOCK)block;
@end
