//
//  WHDownloadTool.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHDownloadFile.h"
#import "Singleton.h"
@interface WHDownloadTool : NSObject
singleton_interface(WHDownloadTool);
-(NSArray*)getDownloadList;

-(void)downloadWithURL:(NSURL*)url;
-(NSArray*)getProgressList;
-(void)removeManagerAtIndex:(NSInteger)index;
@property(nonatomic,strong) NSMutableArray *downloadList;
@property(nonatomic,strong) NSMutableArray *progressArray;
@property(nonatomic,strong) NSMutableArray *netManagerArray;

@end
