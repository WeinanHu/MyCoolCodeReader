//
//  WHFileListTool.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/14.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHFile.h"
@interface WHFileListTool : NSObject
+(instancetype)shareFileListTool;
-(NSArray*)getFilesInDocument;

-(NSArray*)getFilesAtPath:(NSString*)path;
@end
