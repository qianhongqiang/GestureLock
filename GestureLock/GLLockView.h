//
//  GLLockView.h
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLLockConfig;

typedef void(^addGestureCallBack)(NSString *gesPsd);
typedef void(^athenGestureCallBack)(NSString *gesPsd);

@interface GLLockView : UIView

typedef NS_ENUM(NSInteger, GLLockViewState) {
    
    GLLockViewStateAdd,//设置密码
    
    GLLockViewStateAuthen //验证密码
    /*
     *可以继续增添新的模式，根据需求
     */
};

typedef NS_ENUM(NSInteger, GLLockLoginState) {
    GLLockLoginStateSuccess,
    
    GLLockLoginStateFailure
};


-(instancetype)initWithFrame:(CGRect)frame config:(GLLockConfig *)config;

@property (nonatomic, copy) addGestureCallBack addGestureCallBackBlock;
@property (nonatomic, copy) athenGestureCallBack athenGestureCallBackBlock;

@end

