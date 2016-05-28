//
//  SourceViewController.m
//  AVOSDemo
//
//  Created by Travis on 13-12-11.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "SourceViewController.h"
#import "WHDrawViewController.h"
#import "WHTapHelpView.h"
static NSString *html = nil;

@interface SourceViewController ()<UIWebViewDelegate>

@end

@implementation SourceViewController

+(NSString *)htmlRoot{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
}


- (id)init
{
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        self.view.backgroundColor = self.webView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        [self.view insertSubview:self.webView atIndex:0];
        self.view.autoresizingMask = self.webView.autoresizingMask;
        
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isShowedHelp"]) {
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[WHTapHelpView class]]) {
                WHTapHelpView *tapView = (WHTapHelpView*)view;
                [tapView removeFromSuperview];
                tapView = nil;
                __weak typeof(self)weekSelf = self;
                [[UIApplication sharedApplication].keyWindow addSubview:[WHTapHelpView viewWithRect:CGRectMake([UIScreen mainScreen].bounds.size.width-98, 20, 90, 44)didClickRect:^{
                    __strong typeof(weekSelf)safe = weekSelf;
                    [safe startScreenShot];
                }]];
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.minimumZoomScale = 0.02;
    self.webView.scrollView.maximumZoomScale = 50;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isShowedHelp"]) {
        __weak typeof(self)safe = self;
        [[UIApplication sharedApplication].keyWindow addSubview:[WHTapHelpView viewWithRect:CGRectMake([UIScreen mainScreen].bounds.size.width-78, 20, 70, 44)didClickRect:^{
            __strong typeof(safe)strongSafe = safe;
            [strongSafe startScreenShot];
        }]];
    }
    //CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"screenShot", nil) style:UIBarButtonItemStylePlain target:self action:@selector(startScreenShot)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"<%@",NSLocalizedString(@"back", nil)] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
    label.center = self.view.center;
    label.backgroundColor = [UIColor colorWithWhite:0.841 alpha:0.720];
    label.text = NSLocalizedString(@"loading", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 20;
    label.tag = 999;
    [self.view addSubview:label];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self performSelector:@selector(loadSource) withObject:nil afterDelay:0.1];
    
}
-(void)startScreenShot{
    WHDrawViewController * drawController = [[WHDrawViewController alloc]initWithNibName:@"WHDrawViewController" bundle:nil withBkgView:self.view];
    
    [self.navigationController pushViewController:drawController animated:YES];
}
-(void)loadCode:(NSString *)code{
    if (code) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (html == nil) {
                html = [NSString stringWithContentsOfFile:[[[self class] htmlRoot] stringByAppendingPathComponent:@"index.html"] encoding:NSUTF8StringEncoding error:nil];
            }
            NSMutableString * str = [NSMutableString stringWithString:code];
            while (1) {
                NSRange range = [str rangeOfString:@"<"];
                if (!range.length) {
                    break;
                }
                [str replaceCharactersInRange:range withString:@"&#60;"];
            }
            while (1) {
                
                NSRange range = [str rangeOfString:@">"];
                if (!range.length) {
                    break;
                }
                [str replaceCharactersInRange:range withString:@"&#62;"];

                
            }
            NSString *htmlCode = [html stringByReplacingOccurrencesOfString:@"__CODE__" withString:str];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView
                 loadHTMLString:htmlCode
                 baseURL:[NSURL fileURLWithPath:[[self class] htmlRoot] isDirectory:YES]];
                
                [self loadFinished];
            });
        });
        
    }
}

-(void)loadFinished{
    NSLog(@"load complete");
    [[self.view viewWithTag:999]removeFromSuperview];
}
-(void)loadSource{
    if (self.filePath) {
        self.title = [self.filePath lastPathComponent];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *code = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadCode:code];
            });  
        });
        
        
        
        
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"load complete");
    
}

@end
