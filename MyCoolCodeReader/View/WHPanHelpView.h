//
//  WHPanHelpView.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/24.
//  Copyright © 2016年 WayneHu. All rights reserved.
//
typedef void(^BLOCK)();
#import <UIKit/UIKit.h>

@interface WHPanHelpView : UIView
+(id)viewWithStart:(CGPoint)start withEnd:(CGPoint)end duration:(CGFloat)duration didComplete:(BLOCK)complete;

@end
