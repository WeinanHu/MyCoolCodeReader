//
//  WHDrawViewController.m
//  testDraw
//
//  Created by Wayne on 16/5/20.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHDrawViewController.h"
#import "MBProgressHUD+KR.h"
#import "WHTapHelpView.h"
#import "WHPanHelpView.h"
typedef enum{
    NONE,
    RED_TYPE,
    GREEN_TYPE,
    YELLOW_TYPE
}DRAW_TYPE;
@interface WHDrawViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property(nonatomic,strong) UIImageView *bkgImageView;
@property(nonatomic,strong) UIView *buttonCase;
@property(nonatomic,assign) DRAW_TYPE drawType;
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGPoint endPoint;
@property(nonatomic,strong) UIButton *selectedButton;
@property(nonatomic,strong) ArrowView *arrowView;
@property(nonatomic,strong) NSMutableArray *arrowViewArray;
@property(nonatomic,strong) NSMutableArray *tapViewArray;
@property(nonatomic,strong) NSMutableArray *endPointArray;
@property(nonatomic,strong) NSMutableArray *angleArray;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) CaseView *caseView;
@property(nonatomic,assign) CGFloat angle;
@property(nonatomic,assign) CGPoint deletePanStartPoint;
@property(nonatomic,assign) CGPoint deletePanEndPoint;
@property(nonatomic,assign) NSInteger currentTapIndex;
@property(nonatomic,strong) NSTimer *blinkTimer;
@property(nonatomic,strong) UIView *blinkView;
@property(nonatomic,assign) NSInteger helpIndex;
@end

@implementation WHDrawViewController
#pragma mark - init
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withBkgView:(UIView*)view{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.bkgImageView = [[UIImageView alloc]initWithImage:[self captureView:view]];
    self.bkgImageView.userInteractionEnabled = YES;
    return self;
    
}
#pragma mark - capture
-(UIImage*)captureView:(UIView*)view{
    
    CGRect rect = [view frame];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}
