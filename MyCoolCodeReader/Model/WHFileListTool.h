//
//  WHFileListTool.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/14.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHFile.h"
#define DOCUMENT_DIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
@interface WHFileListTool : NSObject
+(instancetype)shareFileListTool;
-(NSArray*)getFilesInDocument;

-(NSArray*)getFilesAtPath:(NSString*)path;
+(void)creatHelloWorld;
@end
