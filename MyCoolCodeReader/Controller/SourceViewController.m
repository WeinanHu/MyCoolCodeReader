//
//  SourceViewController.m
//  AVOSDemo
//
//  Created by Travis on 13-12-11.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "SourceViewController.h"
#import "WHDrawViewController.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"screenShot", nil) style:UIBarButtonItemStylePlain target:self action:@selector(startScreenShot)];
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
            
            NSString *htmlCode = [html stringByReplacingOccurrencesOfString:@"__CODE__" withString:code];
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
