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
#import "WHChangeCssColor.h"
#import "UIColor+WHColor.h"
static NSString *html = nil;

@interface SourceViewController ()<UIWebViewDelegate>

@end

@implementation SourceViewController




- (id)init
{
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
//        self.view.backgroundColor = self.webView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        //背景
        NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        if (![[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"]) {
            [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"highlightStyle"];
        }
        NSInteger style = [[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"];
        NSString *filePath = [path stringByAppendingPathComponent:@"Preferences/html/prettify"];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"desert%ld.css",style]];
        
        NSArray *colorArray = [WHChangeCssColor getCssColorWithPath:filePath];
        self.view.backgroundColor = self.webView.backgroundColor = [UIColor colorWithHexColor:colorArray[0]];
        [WHChangeCssColor changeHTMLBackgroundColorWith:colorArray cssPath:filePath];
        
        
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
-(NSString*)chooseHtmlWithPath:(NSString*)path{
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"]) {
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"highlightStyle"];
    }
    NSInteger style = [[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"index%ld.html",style]];
    return filePath;
}
-(void)loadCode:(NSString *)code{
    if (code) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
            path = [path stringByAppendingPathComponent:@"Preferences/html"];
//            if (html == nil) {
                html = [NSString stringWithContentsOfFile:[self chooseHtmlWithPath:path] encoding:NSUTF8StringEncoding error:nil];
//            }
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
//            path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
//            path = [path stringByAppendingPathComponent:@"Preferences/html"];
            path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/html"];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.webView
//                 loadHTMLString:htmlCode
//                 baseURL:[NSURL fileURLWithPath:[[self class] htmlRoot] isDirectory:YES]];
//                [self.webView loadHTMLString:htmlCode baseURL:[NSURL fileURLWithPath:path isDirectory:YES]];
            [self removeCachesAndCookies];
            [htmlCode writeToFile:[path stringByAppendingPathComponent:@"index0.html"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"index0.html"]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSLog(@"%@",[path stringByAppendingPathComponent:@"prettify/desert.css"]);
//            [request setHTTPShouldHandleCookies:NO];
//            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView loadRequest:request];
                [self loadFinished];
            });
        });
    
    }
}
-(void)removeCachesAndCookies{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSArray *subPathes = [[NSFileManager defaultManager]subpathsAtPath:path];
    NSLog(@"subPathes:%@",subPathes);
    path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/html/prettify/desert.css"];
    NSString *cssPath = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",cssPath);
//    for (NSString *subPath in subPathes) {
//        if([subPath containsString:@"/."]){
//            [[NSFileManager defaultManager]removeItemAtPath:subPath error:nil];
//        }
//    }
}
-(void)loadFinished{
    NSLog(@"load complete");
    for (UIView *view in self.view.subviews) {
        
        if (view.tag == 999){
            [view removeFromSuperview];
        }
    }
}
-(void)loadSource{
    if (self.filePath) {
        self.title = [self.filePath lastPathComponent];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *code = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadCode:code];
//            });  
        });
        
        
        
        
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"load complete");
    
}

@end
