//
//  WHFileListTool.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/14.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHFileListTool.h"

@implementation WHFileListTool
static WHFileListTool* fileListTool;
+(instancetype)shareFileListTool{
    if (!fileListTool) {
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            fileListTool = [[WHFileListTool alloc]init];
        });
    }
    return fileListTool;
}
-(NSArray*)getFilesInDocument{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:path error:&error];
    
    return [self toModelsWithPathes:files];
}
-(NSArray*)getFilesAtPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:path error:&error];
    
    return [self toModelsWithPathes:files];
}
-(NSArray*)toModelsWithPathes:(NSArray*)pathes{
    NSMutableArray *arr = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    for (NSString *path in pathes) {

        NSDictionary *dic = [fileManager attributesOfItemAtPath:path error:&error];
        NSLog(@"%@",dic);
    }
//    WHFile *file = [WHFile new];
    return nil;
}
@end
