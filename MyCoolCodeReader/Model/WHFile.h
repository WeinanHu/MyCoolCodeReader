//
//  WHFile.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/5/14.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHFile : NSObject
@property(nonatomic,assign) BOOL isDirectory;
@property(nonatomic,strong) NSString *fileName;
@end
