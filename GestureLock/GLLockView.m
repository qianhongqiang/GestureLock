//
//  GLLockView.m
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import "GLLockView.h"
#import "GLLockConfig.h"

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
@property (nonatomic, copy) NSMutableString *resultString;
/*
 *提醒框
 */
@property (nonatomic, weak) UILabel *alertLabel;

@property (nonatomic, strong) GLLockConfig *config;

@end


@implementation GLLockView


-(instancetype)initWithFrame:(CGRect)frame config:(GLLockConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        _config = config;
        _btnArray = [NSMutableArray array];
        _btnselectedArray = [NSMutableArray array];
        _currentpoint = CGPointZero;
        _resultString = [NSMutableString string];
        
        [self setupUI];
        [self setupGesture];
    }
    return self;
}

#pragma mark UI
-(void)setupUI
{
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
        float btnrad = (self.frame.size.width-120)/3;
        float btnX = padding +(btnrad+2*padding)*col;
        float btnY = padding +(btnrad+2*padding)*row+(self.frame.size.height-self.frame.size.width)/2;
        float btnW = btnrad;
        float btnH = btnrad;
        
        UIButton *passwordBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        
        UIImage *selectedImage = [self.config lockView:self selectedImageForSingleItemAtRow:row column:col];
        UIImage *normalImage = [self.config lockView:self normalImageForSingleItemAtRow:row column:col];
        
        [passwordBtn setImage:selectedImage forState:UIControlStateSelected];
        [passwordBtn setImage:normalImage forState:UIControlStateNormal];
        passwordBtn.tag = index;
        [self addSubview:passwordBtn];
        
        [self.btnArray addObject:passwordBtn];
        
    }
}

#pragma mark - UIPanGestureRecognizer
-(void)setupGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(passwordGesture:)];
    [self addGestureRecognizer:pan];
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
                UIButton *btn = (UIButton *)[self.btnArray objectAtIndex:index];
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
                    UIButton *btn = (UIButton *)[self.btnArray objectAtIndex:index];
                    if (CGRectContainsPoint(btn.frame, location)) {
                        if (![self.btnselectedArray containsObject:btn]) {
                            [self.btnselectedArray addObject:btn];
                            for (UIButton *btn in self.btnArray) {
                                btn.selected = NO;
                            }
                            for (UIButton *btn in self.btnselectedArray) {
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
                for ( UIButton *btn  in self.btnselectedArray){
                    [resultString appendString:[NSString stringWithFormat:@"%li",(long)btn.tag]];
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
                    for (UIButton *btn in self.btnArray) {
                        btn.selected = NO;
                    }
                    [self setNeedsDisplay];
                } else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.currentpoint = CGPointZero;
                        [self.btnselectedArray removeAllObjects];
                        for (UIButton *btn in self.btnArray) {
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
        if (self.athenGestureCallBackBlock) {
            self.athenGestureCallBackBlock(passWord);
        }
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
    if ([self.resultString isEqualToString:@""]) {
        self.resultString = passWord;
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
    if ([self.resultString isEqualToString:passWord]) {
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
        self.resultString = (NSMutableString *)@"";
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
            UIButton *btn = (UIButton *)[self.btnselectedArray objectAtIndex:index];
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
        } else
        {
            
            UIButton *btn = (UIButton *)[self.btnselectedArray objectAtIndex:index];
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
    }
    if (self.currentpoint.x > 0 && self.currentpoint.y > 0) {
        
        CGContextAddLineToPoint(ctx, self.currentpoint.x,self.currentpoint.y);
    }
    CGContextStrokePath(ctx);
    
}

@end

