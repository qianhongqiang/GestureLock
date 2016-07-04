//
//  GLLockView.h
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLLockConfig;

typedef void(^settingGestureSuccessCallBack)(NSString *gesPsd);
typedef void(^athenGestureCallBack)(NSString *gesPsd);

@interface GLLockView : UIView

typedef NS_ENUM(NSInteger, GLLockLoginState) {
    GLLockLoginStateSuccess,
    
    GLLockLoginStateFailure
};

-(instancetype)initWithFrame:(CGRect)frame
                      config:(GLLockConfig *)config
      settingPasswordSuccess:(settingGestureSuccessCallBack)settingSuccess
                athenSuccess:(athenGestureCallBack)athenSuccess;

@end

