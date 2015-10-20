//
//  MyCenterBaseViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "MyCenterBaseViewController.h"
#import "ViewUtil.h"

@interface MyCenterBaseViewController ()

@end

@implementation MyCenterBaseViewController

@synthesize broker;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [ViewUtil string2Color:@"F1f1f1"];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
