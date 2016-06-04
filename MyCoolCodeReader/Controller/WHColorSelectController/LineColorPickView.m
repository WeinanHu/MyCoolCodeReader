//
//  LineColorPickView.m
//  WHColorSelect
//
//  Created by Wayne on 16/6/3.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "LineColorPickView.h"
@interface LineColorPickView()
@property(nonatomic,strong) BLOCK sendColor;
@property(nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic,strong) UIColor *selectedColor;

@end
@implementation LineColorPickView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat xmax = x +width;
    CGFloat ymax = y +height;
    CGFloat red ;
    CGFloat green ;
    CGFloat blue ;
    CGFloat alpha ;
    [self.contentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    for (int i = x; i< x+width/2; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(i, y)];
        [path addLineToPoint:CGPointMake(i, ymax)];
        [[UIColor colorWithRed:1-((1-red)*(i-x)/(width/2)) green:1-((1-green)*(i-x)/(width/2))  blue:1-((1-blue)*(i-x)/(width/2))  alpha:alpha]setStroke];
        path.lineWidth=1;
        [path stroke];
        [path removeAllPoints];
    }
    for (int i = x+width/2; i< xmax; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(i, y)];
        [path addLineToPoint:CGPointMake(i, ymax)];
        [[UIColor colorWithRed:red*(1-(i-(x+width/2))/(width/2)) green:green*(1-(i-(x+width/2))/(width/2))  blue:blue*(1-(i-(x+width/2))/(width/2))  alpha:alpha]setStroke];
        path.lineWidth=1;
        [path stroke];
        [path removeAllPoints];
    }
    
    
}
-(UIColor*)caculateColorWithFloat:(CGFloat)colorFloat{
//    CGFloat x = self.frame.origin.x;
   
    CGFloat width = self.frame.size.width;
    
//    CGFloat xmax = x +width;
    
    CGFloat red ;
    CGFloat green ;
    CGFloat blue ;
    CGFloat alpha ;
    [self.contentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (colorFloat<width/2) {
        return [UIColor colorWithRed:1-((1-red)*colorFloat/(width/2)) green:1-((1-green)*colorFloat/(width/2))  blue:1-((1-blue)*colorFloat/(width/2))  alpha:1];
    }else{
        return [UIColor colorWithRed:red*(1-(colorFloat-(width/2))/(width/2)) green:green*(1-(colorFloat-(width/2))/(width/2))  blue:blue*(1-(colorFloat-(width/2))/(width/2))  alpha:1];
    }
    
}
+(instancetype)viewWithFrame:(CGRect)frame contentColor:(UIColor *)contentColor block: (BLOCK)selectColor{
    LineColorPickView *view = [[LineColorPickView alloc]initWithFrame:frame];
    view.sendColor = selectColor;
    view.contentColor = contentColor;
    [view addViewGesture];
    return view;
}
-(void)addViewGesture{
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:self.tapGesture];
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:self.panGesture];
}
-(void)tapGesture:(UITapGestureRecognizer*)sender{
    NSLog(@"tapColor");
    CGPoint point = [sender locationInView:self];
    
    CGFloat x = point.x;
    
    self.selectedColor = [self caculateColorWithFloat:x];
    self.sendColor(self.selectedColor);
    
}
-(void)panGesture:(UIPanGestureRecognizer*)sender{
    NSLog(@"panColor");
    CGPoint point = [sender locationInView:self];
    CGFloat x = point.x;
    
    self.selectedColor = [self caculateColorWithFloat:x];
    self.sendColor(self.selectedColor);
}
@end
