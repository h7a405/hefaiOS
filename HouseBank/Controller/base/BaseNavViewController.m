//
//  BaseNavViewController.m
//  GongChuang
//
//  Created by 鹰眼 on 14-8-12.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseNavViewController.h"
#import "UIImage+Helper.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    static int TAG = 99999;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *imageView = (UIImageView *)[self.navigationBar  viewWithTag:TAG];
    [imageView setBackgroundColor:[UIColor clearColor]];
    if (!imageView){
        imageView = [[UIImageView alloc] initWithFrame:rect(0, -20, self.navigationBar.bounds.size.width, 64)];
        imageView.tag = TAG;
        imageView.image = image(@"bg");
        [self.navigationBar insertSubview:imageView atIndex:0];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //返回按钮颜色
    [navBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barItem =[UIBarButtonItem appearance];
    
    // 设置item的文字属性
    NSDictionary *barItemTextAttr = @{NSForegroundColorAttributeName : [UIColor whiteColor],};
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateNormal];
    NSDictionary *barItemTextAttr1 = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    [barItem setTitleTextAttributes:barItemTextAttr1 forState:UIControlStateDisabled];
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateHighlighted];
}

@end
