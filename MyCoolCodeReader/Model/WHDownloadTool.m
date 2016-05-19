//
//  WHDownloadTool.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHDownloadTool.h"
#import "AFNetworking.h"

@interface WHDownloadTool()

@end
@implementation WHDownloadTool
singleton_implementation(WHDownloadTool);


-(NSArray *)getDownloadList{
    return [self.downloadList copy];
    
}
-(NSArray *)getProgressList{
    return [self.progressArray copy];
}

-(void)removeManagerAtIndex:(NSInteger)index{
    AFURLSessionManager *manager = self.netManagerArray[index];
    for (NSURLSessionTask* task in manager.tasks) {
        [task cancel];
    }
    [manager invalidateSessionCancelingTasks:YES];
    NSLog(@"%ld",self.netManagerArray.count);
    [self.netManagerArray removeObjectAtIndex:index];
}
-(void)downloadWithURL:(NSURL*)url{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSProgress *progress = [[NSProgress alloc]init];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSUInteger sameFileCount = 0;
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[response suggestedFilename]];
        NSString *tmpStr = [filePath stringByDeletingPathExtension];
        while ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            sameFileCount++;
            
            NSString *addTmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@"%ld",sameFileCount]];
            filePath = [addTmpStr stringByAppendingPathExtension:[filePath pathExtension]];
        }
        NSURL *documentsDirectoryURL = [[NSURL alloc]initFileURLWithPath:filePath];
        return documentsDirectoryURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        
    }];

    //加载进数组
    [self.netManagerArray addObject:manager];
    [downloadTask resume];
    NSString *urlStr = [url absoluteString];
    
    urlStr = [urlStr stringByDeletingLastPathComponent];
    urlStr = [urlStr stringByDeletingLastPathComponent];
    urlStr = [urlStr lastPathComponent];
    WHDownloadFile *downloadFile = [WHDownloadFile new];
    downloadFile.fileName = urlStr;
    downloadFile.downloadURL = url;
    downloadFile.fileStatus = IS_DOWNLOADING;
    [self.downloadList addObject:downloadFile];
    [self.progressArray addObject:progress];
}


#pragma mark - lazyLoad
- (NSMutableArray *)downloadList {
    if(_downloadList == nil) {
        _downloadList = [NSMutableArray array];
    }
    return _downloadList;
}
- (NSMutableArray *)progressArray {
    if(_progressArray == nil) {
        _progressArray = [NSMutableArray array];
    }
    return _progressArray;
}
- (NSMutableArray *)netManagerArray {
	if(_netManagerArray == nil) {
		_netManagerArray = [[NSMutableArray alloc] init];
	}
	return _netManagerArray;
}

@end
