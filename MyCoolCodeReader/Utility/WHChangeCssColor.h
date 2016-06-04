//
//  WHChangeCssColor.h
//  MyCoolCodeReader
//
//  Created by Wayne on 16/6/1.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHChangeCssColor : NSObject
+(NSArray*)getCssColorWithPath:(NSString *)path;
+(void)changeCssFileAtPath:(NSString*)path withArray: (NSArray*)array;
+(void)changeHTMLBackgroundColorWith:(NSArray*)array cssPath:(NSString*)path;
@end
