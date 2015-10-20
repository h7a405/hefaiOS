//
//  BasePushViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BasePushViewController.h"

@interface BasePushViewController ()

@end

@implementation BasePushViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
   // self.navigationController.navigationBarHidden=YES;
    [super viewWillDisappear:animated];
}

@end
