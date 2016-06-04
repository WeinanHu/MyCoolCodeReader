//
//  WHDownloadFile.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/18.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    READY_TO_DOWNLOAD,
    IS_DOWNLOADING,
    FINISH_DOWNLOAD
}FILE_STATUS;
@interface WHDownloadFile : NSObject
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,assign) FILE_STATUS fileStatus;
@property(nonatomic,strong) NSURL *downloadURL;

@end
