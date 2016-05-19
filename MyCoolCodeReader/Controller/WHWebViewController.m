//
//  WHWebViewController.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHWebViewController.h"
#import "WHDownloadTool.h"
#import "WHDownloadListController.h"
#import "WHWebsiteListController.h"
@interface WHWebViewController ()<UIAlertViewDelegate,UIPopoverPresentationControllerDelegate>
@property(nonatomic,strong) NSURL *downloadURL;
@property(nonatomic,strong) WHDownloadListController *downloadListController;
@end

@implementation WHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaviItem];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.fromController showBackButton];
}
-(void)setUpNaviItem{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStylePlain target:self action:@selector(clickDownloadButton)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"<%@",NSLocalizedString(@"back", nil)] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickDownloadButton{
    
//    if (![WHDownloadTool sharedWHDownloadTool].progressArray.count) {
//        return;
//    }
//    NSProgress *progress2 = [WHDownloadTool sharedWHDownloadTool].progressArray[0];
//    if (progress2) {
//        
//        NSLog(@"_______%@",progress2);
//    }
//    WHDownloadListController *downloadListController = [WHDownloadListController new];
//    downloadListController.preferredContentSize = CGSizeMake(200, 400);
//    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:downloadListController];
//    [popoverController presentPopoverFromRect:CGRectMake([UIScreen mainScreen].bounds.size.width-64, 20, 64, 44) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
    
    self.downloadListController.modalPresentationStyle = UIModalPresentationPopover;
    self.downloadListController.popoverPresentationController.sourceView = self.view;
    self.downloadListController.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width-68, 20, 64, 44);
    self.downloadListController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    self.downloadListController.popoverPresentationController.delegate = self;
    [self presentViewController:self.downloadListController animated:YES completion:nil];
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
    NSURL *URL = request.URL;
    NSString *urlStr = [URL absoluteString];
    if ([urlStr containsString:@"codeload.github.com/"]&&[urlStr containsString:@"/zip/master"]) {
        self.downloadURL = URL;
        NSLog(@"发现下载链接");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"discoverDownload", nil) message:NSLocalizedString(@"downloadFile", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        [alertView show];
        
        
    }else if([[[[URL URLByDeletingLastPathComponent]URLByDeletingLastPathComponent]absoluteString ]isEqualToString:@"https://github.com/"]){
        NSString *sourceStr = [NSString stringWithFormat:@"%@/%@",[[urlStr stringByDeletingLastPathComponent]lastPathComponent ] ,[urlStr lastPathComponent]];
        NSString *completeSourceStr = [NSString stringWithFormat:@"https://codeload.github.com/%@/zip/master",sourceStr];
        NSString *info =[NSString stringWithFormat:@"获取到%@",sourceStr.lastPathComponent];
        self.downloadURL = [NSURL URLWithString:completeSourceStr];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"discoverDownload", nil) message:NSLocalizedString(@"downloadFile", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];

        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        [alertView show];
    }
    
    
    return YES;
    
}
-(void)downloadWithURL:(NSURL*)URL {
    
    [[WHDownloadTool sharedWHDownloadTool]downloadWithURL:URL];
    
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消下载");
            break;
            
        default:
            
            [self downloadWithURL:self.downloadURL];
            break;
    }
    
}
#pragma mark - UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
#pragma mark - lazyload
- (WHDownloadListController *)downloadListController {
	if(_downloadListController == nil) {
		_downloadListController = [[WHDownloadListController alloc] init];
	}
	return _downloadListController;
}

@end
