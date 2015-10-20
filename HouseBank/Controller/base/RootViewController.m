//
//  RootViewController.m
//  Left
//
//  Created by 植梧培 on 14-8-16.
//  Copyright (c) 2014年 ®大白菜逗逼研究所. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark 首页在sb加载，所以重写此方法
- (void)awakeFromNib{
    self.topViewControllerStoryboardId=@"HomeViewController";
    self.underRightViewControllerStoryboardId=nil;
    self.underLeftViewControllerStoryboardId=@"MenuViewController";
    
    //如果用SB就用上面的属性。用纯代码或者XIB就用下面的这几个属性
//    self.topViewController=nil;
//    self.underLeftViewController=nil;
//    self.underRightViewController=nil;
    [super awakeFromNib];
}

@end
