//
//  AppDelegate.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/14.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "AppDelegate.h"
#import "WHFileListController.h"
#import "WHFileListTool.h"
#import "WHWebsiteListController.h"
#import "WHSettingTableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //1
    WHFileListController *fileListController =[[WHFileListController alloc]init];
    fileListController.index = 0;
    fileListController.currentPath = DOCUMENT_DIRECTORY;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:fileListController];
    //2
    WHWebsiteListController *webListController = [[WHWebsiteListController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *naviSecond = [[UINavigationController alloc]initWithRootViewController:webListController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    //3
    WHSettingTableViewController *settingController = [[WHSettingTableViewController alloc]initWithNibName:@"WHSettingTableViewController" bundle:nil];
    UINavigationController *naviThird = [[UINavigationController alloc]initWithRootViewController:settingController];
    

    
    [tabBarController setViewControllers:@[navi,naviSecond,naviThird]];
    [tabBarController setSelectedIndex:0];
    navi.tabBarItem.title = NSLocalizedString(@"myFile", nil);
    navi.tabBarItem.image = [UIImage imageNamed:@"file"];
    navi.tabBarItem.selectedImage = [UIImage imageNamed:@"file_select"];
    naviSecond.tabBarItem.title = NSLocalizedString(@"webDownload", nil);
    naviSecond.tabBarItem.image = [UIImage imageNamed:@"net"];
    naviSecond.tabBarItem.selectedImage = [UIImage imageNamed:@"net_select"];
    naviThird.tabBarItem.title = NSLocalizedString(@"setting", nil);
    naviThird.tabBarItem.image = [UIImage imageNamed:@"setting"];
    naviThird.tabBarItem.selectedImage = [UIImage imageNamed:@"setting_select"];

//    int line = 64;
//    navi.tabBarItem.image = [[UIImage imageNamed:@"file"] thumbNailWithSize:CGSizeMake(line, line)];
//    navi.tabBarItem.selectedImage = [[UIImage imageNamed:@"file_select"] thumbNailWithSize:CGSizeMake(line, line)];
//    naviSecond.tabBarItem.title = @"网络下载";
//    naviSecond.tabBarItem.image = [[UIImage imageNamed:@"net"]thumbNailWithSize:CGSizeMake(line, line)];
//    naviSecond.tabBarItem.selectedImage = [[UIImage imageNamed:@"net_select"]thumbNailWithSize:CGSizeMake(line, line)];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    [[WHFileListTool shareFileListTool]loadUserInfo];
    // Override point for customization after application launch.
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
