//
//  GLLockView.m
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import "GLLockView.h"
#import "GLLockButton.h"

#define padding 20
@interface GLLockView()
/*
 *按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/*
 *选中按钮的数组
 */
@property (nonatomic, strong) NSMutableArray *btnselectedArray;
/*
 *最后滑动的位置
 */
@property (nonatomic, assign) CGPoint currentpoint;

@property (nonatomic ,assign) GLLockViewState state;

@property (nonatomic ,assign) GLLockLoginState loginstate;
/*
 *用于验证拼接
 */
@property (nonatomic, copy) NSMutableString *setPasswordTemp;
/*
 *提醒框
 */
@property (nonatomic, weak) UILabel *alertLabel;

@end


@implementation GLLockView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame PasswordSata:GLLockViewStateAdd];
}


- (id)initWithFrame:(CGRect)frame PasswordSata:(GLLockViewState)state
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = state;
        self.loginstate = GLLockLoginStateSuccess;
        self.btnArray = [NSMutableArray array];
        self.btnselectedArray = [NSMutableArray array];
        self.currentpoint = CGPointZero;
        self.setPasswordTemp = [NSMutableString string];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        //提醒框
        UILabel *alertlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        alertlabel.text = @"请再次输入密码";
        alertlabel.textColor = [UIColor yellowColor];
        alertlabel.alpha = 0;
        alertlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:alertlabel];
        self.alertLabel = alertlabel;
        
        //添加按钮
        for (int index = 0; index < 9; index++) {
            int row = index/3;
            int col = index%3;
            float btnrad = (frame.size.width-120)/3;
            float btnX = padding +(btnrad+2*padding)*col;
            float btnY = padding +(btnrad+2*padding)*row+(frame.size.height-frame.size.width)/2;
            float btnW = btnrad;
            float btnH = btnrad;
            GLLockButton *passwordBtn = [[GLLockButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
            passwordBtn.tag = index;
            [self addSubview:passwordBtn];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(passwordGesture:)];
            [self addGestureRecognizer:pan];
            [self.btnArray addObject:passwordBtn];
            
        }
    }
    return self;
}

-(void)passwordGesture:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.loginstate = GLLockLoginStateSuccess;
            [self.btnselectedArray removeAllObjects];
            CGPoint location;
            location = [pan locationInView:self];
            
            for (int index = 0; index < self.btnArray.count; index++) {
                GLLockButton *btn = (GLLockButton *)[self.btnArray objectAtIndex:index];
                /*
                 *可以调整frame的大小调整手感
                 */
                if (CGRectContainsPoint(btn.frame, location)) {
                    btn.selected = YES;
                    [self.btnselectedArray addObject:btn];
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location;
            location = [pan locationInView:self];
            if (self.btnselectedArray.count > 0) {
                for (int index = 0; index < self.btnArray.count; index++) {
                    GLLockButton *btn = (GLLockButton *)[self.btnArray objectAtIndex:index];
                    if (CGRectContainsPoint(btn.frame, location)) {
                        if (![self.btnselectedArray containsObject:btn]) {
                            [self.btnselectedArray addObject:btn];
                            for (GLLockButton *btn in self.btnArray) {
                                btn.selected = NO;
                            }
                            for (GLLockButton *btn in self.btnselectedArray) {
                                btn.selected = YES;
                            }
                        }
                    }else{
                        self.currentpoint = location;
                    }
                }
                [self setNeedsDisplay];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.btnselectedArray.count > 0) {
                NSMutableString * resultString=[NSMutableString string];
                for ( GLLockButton *btn  in self.btnselectedArray){
                    [resultString appendString:[NSString stringWithFormat:@"%i",btn.tag]];
                }
                
                if (self.state == GLLockViewStateAuthen) {
                    [self authen:resultString];
                }else if(self.state == GLLockViewStateAdd)
                {
                    [self addPassword:resultString];
                }
                if (self.loginstate == GLLockLoginStateSuccess) {
                    self.currentpoint = CGPointZero;
                    [self.btnselectedArray removeAllObjects];
                    for (GLLockButton *btn in self.btnArray) {
                        btn.selected = NO;
                    }
                    [self setNeedsDisplay];
                } else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.currentpoint = CGPointZero;
                        [self.btnselectedArray removeAllObjects];
                        for (GLLockButton *btn in self.btnArray) {
                            btn.selected = NO;
                        }
                        [self setNeedsDisplay];
                    });
                }
                
            }
        }
            break;
            
        default:
            break;
    }
}

/*
 *验证密码，未加密，有需要可以增加md5
 */
-(void)authen:(NSMutableString *)passWord
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *passwordstored = [defaults objectForKey:@"password"];
    if ([passWord isEqualToString: passwordstored]) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        self.loginstate = GLLockLoginStateFailure;
        [self setNeedsDisplay];
    }
}

/*
 *设置密码
 */
-(void)addPassword:(NSMutableString *)passWord
{
    if ([self.setPasswordTemp isEqualToString:@""]) {
        self.setPasswordTemp = passWord;
        [UIView animateWithDuration:0.5 animations:^{
            self.alertLabel.text = @"请再次输入密码";
            self.alertLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
                self.alertLabel.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
        }];
        return;
    }
    if ([self.setPasswordTemp isEqualToString:passWord]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:passWord forKey:@"password"];
        [defaults synchronize];
        
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else{
        [UIView animateWithDuration:0.5 animations:^{
            self.alertLabel.text = @"两次密码不一致，请重新输出";
            self.alertLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
                self.alertLabel.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
        }];
        self.setPasswordTemp = (NSMutableString *)@"";
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,4);
    if (self.loginstate == GLLockLoginStateSuccess) {
        CGContextSetRGBStrokeColor(ctx, 102/255.f, 145/255.f, 254/255.f, 1);
    } else{
        CGContextSetRGBStrokeColor(ctx, 255/255.f, 0/255.f, 0/255.f, 1);
    }
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    for (int index = 0; index < self.btnselectedArray.count; index++) {
        if (index == 0) {
            GLLockButton *btn = (GLLockButton *)[self.btnselectedArray objectAtIndex:index];
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
        } else
        {
            
            GLLockButton *btn = (GLLockButton *)[self.btnselectedArray objectAtIndex:index];
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
    }
    if (self.currentpoint.x > 0 && self.currentpoint.y > 0) {
        
        CGContextAddLineToPoint(ctx, self.currentpoint.x,self.currentpoint.y);
    }
    CGContextStrokePath(ctx);
    
}

@end
