//
//  WHChangeCssColor.m
//  MyCoolCodeReader
//
//  Created by Wayne on 16/6/1.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHChangeCssColor.h"

@implementation WHChangeCssColor
+(NSArray*)getCssColorWithPath:(NSString *)path{
    NSError *error = nil;
    NSString *cssContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        return nil;
    }
    NSMutableArray *mutaArr = [NSMutableArray array];
    while (1) {
        NSRange range = [cssContent rangeOfString:@" #"];
        if (range.length == 0) {
            break;
        }
        
        NSMutableString *mutaStr = [NSMutableString stringWithFormat:@"#"];
        int index = 0;
        while (1) {
            char charStr = [cssContent characterAtIndex:range.length+range.location+index];
            if ((charStr >= '0' && charStr<='9')||(charStr>='a' && charStr<='f')||(charStr >='A'&& charStr<='F')) {
                [mutaStr appendString:[NSString stringWithFormat:@"%c",charStr]];
            }else{
                break;
            }
            index++;
            if (index>10) {
                break;
            }
        }
        [mutaArr addObject:mutaStr];
        
        cssContent = [cssContent substringFromIndex:(range.location+range.length)];
    }
    return mutaArr;
}

+(void)changeCssFileAtPath:(NSString*)path withArray: (NSArray*)array{
    NSError *error = nil;
    NSMutableString *cssContent = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        return;
    }
    NSRange searchRange = (NSRange){0,cssContent.length};
    int replaceIndex = 0;
    while (1) {
        NSRange range = [cssContent rangeOfString:@" #" options:NSLiteralSearch range:searchRange];
        if (range.length == 0) {
            break;
        }
        
        int index = 0;
        while (1) {
            char charStr = [cssContent characterAtIndex:range.length+range.location+index];
            if ((charStr >= '0' && charStr<='9')||(charStr>='a' && charStr<='f')||(charStr >='A'&& charStr<='F')) {

            }else{
                break;
            }
            index++;
            if (index>10) {
                break;
            }
        }
        NSRange colorRange = (NSRange){range.length+range.location-1, index+1};
        
        [cssContent replaceCharactersInRange:colorRange withString:array[replaceIndex]];
        
        searchRange = (NSRange){colorRange.location + colorRange.length, cssContent.length - (colorRange.location + colorRange.length)};
        replaceIndex++;
    }
    NSError *writeError = nil;
    [cssContent writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
//    [self changeHTMLBackgroundColorWith:array cssPath:path];
    
}
+(void)changeHTMLBackgroundColorWith:(NSArray*)array cssPath:(NSString*)path{
    //index.html修改背景色
    NSString *indexPath = [[path stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"]) {
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"highlightStyle"];
    }
    NSInteger style = [[NSUserDefaults standardUserDefaults]integerForKey:@"highlightStyle"];
    indexPath = [indexPath stringByAppendingPathComponent:[NSString stringWithFormat:@"index%ld.html",style]];
//    indexPath = [indexPath stringByAppendingPathComponent:@"index.html"];
    NSError *error = nil;
    NSMutableString *indexString = [NSMutableString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return;
    }
    NSRange range = [indexString rangeOfString:@"background-color:"];
    if (range.length == 0) {
        return;
    }
    int index = 0;
    while (1) {
        char charStr = [indexString characterAtIndex:range.length+range.location+1+index];
        if ((charStr >= '0' && charStr<='9')||(charStr>='a' && charStr<='f')||(charStr >='A'&& charStr<='F')) {
            
        }else{
            break;
        }
        index++;
        if (index>10) {
            break;
        }
    }
    NSRange replaceRange = (NSRange){range.length+range.location,index+1 };
    [indexString replaceCharactersInRange:replaceRange withString:array[0]];
    [indexString writeToFile:indexPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
@end
