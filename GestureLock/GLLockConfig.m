//
//  GLLockConfig.m
//  GestureLock
//
//  Created by qianhongqiang on 16/7/4.
//  Copyright © 2016年 最美应用. All rights reserved.
//

#import "GLLockConfig.h"

@implementation GLLockConfig

-(GLLockViewFunction)functionOflockView:(GLLockView *)lockView
{
    return GLLockViewFunctionSettingPassword;
}

-(UIImage *)lockView:(GLLockView *)lockView normalImageForSingleItemAtRow:(NSInteger)row column:(NSInteger)column
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 80, 80));
    CGContextStrokePath(ctx);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)lockView:(GLLockView *)lockView selectedImageForSingleItemAtRow:(NSInteger)row column:(NSInteger)column
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 80, 80));
    CGContextStrokePath(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(24, 24, 32, 32));
    CGContextFillPath(ctx);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
