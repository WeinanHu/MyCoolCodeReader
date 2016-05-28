//
//  WHPanHelpView.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/24.
//  Copyright © 2016年 WayneHu. All rights reserved.
//
#define BACKGROUNDCOLOR [UIColor colorWithWhite:0.000 alpha:0.256]

#import "WHPanHelpView.h"
@interface WHPanHelpView()
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGPoint endPoint;
@property(nonatomic,assign) CGFloat duration;
@property(nonatomic,strong) BLOCK complete;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) BOOL isStartOK;
@property(nonatomic,assign) BOOL isEndOK;
@end
@implementation WHPanHelpView
+(id)viewWithStart:(CGPoint)start withEnd:(CGPoint)end duration:(CGFloat)duration didComplete:(BLOCK)complete{
    WHPanHelpView *helpView = [[WHPanHelpView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    helpView.startPoint = start;
    helpView.endPoint =end;
    helpView.duration = duration;
    helpView.complete = complete;
    helpView.backgroundColor = BACKGROUNDCOLOR;
    [helpView addPanGesture];
    [helpView addPicAnimation];
    return helpView;
}
-(void)addPanGesture{
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanGesture:)]];
}
-(void)didPanGesture:(UIPanGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self getDistanceFromStartPoint:self.startPoint toEndPoint:point]>150 ) {
            self.isStartOK = NO;
            return;
        }
        self.isStartOK = YES;
    }else{
        
    }
    if(sender.state == UIGestureRecognizerStateEnded){
        if ([self getDistanceFromStartPoint:self.endPoint toEndPoint:point]>150 ) {
            self.isEndOK = NO;
            return;
        }
        self.isEndOK = YES;
        if (self.isStartOK == YES) {
            [self.timer invalidate];
            self.timer = nil;
            
            self.complete();
            [self removeFromSuperview];
        }
    }
}
-(void)addPicAnimation{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tap"]];
    imageView.frame = CGRectMake(self.startPoint.x-13,self.startPoint.y-4, 39, 51.6);
    //    imageView.layer.anchorPoint = CGPointMake(imageView.frame.size.width*0.33, 0);
    //    imageView.center = self.middleView.center;
    self.imageView = imageView;
    [self addSubview:self.imageView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(panAnimation) userInfo:nil repeats:YES];
}
-(void)panAnimation{
    [UIView animateWithDuration:self.duration*0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformMakeTranslation(self.endPoint.x-self.startPoint.x, self.endPoint.y-self.startPoint.y);
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:self.duration*0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.imageView.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
        });
    }];
}
-(void)dealloc{
    NSLog(@"%@",self);
    [self.timer invalidate];
    self.timer = nil;
}
-(CGFloat)getDistanceFromStartPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint{
    CGFloat angle;
    if (endPoint.x == startPoint.x) {
        angle = endPoint.y>startPoint.y?(M_PI/2):(M_PI*3/2);
    }else if(endPoint.x > startPoint.x){
        angle = atan((endPoint.y-startPoint.y)/(endPoint.x-startPoint.x));
    }else{
        angle = atan((endPoint.y-startPoint.y)/(endPoint.x-startPoint.x))+M_PI;
    }
    if (cos(angle)) {
        return abs((int)((endPoint.x-startPoint.x)/cos(angle)));
    }else {
        return abs((int)((endPoint.y-startPoint.y)));
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
