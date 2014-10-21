//
//  UIImage_Thumbnail.m
//  CardOrganizer
//
//  Created by Jiang on 2014-10-20.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage_Thumbnail.h"

@implementation UIImage (Thumbnail)

- (UIImage *)imageByScalingToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end