- (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//如果要保存到相册:
- (void)saveScreenshotToPhotosAlbum:(UIView *)view
{
    [self.view endEditing:YES];
    [self.buttonContainerView setHidden:YES];
    UIImageWriteToSavedPhotosAlbum([self captureView:view], nil, nil, nil);
    [MBProgressHUD showSuccess:NSLocalizedString(@"saveSuccess", nil) toView:self.view];
    [self.buttonContainerView setHidden:NO];
}
#pragma mark - view
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addObserver:self forKeyPath:@"selectedButton.layer.position" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self removeObserver:self forKeyPath:@"selectedButton.layer.position"];
}
-(void)viewDidLayoutSubviews{
    NSLog(@"rect selectedButton:%@",NSStringFromCGRect(self.selectedButton.frame));
    int tapViewCount = 0;
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isShowedHelp"]) {
        NSLog(@"%@",[UIApplication sharedApplication].keyWindow.subviews);
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            NSLog(@"%@",[NSThread currentThread]);
            
            if ([view isKindOfClass:[WHTapHelpView class]]) {
                tapViewCount++;
                if (tapViewCount>1) {
                    [view removeFromSuperview];
                }else{
                    WHTapHelpView *tapView = (WHTapHelpView*)view;
                    [tapView removeFromSuperview];
                    tapView = nil;
                    //                for (UIView *viewShouldDelete in [UIApplication sharedApplication].keyWindow.subviews) {
                    //                    if ([view isKindOfClass:[WHTapHelpView class]]) {
                    //                        [viewShouldDelete removeFromSuperview];
                    //                    }
                    //                }
                    if (self.helpIndex ==0) {
                        __weak typeof(self)weekSafe = self;
                        [[UIApplication sharedApplication].keyWindow addSubview:[WHTapHelpView viewWithRect:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)didClickRect:^{
                            __strong typeof(weekSafe)safe = weekSafe;
                            [safe didTap];
                            [tapView removeFromSuperview];
                            [safe performSelector:@selector(tapAgainHelp) withObject:nil afterDelay:0.1];
                            safe.helpIndex ++;
                        }]];
                        
                    }else if(self.helpIndex ==1){
                        __weak typeof(self)weekSafe = self;
                        [[UIApplication sharedApplication].keyWindow addSubview:[WHTapHelpView viewWithRect:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)didClickRect:^{
                            __strong typeof(weekSafe)safe = weekSafe;
                            [safe didTap];
                            [safe performSelector:@selector(panHelp) withObject:nil afterDelay:0.1];
                            safe.helpIndex ++;
                        }]];
                    }
                    
                }
            }
        }
    }
}
-(void)panHelp{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[WHTapHelpView class]]) {
            [view removeFromSuperview];
        }
    }
    __weak typeof(self)weekSelf = self;
    CGPoint pointStart = CGPointMake(100, 100);
    CGPoint pointEnd = CGPointMake(200, 200);
    NSLog(@"%@",[UIApplication sharedApplication].keyWindow.subviews);
    [[UIApplication sharedApplication].keyWindow addSubview:[WHPanHelpView viewWithStart:pointStart withEnd:pointEnd duration:1 didComplete:^{
        __strong typeof(weekSelf) safe = weekSelf;
        safe.endPoint = pointEnd;
        safe.startPoint = pointStart;
        [safe.arrowView removeFromSuperview];
        safe.arrowView = [[ArrowView alloc]initWithFrame:safe.view.bounds startPoint:safe.startPoint endPoint:safe.endPoint withColor:safe.selectedButton.backgroundColor];
        safe.arrowView.backgroundColor = [UIColor clearColor];
        [safe.view insertSubview:safe.arrowView belowSubview:safe.buttonContainerView];
        
        [safe.endPointArray addObject:[NSValue valueWithCGPoint:safe.endPoint]];
        //画caseView
        [safe createCaseViewWithArrowStartPoint:safe.startPoint endPoint:safe.endPoint inView:safe.view];
        
        safe.helpIndex ++;
    }]];
    
}
-(void)tapAgainHelp{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[WHTapHelpView class]]) {
            [view removeFromSuperview];
        }
    }
    __weak typeof(self)weekSafe = self;
    [[UIApplication sharedApplication].keyWindow addSubview:[WHTapHelpView viewWithRect:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)didClickRect:^{
        __strong typeof(weekSafe)safe = weekSafe;
        [safe didTap];
        [safe performSelector:@selector(panHelp) withObject:nil afterDelay:0.1];
        safe.helpIndex ++;
    }]];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpIndex = 0;
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isShowedHelp"]) {
        __weak typeof(self)safe = self;
        [[UIApplication sharedApplication].keyWindow addSubview:[WHTapHelpView viewWithRect:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)didClickRect:^{
            [safe didTap];
            [safe performSelector:@selector(tapAgainHelp) withObject:nil afterDelay:0.1];
            safe.helpIndex ++;
        }]];
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.000];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"<%@",NSLocalizedString(@"back", nil)] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.saveButton setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    
    if (self.bkgImageView) {
        [self.view insertSubview:self.bkgImageView atIndex:0];
    }
    if (self.navigationController) {
        self.navigationController.navigationBarHidden=YES;
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
        tapGesture.delegate = self;
        [self.view addGestureRecognizer:tapGesture];
        
    }
    [self.buttonContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTopContainer)]];
    
    self.drawType = RED_TYPE;
    
    [self addButtonCaseToButton:self.redButton];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanGesture:)];
    
    [self.view addGestureRecognizer:panGesture];
    // Do any additional setup after loading the view.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedButton.layer.position"]) {
        self.buttonCase.center = self.selectedButton.center;
    }
}
-(void)didPanGesture:(UIPanGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self.textView isFirstResponder]) {
            [self.textView resignFirstResponder];
        }
        NSLog(@"began:%@",NSStringFromCGPoint(point));
        //        [self.caseView removeFromSuperview];
        self.startPoint = point;
        
    }else{
        NSLog(@"%@",NSStringFromCGPoint(point));
        if (self.drawType!=NONE) {
            //画箭头
            [self.arrowView removeFromSuperview];
            CGFloat distance = [self getDistanceFromStartPoint:self.startPoint toEndPoint:point];
            if (distance< 20) {
                return;
            }
            self.arrowView = [[ArrowView alloc]initWithFrame:self.view.bounds startPoint:self.startPoint endPoint:point withColor:self.selectedButton.backgroundColor];
            self.arrowView.backgroundColor = [UIColor clearColor];
            [self.view insertSubview:self.arrowView belowSubview:self.buttonContainerView];
            
        }
    }
    if(sender.state == UIGestureRecognizerStateEnded){
        self.endPoint = point;
        CGFloat distance = [self getDistanceFromStartPoint:self.startPoint toEndPoint:self.endPoint];
        if (distance< 20) {
            [self.arrowView removeFromSuperview];
            return;
        }
        
        [self.endPointArray addObject:[NSValue valueWithCGPoint:self.endPoint]];
        //画caseView
        [self createCaseViewWithArrowStartPoint:self.startPoint endPoint:self.endPoint inView:self.view];
    }
    
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
-(void)createCaseViewWithArrowStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint inView:(UIView*)view{
    CGFloat angle = [self getAngleFromStartPoint:startPoint endPoint:endPoint];
    self.angle = angle;
    [self.angleArray addObject:[NSNumber numberWithDouble:self.angle]];
    CGPoint point;
    CGSize size;
    self.textView = [[UITextView alloc]init];
    self.textView.font = [UIFont systemFontOfSize:self.view.frame.size.width>self.view.frame.size.height?self.view.frame.size.height/20:self.view.frame.size.width/20];
    self.textView.scrollEnabled = NO;
    
    self.textView.text = @"0";
    
    size = [self.textView sizeThatFits:CGSizeMake(100, MAXFLOAT)];
    self.textView.text = @"";
    //angle范围 -M_PI/2 to 3*M_PI/2
    
    if (angle>-M_PI/4 && angle<=M_PI/4) {
        point = CGPointMake(endPoint.x, endPoint.y-size.height/2);
    }else if(angle>M_PI/4 && angle<=M_PI*3/4){
        point = CGPointMake(endPoint.x-size.width/2, endPoint.y);
    }else if (angle>M_PI*3/4 && angle<M_PI*5/4){
        point = CGPointMake(endPoint.x-size.width, endPoint.y-size.height/2);
    }else{
        point = CGPointMake(endPoint.x-size.width/2, endPoint.y-size.height);
    }
    
    //    [self.caseView removeFromSuperview];
    
    self.caseView = [[CaseView alloc]initWithFrame:CGRectMake(point.x, point.y, size.width, size.height) withColor:self.selectedButton.backgroundColor];
    self.textView.frame = self.caseView.bounds;
    self.textView.textColor = self.selectedButton.backgroundColor;
    self.textView.font = [UIFont systemFontOfSize:self.view.frame.size.width>self.view.frame.size.height?self.view.frame.size.height/20:self.view.frame.size.width/20];
    self.caseView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    self.textView.tag = 1235;
    self.caseView.tag = 123;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.caseView addSubview:self.textView];
    [self.arrowView addSubview:self.caseView];
    
    NSLog(@"%g",angle);
}


