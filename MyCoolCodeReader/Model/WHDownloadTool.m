//
//  WHDownloadTool.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/16.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHDownloadTool.h"
@interface WHDownloadTool()
    @property(nonatomic,strong) NSMutableArray *downloadList;

@end
@implementation WHDownloadTool
singleton_implementation(WHDownloadTool);

- (NSMutableArray *)downloadList {
	if(_downloadList == nil) {
		_downloadList = [[NSMutableArray alloc] init];
	}
	return _downloadList;
}
-(NSMutableArray *)getDownloadList{
    return self.downloadList;
    
}
-(void)addDownload:(NSURL *)url progress:(NSProgress *)progress{
    if (self.downloadList ==nil) {
        self.downloadList = [NSMutableArray array];
    }
    NSDictionary *dic = @{@"url":url,@"progress":progress};
    [self.downloadList addObject:dic];
}
@end
