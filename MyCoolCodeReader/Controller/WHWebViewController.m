//
//  WHWebViewController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHWebViewController.h"
#import "AFNetworking.h"
#import "WHDownloadTool.h"
@interface WHWebViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong) NSURL *downloadURL;
@end

@implementation WHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaviItem];
    // Do any additional setup after loading the view.
}
-(void)setUpNaviItem{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStylePlain target:self action:@selector(clickDownloadButton)];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)clickDownloadButton{
    NSArray *array = [[WHDownloadTool sharedWHDownloadTool]getDownloadList];
    if (array.count) {
        
        NSLog(@"%@",array[0][@"progress"]);
    }
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
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request);
    //    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
    NSURL *URL = request.URL;
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) safe = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error==nil) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSDictionary *dic = [(NSHTTPURLResponse *)response allHeaderFields];
                NSString *contentType = (NSString*)[dic objectForKey:@"Content-Type"];
                NSString *contentDisposition = [dic objectForKey:@"Content-Disposition"];
                NSLog(@"=== %@ : %@", contentType, contentDisposition);
                
                if ([contentDisposition containsString:@"filename="]) {
                    safe.downloadURL = URL;
                    NSLog(@"发现下载链接");
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发现下载链接" message:@"是否下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
                    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
                    [alertView show];
                }
            }
        }
    }];
    [task resume];
    
    
    //    }
    
    return YES;
    
}
-(void)downloadWithURL:(NSURL*)URL {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSProgress *progress = [[NSProgress alloc]init];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        [[WHDownloadTool sharedWHDownloadTool]addDownload:URL progress:progress];
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消下载");
            break;
            
        default:
            
            [self downloadWithURL:self.URL];
            break;
    }
}
@end
