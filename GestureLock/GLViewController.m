//
//  GLViewController.m
//  GestureLock
//
//  Created by qianhongqiang on 14-10-6.
//  Copyright (c) 2014年 最美应用. All rights reserved.
//

#import "GLViewController.h"
#import "GLLockView.h"
#import "GLLockConfig.h"

@interface GLViewController ()

@end

@implementation GLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GLLockView *lockView = [[GLLockView alloc] initWithFrame:self.view.bounds config:[GLLockConfig new]];
    [self.view addSubview:lockView];
    
}

@end