-(void)didTap{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
        return;
    }
    if (self.navigationController.navigationBarHidden==YES) {
        
        self.topConstraint.constant = -64;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController setNavigationBarHidden:NO animated:YES];
            });
        }];
        
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.topConstraint.constant = 0;
        NSLog(@"%@",[NSThread mainThread]);
        [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

-(void)didTapTopContainer{
    NSLog(@"tap top view");
    [self.buttonCase removeFromSuperview];
    self.drawType = NONE;
}
#pragma mark - button
- (IBAction)clickSaveButton:(UIButton*)sender{
    [self saveScreenshotToPhotosAlbum:self.view];
}
- (IBAction)clickRedButton:(UIButton*)sender {
    [self addButtonCaseToButton:sender];
    self.drawType = RED_TYPE;
}
- (IBAction)clickGreenButton:(UIButton*)sender {
    [self addButtonCaseToButton:sender];
    self.drawType = GREEN_TYPE;
}
- (IBAction)clickYellowButton:(UIButton*)sender {
    [self addButtonCaseToButton:sender];
    self.drawType = YELLOW_TYPE;
}
-(void)addButtonCaseToButton:(UIButton*)button{
    [self.buttonCase removeFromSuperview];
    self.buttonCase.center = button.center;
    self.selectedButton = button;
    [button.superview insertSubview:self.buttonCase belowSubview:button];
}
#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"eee");
    
    if (textView.text.length>0) {
        CGFloat angle = self.angle;
        CGPoint endPoint = self.endPoint;
        CGPoint point;
        CGSize size = [self.textView sizeThatFits:CGSizeMake(self.view.frame.size.width>self.view.frame.size.height?self.view.frame.size.height/3:self.view.frame.size.width/3, MAXFLOAT)];;
        if (angle>-M_PI/4 && angle<=M_PI/4) {
            point = CGPointMake(endPoint.x, endPoint.y-size.height/2);
        }else if(angle>M_PI/4 && angle<=M_PI*3/4){
            point = CGPointMake(endPoint.x-size.width/2, endPoint.y);
        }else if (angle>M_PI*3/4 && angle<M_PI*5/4){
            point = CGPointMake(endPoint.x-size.width, endPoint.y-size.height/2);
        }else{
            point = CGPointMake(endPoint.x-size.width/2, endPoint.y-size.height);
        }
        self.caseView.frame = CGRectMake(point.x, point.y, size.width, size.height);
        self.textView.frame = self.caseView.bounds;
        [self.caseView setNeedsDisplay];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"endEdit");
    if (self.arrowViewArray.count==0) {
        self.currentTapIndex = 0;
    }
    //    ArrowView *arrowView = self.arrowViewArray[self.currentTapIndex];
    if ([self.arrowViewArray containsObject:self.arrowView]||self.arrowView ==nil) {
        
    }else{
        [self.arrowViewArray addObject:self.arrowView];
        self.arrowView = nil;
    }
    
    
    UIView *view = [[UIView alloc]initWithFrame:textView.superview.frame];
    view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:view aboveSubview:self.buttonContainerView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCaseView:)];
    //        tapGesture.delegate = self;
    [view addGestureRecognizer:tapGesture];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCaseView:)];
    //        longPressGesture.delegate = self;
    [view addGestureRecognizer:longPressGesture];
    NSLog(@"%ld",view.tag);
    [self.tapViewArray insertObject:view atIndex:self.currentTapIndex];
    
    self.currentTapIndex = self.arrowViewArray.count;
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"isShowedHelp"]){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"deleteSuggestion", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isShowedHelp"];
    
}
-(void)tapCaseView:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
    for (int i=0 ; i <self.tapViewArray.count; i++) {
        UIView *view = self.tapViewArray[i];
        if (sender.view == view) {
            self.currentTapIndex = i;
            break;
        }
    }
    ArrowView *arrowView=self.arrowViewArray[self.currentTapIndex];
    
    NSLog(@"%@:%ld",sender.view,sender.view.tag);
    //    self.caseView = sender.view.superview;
    self.textView = [arrowView viewWithTag:1235];
    self.caseView = [arrowView viewWithTag:123];
    NSValue *endPointValue = self.endPointArray[self.currentTapIndex];
    self.endPoint = [endPointValue CGPointValue];
    NSNumber *angleNumber = self.angleArray[self.currentTapIndex];
    self.angle = [angleNumber doubleValue];
    [self.textView becomeFirstResponder];
    [sender.view removeFromSuperview];
    [self.tapViewArray removeObject:sender.view];
}
-(void)longPressCaseView:(UILongPressGestureRecognizer*)sender{
    [self.view endEditing:YES];
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    NSInteger oldIndex = self.currentTapIndex;
    for (int i=0 ; i <self.tapViewArray.count; i++) {
        UIView *view = self.tapViewArray[i];
        if (sender.view == view) {
            self.currentTapIndex = i;
            break;
        }
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.deletePanStartPoint = point;
        [self startBlinkWith:self.arrowViewArray[self.currentTapIndex]];
    }else if(sender.state == UIGestureRecognizerStateEnded){
        [self.blinkTimer invalidate];
        self.blinkTimer = nil;
        self.blinkView.alpha = 1;
        self.deletePanEndPoint = point;
        ArrowView *arrowView=self.arrowViewArray[self.currentTapIndex];
        if ([self getDistanceFromStartPoint:self.deletePanStartPoint toEndPoint:self.deletePanEndPoint]>50) {
            self.caseView = [arrowView viewWithTag:123];
            [self.tapViewArray[self.currentTapIndex] removeFromSuperview];
            
            [self deleteArrowView:arrowView];
            oldIndex--;
        }
    }
    self.currentTapIndex = oldIndex;
}
-(void)dealloc{
    if (self.blinkTimer) {
        [self.blinkTimer invalidate];
        self.blinkTimer = nil;
    }
    
}

