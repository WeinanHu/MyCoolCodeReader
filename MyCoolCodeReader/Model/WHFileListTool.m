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
    
    
    return [self getFilesAtPath:path];
}
-(NSArray*)getFilesAtPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:path error:&error];
    
    return [self toModelsWithPathes:files];
}
-(NSArray*)toModelsWithPathes:(NSArray*)pathes{
    NSMutableArray *mutaArr = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in pathes) {
        BOOL isDirectory;
        if (![fileManager fileExistsAtPath:[DOCUMENT_DIRECTORY stringByAppendingPathComponent:path] isDirectory:&isDirectory]){
            continue;
        }
        //去掉.开头的文件
        if([[[path lastPathComponent] substringToIndex:1]isEqualToString:@"."]) {
            continue;
        }
        NSLog(@"%d",isDirectory);
        WHFile *file = [WHFile new];
        file.fileName = [DOCUMENT_DIRECTORY stringByAppendingPathComponent:[path lastPathComponent]];
        file.isDirectory = isDirectory;
        [mutaArr addObject:file];
    }
    return [mutaArr copy];
//    WHFile *file = [WHFile new];
    return nil;
}

+(void)creatHelloWorld{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HelloWorld.txt" ofType:nil];
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"bundle error:%@",error.userInfo);
        return;
    }
    NSString *file = [DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"HelloWorld.m"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:file isDirectory:nil]) {
        return;
    }
    [string writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"write error:%@",error.userInfo);
    }
}
@end
