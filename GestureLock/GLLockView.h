//
//  GLLockView.h
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import <UIKit/UIKit.h>

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

/*
 *通过不同的模式初始化
 */
- (id)initWithFrame:(CGRect)frame PasswordSata:(GLLockViewState)state;

@property (nonatomic, copy) addGestureCallBack addGestureCallBackBlock;
@property (nonatomic, copy) athenGestureCallBack athenGestureCallBackBlock;

@end

/**
 *  解锁界面的按钮
 */
@interface GLLockButton : UIButton

@end
