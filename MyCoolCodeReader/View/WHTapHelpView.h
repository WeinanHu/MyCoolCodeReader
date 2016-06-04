//
//  WHTapHelpView.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/23.
//  Copyright © 2016年 WayneHu. All rights reserved.
//
typedef void (^BLOCK) ();
#import <UIKit/UIKit.h>

@interface WHTapHelpView : UIView
+(id)viewWithRect:(CGRect)rect didClickRect:(BLOCK)complete;

@end
