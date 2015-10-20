//
//  SaleViewController.m
//  HouseBank1
//
//  Created by admin on 14/12/22.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import "SaleViewController.h"
#import "MySegment.h"
#import "HouseView.h"
#import "StoreView.h"
#import "OfficeView.h"
#import "UIViewExt.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define is_ios7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7
//UIColorFromRGB(0xd3d6db)
@interface SaleViewController ()

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布出售";
    MySegment *segment = [[MySegment alloc] initWithItems:@[@"住宅",@"写字楼",@"商铺"] frame:CGRectMake(0, 64, kScreenWidth, 40)];
    //添加点击事件
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    self.houseView = [[HouseView alloc] initWithFrame:CGRectMake(0, segment.bottom, kScreenWidth, kScreenHeight )];
    self.houseView.saleVC = self;
    [self.view addSubview:_houseView];
    _houseView.hidden = NO;
    
    self.storeView = [[StoreView alloc] initWithFrame:CGRectMake(0, segment.bottom, kScreenWidth, kScreenHeight)];
    self.storeView.saleVC = self;
    [self.view addSubview:_storeView];
    _storeView.hidden = YES;
    
    self.officeView = [[OfficeView alloc] initWithFrame:CGRectMake(0,segment.bottom, kScreenWidth, kScreenHeight)];
    self.officeView.saleVC = self;
    [self.view addSubview:_officeView];
    _officeView.hidden = YES;
}

- (void)segmentAction:(MySegment *)segment {
    NSLog(@"segment index = %d",segment.lastSelectIndex);
    if (segment.lastSelectIndex == 0) {
        _officeView.hidden = YES;
        _houseView.hidden = NO;
        _storeView.hidden = YES;
    }else if (segment.lastSelectIndex == 1){
        _houseView.hidden = YES;
        _officeView.hidden = NO;
        _storeView.hidden = YES;
    }else if(segment.lastSelectIndex == 2){
        _storeView.hidden = NO;
        _houseView.hidden = YES;
        _officeView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
