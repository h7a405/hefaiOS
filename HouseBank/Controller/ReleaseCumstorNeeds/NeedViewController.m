//
//  NeedViewController.m
//  HouseBank
//
//  Created by JunJun on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#import "CustomerView.h"
#import "NeedViewController.h"

#import "CRMBasicFactory.h"
#import "UIViewExt.h"
#import "SuiDataService.h"
@interface NeedViewController ()

@end

@implementation  NeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.model = [[CustomerModel alloc] init];
    self.title = @"发布客需";
    self.Cview = [[CustomerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.Cview.vc = self;
    [self.view addSubview:_Cview];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
