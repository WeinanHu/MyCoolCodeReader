//
//  UIImage+WHThumbnailImage.m
//  酷跑
//
//  Created by Wayne on 16/5/17.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "UIImage+WHThumbnailImage.h"

@implementation UIImage (WHThumbnailImage)
-(UIImage*)thumbNailWithSize:(CGSize)size{
    if (!self) {
        return nil;
    }
    CGSize imageSize = self.size;
    if (imageSize.width/imageSize.height>size.width/size.height) {
        imageSize = CGSizeMake(size.width, size.width*imageSize.height/imageSize.width);
    }else{
        imageSize = CGSizeMake(size.height * imageSize.width/imageSize.height, size.height);
    }
    UIGraphicsBeginImageContext(imageSize);
    [self drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
