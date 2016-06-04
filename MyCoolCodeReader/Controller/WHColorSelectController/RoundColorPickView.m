//
//  RoundColorPickView.m
//  WHColorSelect
//
//  Created by Wayne on 16/6/2.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "RoundColorPickView.h"
#import <math.h>
@interface RoundColorPickView()
@property(nonatomic,assign) CGPoint viewCenter;
@property(nonatomic,assign) CGFloat radius;

@property(nonatomic,assign) CGFloat colorLength;
@property(nonatomic,assign) CGPoint redOrigin;
@property(nonatomic,assign) CGPoint greenOrigin;
@property(nonatomic,assign) CGPoint blueOrigin;
@property(nonatomic,strong) BLOCK sendColor;
@property(nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic,strong) UIColor *selectedColor;
@end
@implementation RoundColorPickView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

 - (void)drawRect:(CGRect)rect {
     CGRect rectD;
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     if (rect.size.width< rect.size.height) {
         rectD = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height-rect.size.width)*0.5 , rect.size.width, rect.size.width);
     }else if(rect.size.width == rect.size.height){
         rectD = rect;
     }else {
         rectD = CGRectMake(rect.origin.x + (rect.size.width-rect.size.height)*0.5 , rect.origin.y , rect.size.height, rect.size.height);
     }
     
     self.viewCenter = CGPointMake(rectD.origin.x +rectD.size.width*0.5, rectD.origin.y + rectD.size.height*0.5);
     self.radius = rect.size.width / 2;
     CGPoint o = self.viewCenter;
     CGFloat r = self.radius;
     self.colorLength = 2 *r *cos(M_PI/6);
     self.redOrigin = CGPointMake(o.x + r, o.y);
     self.greenOrigin = CGPointMake(o.x - r * cos(M_PI/3), o.y - r * sin(M_PI/3));
     self.blueOrigin = CGPointMake(o.x - r * cos(M_PI/3), o.y + r * sin(M_PI/3));
     UIImage *image = [UIImage imageNamed:@"colorRound"];
     if (image) {
         [image  drawInRect:rectD];
         
     }else{
         for (int x = o.x - r; x< r*2; x++) {
             int ymax = sqrt(r*r - (x - o.x)*(x-o.x));
             for (int y = o.y - ymax; y<o.y +ymax; y++) {
                 UIBezierPath *path = [UIBezierPath bezierPath];
                 [path moveToPoint:CGPointMake(x, y)];
                 [path addLineToPoint:CGPointMake(x, y+1)];
                 [[UIColor colorWithRed:[self caculateRedWithX:x Y:y] green:[self caculateGreenWithX:x Y:y] blue:[self caculateBlueWithX:x Y:y] alpha:1]setStroke];
                 [path stroke];
             }
         }
         UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:o radius:r+1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
         [[UIColor whiteColor]setStroke];
         [path addClip];
         path.lineWidth =4;
         [path stroke];
     }
     UIGraphicsEndImageContext();
     
}
-(CGFloat)caculateRedWithX:(int)x Y:(int)y {
    CGFloat distance = [self getDistanceBetweenPoint1:CGPointMake(x, y) toPoint2:self.viewCenter];
    CGFloat angle = [self getAngleFromStartPoint:self.viewCenter endPoint:CGPointMake(x, y)];
    CGFloat angleSub ;
    
    if (angle<M_PI/3 && angle>=-M_PI/3) {
        return 1;
    }else if (angle>-M_PI/2 && angle <-M_PI/3) {
        angleSub = -M_PI/3 - angle;
    }else if (angle>M_PI && angle <=M_PI*3/2){
        angleSub = M_PI/6 + M_PI*3/2 - angle;
    }else {
        angleSub = angle-M_PI/3;
    }
//    printf("%f\n",distance/self.radius);
    
    return (1-(angleSub/(2*M_PI/3))*distance/self.radius);
}
-(CGFloat)caculateGreenWithX:(int)x Y:(int)y {
    CGFloat distance = [self getDistanceBetweenPoint1:CGPointMake(x, y) toPoint2:self.viewCenter];
    CGFloat angle = [self getAngleFromStartPoint:self.viewCenter endPoint:CGPointMake(x, y)];
    CGFloat angleSub ;
    if (angle<M_PI/3 && angle>=-M_PI/3) {
        angleSub =  angle + M_PI/3;
    }else if (angle>-M_PI/2 && angle <-M_PI/3) {
        
        return 1;
    }else if (angle>M_PI && angle <=M_PI*3/2){
        
        return 1;
    }else {
        angleSub = M_PI - angle;
    }
    
    return (1-(angleSub/(2*M_PI/3))*distance/self.radius);
}
-(CGFloat)caculateBlueWithX:(int)x Y:(int)y {
    CGFloat distance = [self getDistanceBetweenPoint1:CGPointMake(x, y) toPoint2:self.viewCenter];
    CGFloat angle = [self getAngleFromStartPoint:self.viewCenter endPoint:CGPointMake(x, y)];
    CGFloat angleSub ;
    if (angle<M_PI/3 && angle>=-M_PI/3) {
        angleSub =  M_PI/3 -angle;
    }else if (angle>-M_PI/2 && angle <-M_PI/3) {
        angleSub = M_PI/2+ angle+M_PI/2;
    }else if (angle>M_PI && angle <=M_PI*3/2){
        angleSub =  angle - M_PI;
    }else {
        return 1;
    }
    
    return (1-(angleSub/(2*M_PI/3))*distance/self.radius);
}
-(CGFloat)getDistanceBetweenPoint1:(CGPoint)point1 toPoint2: (CGPoint)point2{
    CGFloat distance = (point1.x - point2.x)*(point1.x - point2.x)+(point1.y - point2.y)*(point1.y - point2.y);
    return sqrt(distance);
}
-(CGFloat)getAngleFromStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CGFloat angle;
    if (endPoint.x == startPoint.x) {
        angle = endPoint.y>startPoint.y?(M_PI/2):(M_PI*3/2);
    }else if(endPoint.x > startPoint.x){
        angle = atan((endPoint.y-startPoint.y)/(endPoint.x-startPoint.x));
    }else{
        angle = atan((endPoint.y-startPoint.y)/(endPoint.x-startPoint.x))+M_PI;
    }
    return angle;
}

+(instancetype)viewWithFrame:(CGRect)frame block:(BLOCK)block{
    RoundColorPickView *view = [[RoundColorPickView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.sendColor = block;
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
    point = CGPointMake(point.x +self.frame.origin.x, point.y +self.frame.origin.y);
    CGFloat x = point.x;
    CGFloat y = point.y;
    self.viewCenter = self.center;
    self.selectedColor = [UIColor colorWithRed:[self caculateRedWithX:x Y:y] green:[self caculateGreenWithX:x Y:y] blue:[self caculateBlueWithX:x Y:y] alpha:1];
    self.sendColor(self.selectedColor);

}
-(void)panGesture:(UIPanGestureRecognizer*)sender{
    NSLog(@"panColor");
    CGPoint point = [sender locationInView:self];
    point = CGPointMake(point.x +self.frame.origin.x, point.y +self.frame.origin.y);
    CGFloat x = point.x;
    CGFloat y = point.y;
    self.viewCenter = self.center;
    self.selectedColor = [UIColor colorWithRed:[self caculateRedWithX:x Y:y] green:[self caculateGreenWithX:x Y:y] blue:[self caculateBlueWithX:x Y:y] alpha:1];
    self.sendColor(self.selectedColor);
}

@end