-(void)startBlinkWith:(UIView*)view{
    if (self.blinkTimer) {
        [self.blinkTimer invalidate];
    }
    self.blinkView = view;
    self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doBlinkAnimation) userInfo:nil repeats:YES];
    [self.blinkTimer fire];
}
-(void)doBlinkAnimation{
    UIView *view = self.blinkView;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha=0.5;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
}
-(CGFloat)getDistanceFromStartPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint{
    CGFloat angle = [self getAngleFromStartPoint:startPoint endPoint:endPoint];
    if (cos(angle)) {
        return abs((int)((endPoint.x-startPoint.x)/cos(angle)));
    }else {
        
        return abs((int)((endPoint.y-startPoint.y)));
    }
}
-(void)deleteArrowView:(UIView*)view{
    CGFloat transformX;
    CGFloat transformY;
    CGFloat angle = [self getAngleFromStartPoint:self.deletePanStartPoint endPoint:self.deletePanEndPoint];
    if (self.deletePanEndPoint.x>self.deletePanStartPoint.x) {
        transformX = self.view.frame.size.width - self.deletePanStartPoint.x;
        
    }else{
        transformX = -self.deletePanStartPoint.x;
        
    }
    transformY = transformX * tan(angle);
    //    view.layer.anchorPoint = [view viewWithTag:1235].superview.center;
    NSLog(@"%@",NSStringFromCGPoint(view.layer.anchorPoint));
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.transform = CGAffineTransformMakeTranslation(transformX,transformY);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if([self.arrowViewArray containsObject:view]){
            for (int i=0; i<self.arrowViewArray.count; i++) {
                UIView *viewIn = self.arrowViewArray[i];
                if (view == viewIn) {
                    [self.tapViewArray[i] removeFromSuperview];
                    [self.tapViewArray removeObject:self.tapViewArray[i]];
                    [self.endPointArray removeObject:self.endPointArray[i]];
                    [self.angleArray removeObject:self.angleArray[i]];
                }
            }
            [self.arrowViewArray removeObject:view];
            
        }
    }];
}
#pragma mark - keyboard
-(void)openKeyboard:(NSNotification*)notification{
    if (self.endPoint.y<self.view.frame.size.height/2) {
        return;
    }
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    CGRect rect = self.view.frame;
    rect.origin.y = -keyboardFrame.size.height;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.view.frame = rect;
    } completion:^(BOOL finished) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //        });
    }];
    
}
-(void)closeKeyboard:(NSNotification*)notification{
    if (self.endPoint.y<self.view.frame.size.height/2) {
        return;
    }
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self scrollToBottom:NO];
        //        });
    }];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - lazyLoad
