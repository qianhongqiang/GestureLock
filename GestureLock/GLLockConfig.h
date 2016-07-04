//
//  GLLockConfig.h
//  GestureLock
//
//  Created by qianhongqiang on 16/7/4.
//  Copyright © 2016年 最美应用. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLLockView;

typedef NS_ENUM(NSInteger, GLLockViewFunction) {
    GLLockViewFunctionSettingPassword,//设置密码
    
    GLLockViewFunctionAuthentication//验证密码
};

@protocol GLLockConfigProtocol <NSObject>
@required
-(GLLockViewFunction)functionOflockView:(GLLockView *)lockView;

-(UIImage *)lockView:(GLLockView *)lockView selectedImageForSingleItemAtRow:(NSInteger)row column:(NSInteger)column;
-(UIImage *)lockView:(GLLockView *)lockView normalImageForSingleItemAtRow:(NSInteger)row column:(NSInteger)column;

@end

@interface GLLockConfig : NSObject<GLLockConfigProtocol>

-(GLLockViewFunction)functionOflockView:(GLLockView *)lockView;

@end
