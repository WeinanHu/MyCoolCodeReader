//
//  WHColorSelectController.m
//  WHColorSelect
//
//  Created by Wayne on 16/6/3.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHColorSelectController.h"
#import "RoundColorPickView.h"
#import "LineColorPickView.h"

@interface WHColorSelectController ()
@property(nonatomic,strong) RoundColorPickView *rView;
@property(nonatomic,strong) LineColorPickView *lView;
@property(nonatomic,strong) UIColor *roundSelectColor;
@property(nonatomic,strong) UIView *selectedColorView;
@property(nonatomic,strong) UIButton *button;
@property(nonatomic,strong) UIButton *okButton;
@end

@implementation WHColorSelectController
-(instancetype)initWithBlock:(BLOCK)selectColor{
    self = [self init];
    self.sendColor = selectColor;
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.defaultColor) {
        self.roundSelectColor = self.defaultColor;
    }else{
        self.roundSelectColor = [UIColor colorWithRed:1.000 green:0.338 blue:0.972 alpha:1.000];
    }
    self.selectedColorView.backgroundColor = self.roundSelectColor;
    self.lView.contentColor = self.roundSelectColor;
    [self.lView setNeedsDisplay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat lineth ;
    if (width>height) {
        lineth = height;
    }else{
        lineth = width;
    }
    if (self.defaultColor) {
        self.roundSelectColor = self.defaultColor;
    }else{
        self.roundSelectColor = [UIColor colorWithRed:1.000 green:0.338 blue:0.972 alpha:1.000];
    }
    self.selectedColorView.backgroundColor = self.roundSelectColor;
    self.selectedColorView = [[UIView alloc]initWithFrame:CGRectMake((width-lineth*0.2)/2, (height-lineth*0.7)/2-lineth*0.15, lineth*0.2, lineth*0.1)];
    [self.view addSubview:self.selectedColorView];
    __weak typeof(self)safe = self;
    self.rView = [RoundColorPickView viewWithFrame:CGRectMake((width-lineth*0.7)/2, (height-lineth*0.7)/2, lineth*0.7, lineth*0.7) block:^(UIColor *selectedColor) {
        __strong typeof(safe)strongSelf = safe;
        strongSelf.roundSelectColor = selectedColor;
        strongSelf.lView.contentColor = selectedColor;
        strongSelf.selectedColorView.backgroundColor = selectedColor;
        [strongSelf.lView setNeedsDisplay];
        NSLog(@"%@",selectedColor);
    }];
    self.lView = [LineColorPickView viewWithFrame:CGRectMake((width-lineth*0.7)/2, (height-lineth*0.7)/2+lineth*0.8, lineth*0.7, lineth*0.08) contentColor:self.roundSelectColor block:^(UIColor *selectedColor) {
        __strong typeof(safe)strongSelf = safe;
        strongSelf.selectedColorView.backgroundColor = selectedColor;
        
    }];
    
    //    self.rView = [[RoundColorPickView alloc]initWithFrame:CGRectMake(0, 100, 320, 320)];
    self.rView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rView];
    [self.view  addSubview:self.lView];
    // Do any additional setup after loading the view, typically from a nib.
    //button
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(20, 20, 50, 40);
    [self.button setTitle:[NSString stringWithFormat:@"<%@",NSLocalizedString(@"back", nil)] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    //okbutton
    self.okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.okButton.frame = CGRectMake(width - 70, 20, 50, 40);
    [self.okButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"verify", nil)] forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    
}
-(void)backAction{
//    self.sendColor(self.selectedColorView.backgroundColor);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)okAction{
    self.sendColor(self.selectedColorView.backgroundColor);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat lineth ;
    if (width>height) {
        lineth = height;
    }else{
        lineth = width;
    }
    self.button.frame = CGRectMake(20, 20, 50, 40);
    self.okButton.frame = CGRectMake(width - 70, 20, 50, 40);
    self.selectedColorView.frame = CGRectMake((width-lineth*0.2)/2, (height-lineth*0.7)/2-lineth*0.15, lineth*0.2, lineth*0.1);
    self.rView.frame = CGRectMake((width-lineth*0.7)/2, (height-lineth*0.7)/2, lineth*0.7, lineth*0.7);
    self.lView.frame =CGRectMake((width-lineth*0.7)/2, (height-lineth*0.7)/2+lineth*0.8, lineth*0.7, lineth*0.08);
    [self.view setNeedsDisplay];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
