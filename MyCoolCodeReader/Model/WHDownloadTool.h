//
//  WHDownloadTool.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface WHDownloadTool : NSObject
singleton_interface(WHDownloadTool);
-(NSArray*)getDownloadList;
-(void)addDownload:(NSURL*)url progress:(NSProgress *)progress;
@end
