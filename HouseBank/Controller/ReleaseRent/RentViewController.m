//
//  RentViewController.m
//  housebank.1
//
//  Created by JunJun on 14/12/26.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import "RentViewController.h"
#import "RoomView.h"
#import "MySegment.h"
#import "UIViewExt.h"
#import "WriteView.h"
#import "ShopView.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define is_ios7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7

@interface RentViewController ()

@end

@implementation RentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发布出租";
    
    MySegment *segment = [[MySegment alloc] initWithItems:@[@"住宅",@"写字楼",@"商铺"] frame:CGRectMake(0, 64, kScreenWidth, 40)];
    //添加点击事件
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    self.roomView = [[RoomView alloc] initWithFrame:CGRectMake(0, segment.bottom, kScreenWidth, kScreenHeight )];
    self.roomView.rentVC = self;
    [self.view addSubview:_roomView];
    _roomView.hidden = NO;
    
    self.writeView = [[WriteView alloc] initWithFrame:CGRectMake(0, segment.bottom, kScreenWidth, kScreenHeight)];
    self.writeView.rentVC = self;
    [self.view addSubview:_writeView];
    _writeView.hidden = YES;
    
    self.shopView = [[ShopView alloc] initWithFrame:CGRectMake(0, segment.bottom, kScreenWidth, kScreenHeight)];
    self.shopView.rentVC = self;
    [self.view addSubview:_shopView];
    _shopView.hidden = YES;
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    self.shopView.label2.hidden = YES;
    //    self.shopView.shangpuView.hidden = YES;
}
- (void)segmentAction:(MySegment *)segment
{
    NSLog(@"segment index = %d",segment.lastSelectIndex);
    if (segment.lastSelectIndex == 0) {
        _writeView.hidden = YES;
        _roomView.hidden = NO;
        _shopView.hidden = YES;
        //        self.shopView.label2.hidden = YES;
        //        self.shopView.shangpuView.hidden = YES;
        
    }else if (segment.lastSelectIndex == 1){
        _roomView.hidden = YES;
        _writeView.hidden = NO;
        _shopView.hidden = YES;
        //        self.shopView.label2.hidden = YES;
        //        self.shopView.shangpuView.hidden = YES;
        
    }else if(segment.lastSelectIndex == 2){
        _shopView.hidden = NO;
        _writeView.hidden = YES;
        _roomView.hidden = YES;
        //        self.shopView.label2.hidden = NO;
        //        self.shopView.shangpuView.hidden = NO;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
