//
//  WHHelpView.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/23.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHHelpView.h"
@interface WHHelpView()
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@end
@implementation WHHelpView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.width = [UIScreen mainScreen].bounds.size.width;
        self.height = [UIScreen mainScreen].bounds.size.height;
        
    }
    return self;
}
+(id)viewWithRect:(CGRect)rect{
    WHHelpView *helpView = [[WHHelpView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, helpView.width, rect.size.height)];
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height+rect.origin.y, helpView.width, helpView.height-(rect.size.height+rect.origin.y))];
    UIView *viewLeft = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y, rect.origin.x, rect.size.height)];
    UIView *viewRight = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x+rect.size.width, rect.origin.y, helpView.width-(rect.origin.x+rect.size.width), rect.size.height)];
    UIView *viewMiddle = [[UIView alloc]initWithFrame:rect];
    
    viewTop.backgroundColor = [UIColor blackColor];
    viewBottom.backgroundColor = [UIColor redColor];
    viewLeft.backgroundColor = [UIColor greenColor];
    viewRight.backgroundColor = [UIColor grayColor];
    
    [viewTop addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [viewBottom addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [viewLeft addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    [viewRight addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOutRectView:)]];
    
    [helpView addSubview:viewTop];
    [helpView addSubview:viewBottom];
    [helpView addSubview:viewLeft];
    [helpView addSubview:viewRight];
    [helpView addSubview:viewMiddle];
    
    return helpView;
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
