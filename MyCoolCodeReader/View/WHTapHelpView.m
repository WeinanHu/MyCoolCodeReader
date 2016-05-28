//
//  WHTapHelpView.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/23.
//  Copyright © 2016年 WayneHu. All rights reserved.
//
#define BACKGROUNDCOLOR [UIColor colorWithWhite:0.000 alpha:0.256]
#import "WHTapHelpView.h"
@interface WHTapHelpView()
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIView *rightView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) BLOCK complete;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) NSTimer *timer;
@end
@implementation WHTapHelpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = [UIScreen mainScreen].bounds.size.width;
        self.height = [UIScreen mainScreen].bounds.size.height;
        
    }
    return self;
}
+(id)viewWithRect:(CGRect)rect didClickRect:(BLOCK)complete{
    WHTapHelpView *helpView = [[WHTapHelpView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    helpView.complete = complete;
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, helpView.width, rect.origin.y)];
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height+rect.origin.y, helpView.width, helpView.height-(rect.size.height+rect.origin.y))];
    UIView *viewLeft = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y, rect.origin.x, rect.size.height)];
    UIView *viewRight = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, helpView.width-(rect.origin.x+rect.size.width), rect.size.height)];
    UIView *viewMiddle = [[UIView alloc]initWithFrame:rect];
    
    viewTop.backgroundColor = BACKGROUNDCOLOR;
    viewBottom.backgroundColor = BACKGROUNDCOLOR;
    viewLeft.backgroundColor = BACKGROUNDCOLOR;
    viewRight.backgroundColor = BACKGROUNDCOLOR;
    
    
    [helpView addSubview:viewTop];
    [helpView addSubview:viewBottom];
    [helpView addSubview:viewLeft];
    [helpView addSubview:viewRight];
    [helpView addSubview:viewMiddle];
    
    helpView.topView = viewTop;
    helpView.bottomView = viewBottom;
    helpView.leftView = viewLeft;
    helpView.rightView = viewRight;
    helpView.middleView = viewMiddle;
    [helpView addToGesture];
    [helpView addPicAnimation];
    return helpView;
}
-(void)addToGesture{
    [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [self.bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [self.rightView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapSelfView:)]];

}
-(void)addPicAnimation{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tap"]];
    imageView.frame = CGRectMake(self.middleView.frame.origin.x+self.middleView.frame.size.width*0.5-13, self.middleView.frame.origin.y+self.middleView.frame.size.height*0.50-4, 39, 51.6);
//    imageView.layer.anchorPoint = CGPointMake(imageView.frame.size.width*0.33, 0);
//    imageView.center = self.middleView.center;
    self.imageView = imageView;
    [self addSubview:self.imageView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(tapAnimation) userInfo:nil repeats:YES];
}
-(void)tapAnimation{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformMakeTranslation(0, 5);
    } completion:^(BOOL finished) {
       dispatch_async(dispatch_get_main_queue(), ^{
          [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
              self.imageView.transform = CGAffineTransformMakeTranslation(0, -5);
          } completion:^(BOOL finished) {
              
          }];
       });
    }];
}
-(void)TapSelfView:(UITapGestureRecognizer*)sender{
    [self.timer invalidate];
    self.timer = nil;

    self.complete();
    [self removeFromSuperview];
    
}
-(void)dealloc{
    NSLog(@"%@",self);
    [self.timer invalidate];
    self.timer = nil;
}
-(void)TapOutRectView:(UITapGestureRecognizer*)sender{
    NSLog(@"%@",sender.view.backgroundColor);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
