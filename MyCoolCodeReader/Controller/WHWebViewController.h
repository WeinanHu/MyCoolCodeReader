//
//  WHWebViewController.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "PBWebViewController.h"
#import "WHWebsiteListController.h"
@interface WHWebViewController : PBWebViewController
@property(nonatomic,strong) WHWebsiteListController *fromController;
@end