- (UIView *)buttonCase {
    if(_buttonCase == nil) {
        _buttonCase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(2, 2, 36, 36)];
        [_buttonCase addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        _buttonCase.backgroundColor = [UIColor colorWithRed:0.265 green:0.592 blue:1.000 alpha:1.000];
    }
    return _buttonCase;
}
- (NSMutableArray *)arrowViewArray {
    if(_arrowViewArray == nil) {
        _arrowViewArray = [[NSMutableArray alloc] init];
    }
    return _arrowViewArray;
}
- (NSMutableArray *)tapViewArray {
    if(_tapViewArray == nil) {
        _tapViewArray = [[NSMutableArray alloc] init];
    }
    return _tapViewArray;
}
- (NSMutableArray *)endPointArray {
    if(_endPointArray == nil) {
        _endPointArray = [[NSMutableArray alloc] init];
    }
    return _endPointArray;
}
- (NSMutableArray *)angleArray {
    if(_angleArray == nil) {
        _angleArray = [[NSMutableArray alloc] init];
    }
    return _angleArray;
}
@end


@interface ArrowView()
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGPoint endPoint;
@property(nonatomic,strong) UIColor *color;
@end
@implementation ArrowView
-(instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint withColor:(UIColor*)color{
    self = [self initWithFrame:frame];
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.color = color;
    return self;
}
-(void)drawRect:(CGRect)rect{
    if (!self.color) {
        return;
    }
    CGFloat angle;
    CGFloat arrowAngle = 70.0/360*M_PI;
    CGFloat arrowAngleLength = 20;
    CGFloat arrowLineAngle = 15.0/360*M_PI;
    CGFloat arrowLineAngleLength = 8;
    CGFloat halfLineWidth = sin(arrowLineAngle) * arrowLineAngleLength;
    if (self.endPoint.x == self.startPoint.x) {
        angle = self.endPoint.y>self.startPoint.y?(M_PI/2):(M_PI*3/2);
    }else if(self.endPoint.x > self.startPoint.x){
        angle = atan((self.endPoint.y-self.startPoint.y)/(self.endPoint.x-self.startPoint.x));
    }else{
        angle = atan((self.endPoint.y-self.startPoint.y)/(self.endPoint.x-self.startPoint.x))+M_PI;
    }
    
    CGPoint point1 = CGPointMake(self.startPoint.x + arrowAngleLength * cos(angle-arrowAngle), self.startPoint.y + arrowAngleLength * sin(angle-arrowAngle));
    
    CGPoint point2 = CGPointMake(self.startPoint.x + arrowLineAngleLength * cos(angle-arrowLineAngle), self.startPoint.y + arrowLineAngleLength * sin(angle-arrowLineAngle));
    
    CGPoint point3 = CGPointMake(self.endPoint.x + halfLineWidth * sin(angle), self.endPoint.y - halfLineWidth * cos(angle));
    CGPoint point4 = CGPointMake(self.endPoint.x - halfLineWidth * sin(angle), self.endPoint.y + halfLineWidth * cos(angle));
    
    CGPoint point5 = CGPointMake(self.startPoint.x + arrowLineAngleLength * cos(angle+arrowLineAngle), self.startPoint.y + arrowLineAngleLength * sin(angle+arrowLineAngle));
    CGPoint point6 = CGPointMake(self.startPoint.x + arrowAngleLength * cos(angle+arrowAngle), self.startPoint.y + arrowAngleLength * sin(angle+arrowAngle));
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    //利用path进行绘制三角形
    //    CGContextBeginPath(context);//标记
    //    CGContextMoveToPoint(context,self.startPoint.x, self.startPoint.y);//设置起点
    //
    //    CGContextAddLineToPoint(context,point1.x, point1.y);
    //    CGContextAddLineToPoint(context,point2.x, point2.y);
    //    CGContextAddLineToPoint(context,point3.x, point3.y);
    //    CGContextAddLineToPoint(context,point4.x, point4.y);
    //    CGContextAddLineToPoint(context,point5.x, point5.y);
    //    CGContextAddLineToPoint(context,point6.x, point6.y);
    //    CGContextClosePath(context);//路径结束标志，不写默认封闭
    //    [self.color setFill];
    //    //设置填充色
    //    [[UIColor clearColor] setStroke];
    ////    //设置边框颜色
    //    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path closePath];
    //    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [self.color set];
    [path fill];
    path.lineWidth = 3;
    [path stroke];
}

@end
@interface CaseView()
@property(nonatomic,strong) UIColor *color;
@end
@implementation CaseView
-(instancetype)initWithFrame:(CGRect)frame withColor:(UIColor *)color{
    self = [self initWithFrame:frame];
    self.color = color;
    return self;
}
-(void)drawRect:(CGRect)rect{
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [self.color set];
    path.lineWidth = 7;
    
    [path stroke];
}





@end