//
//  BaseViewController.m
//  GongChuang
//
//  Created by 鹰眼 on 14-8-21.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _handler = [UserPermissionHandler new];
}

- (void)dealloc{
    _handler = nil;
}

@end
