//
//  WHDrawViewController.h
//  testDraw
//
//  Created by Wayne on 16/5/20.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
@interface WHDrawViewController : UIViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withBkgView:(UIView*)view;
@end
@interface ArrowView : UIView
-(instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint withColor:(UIColor*)color;

@end
@interface CaseView : UIView
-(instancetype)initWithFrame:(CGRect)frame withColor:(UIColor*)color;

@end