//
//  CommunityInfoViewController.m
//  HouseBank
//
//  Created by 植梧培 on 14-9-21.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CommunityInfomationViewController.h"
#import "CommunityInfoView.h"
#import "HouseMapViewController.h"

@interface CommunityInfomationViewController ()<CommunityInfoViewDelegate>{
    CommunityInfoView *_communityView;
}
@end

@implementation CommunityInfomationViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"小区详情";
    self.automaticallyAdjustsScrollViewInsets=YES;
    _communityView = [[CommunityInfoView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_communityView];
    
    _communityView.delegate=self;
    _communityView.community=_community;
}

#pragma mark - 初始化地图
-(void)viewWillAppear:(BOOL)animated{
    [_communityView showMap];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [_communityView hideMap];
    [super viewDidAppear:animated];
}

#pragma mark - 点击 地图
-(void)communityInfo:(CommunityInfoView *)info didClickMapView:(CLLocationCoordinate2D)location{
    HouseMapViewController *map=[[HouseMapViewController alloc]init];
    map.location=location;
    [self.navigationController pushViewController:map animated:YES];
}

-(void)dealloc{
    _communityView.delegate=nil;
}
@end
