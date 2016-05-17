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
static NSProgress* pro;
-(void)addDownload:(NSURL *)url progress:(NSProgress *)progress{
    if (self.downloadList ==nil) {
        self.downloadList = [NSMutableArray array];
    }
    pro = progress;
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showProgress:) userInfo:nil repeats:YES];
    NSDictionary *dic = @{@"url":url,@"progress":progress};
    [self.downloadList addObject:dic];
}
-(void)showProgress:(NSProgress *)progress{
    if (pro.totalUnitCount) {
        
        NSLog(@"%g",1.0*pro.completedUnitCount/pro.totalUnitCount);
    }
}
@end
