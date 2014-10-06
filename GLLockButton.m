//
//  GLLockButton.m
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import "GLLockButton.h"

@implementation GLLockButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"passwordbtn_selected"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"passwordbtn_normal"] forState:UIControlStateNormal];
    }
    return self;
}

/*
// 自己绘制按钮
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
