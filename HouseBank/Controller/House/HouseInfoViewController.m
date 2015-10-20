//
//  HouseInfoViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseInfoViewController.h"
#import "HouseInfoBean.h"
#import "HouseInfoView.h"
#import "CommunityBean.h"
#import "HouseMapViewController.h"
#import "MyCenterWsImpl.h"
#import "BrokerInfoBean.h"
#import "CommunityInfomationViewController.h"
#import "XSHouseBrokerInfoViewController.h"
#import "XSApplyLookHouseViewController.h"
#import "Share.h"
#import "HouseInfoImageBean.h"
#import "UIImage+MultiFormat.h"
#import "FYUserDao.h"
#import "MBProgressHUD+Add.h"
#import "HouseWsImpl.h"

@interface HouseInfoViewController ()<HouseInfoDelegate>{
    HouseInfoView *_infoView;
    CommunityBean *_community;
    HouseInfoBean *_houseInfo;
    BrokerInfoBean *_broker;
    NSString * _count;
    NSString *_shareImageUrl;
}
@end

@implementation HouseInfoViewController

@synthesize isBusiness;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _infoView= [[HouseInfoView alloc]init];
    _infoView.isBusiness = isBusiness;
    
    self.view=_infoView;
    [self getDataFormServer];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha=1.0;
    
    [_infoView showMap];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_infoView hideMap];
    
    [super viewWillDisappear:animated];
}

#pragma mark - 获取数据
-(void)getDataFormServer{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws loadHouseInfoByHouseId:_houseId sid:user.sid result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            _houseInfo = [HouseInfoBean houseInfoBeanWithDictionary:result];
            HouseInfoImageBean *infoImage=[_houseInfo.images firstObject];
            if (infoImage) {
                _shareImageUrl=infoImage.imagePath;
            }
            
            //房子详细信息请求完毕请求小区信息
            [self getCommunityFormServer:_houseInfo.communityId];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 小区信息
-(void)getCommunityFormServer:(NSString *)communityId{
    if([communityId integerValue]==0){
        [self getUserInfo];
    }else{
        HouseWsImpl *ws = [HouseWsImpl new];
        [ws loadCommunityInfoByCommunityId:communityId result:^(BOOL isSuccess, id result, NSString *data) {
            if (isSuccess) {
                _community = [CommunityBean communityBeanWithDictionary:result];
                self.navigationItem.title = _community.community;
                [self getUserInfo];
            }else{
                [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            }
        }];
    }
}

#pragma mark - 经纪人信息
-(void)getUserInfo{
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestBrokerInfo:KUrlConfig brokerId:_houseInfo.brokerId result:^(BOOL isSeccess,id result,NSString *data){
        if (isSeccess) {
            _broker= [BrokerInfoBean brokerFromDic:result];
            [self getPageNumber];
        }
    }];
}

#pragma mark - 浏览次数
-(void)getPageNumber{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws loadHouseCheckCount:_houseId brokerId:user.brokerId result:^(BOOL isSuccess, id result, NSString *data) {
        if (!isSuccess) {
            _count = ((data == nil || [[data class] isSubclassOfClass: [[NSNull null] class]])? @"0":data);
        }else{
            _count = @"0";
        }
        [self setupInfoView];
    }];
}

#pragma mark -  初始化view
-(void)setupInfoView{
    _infoView.houseInfo=_houseInfo;
    _infoView.community=_community;
    _infoView.broker=_broker;
    _infoView.count=_count;
    _infoView.type=_type;
    _infoView.delegate=self;
    [_infoView refreshData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 点击 地图
-(void)houseInfo:(HouseInfoView *)info didClickMapView:(CLLocationCoordinate2D)location{
    HouseMapViewController *map=[[HouseMapViewController alloc]init];
    map.location=location;
    [self.navigationController pushViewController:map animated:YES];
}

#pragma mark - 点击小区
-(void)houseInfo:(HouseInfoView *)info didClickCommunityView:(CommunityBean *)commonity{
    if (commonity ) {
        CommunityInfomationViewController *vc=[[CommunityInfomationViewController alloc]init];
        vc.community=commonity;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 查看用户信息
-(void)houseInfo:(HouseInfoView *)info didClickBrokerInfo:(NSString *)brokerId{
    [self performSegueWithIdentifier:@"brokerInfo" sender:brokerId];
}

#pragma  mark - 申请看房
-(void)houseInfo:(HouseInfoView *)info didClickApplyLookHouse:(HouseInfoBean *)houseInfo{
    if([_handler handleUserPermission:self])
        [self performSegueWithIdentifier:@"applyLookHouse" sender:houseInfo];
}

#pragma mark - 页面跳转前处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"brokerInfo"]) {
        XSHouseBrokerInfoViewController *info=segue.destinationViewController;
        info.brokerId=sender;
    }else{
        XSApplyLookHouseViewController *apply=segue.destinationViewController;
        apply.houseInfo=sender;
        apply.broker=_broker;
        apply.communtitys=_community;
        apply.communityString=_communityString;
        apply.type=_type;
    }
}

#pragma mark - 分享
- (IBAction)share:(id)sender{
    if (_shareImageUrl==nil) {
        _shareImageUrl=[NSString stringWithFormat:@"%@",[[NSBundle mainBundle]URLForResource:@"noimgBig" withExtension:@"png"]];
    }
    NSString *type=nil;
    if (_type==HouseTypeRent) {
        type=@"出租";
    }else if (_type==HouseTypeSell){
        type=@"出售";
    }
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    NSString *url=[NSString stringWithFormat:@"http://m.fybanks.cn/house/detail.do?u=%@&houseId=%@",user.mobilephone,_houseId];
    //NSString *content=[NSString stringWithFormat:@"我在合发房银发现了一套精品房源[%@],[%@],感觉还不错。点击查看:%@",type,_houseInfo.advTitle,url];
    NSString * content=nil;
    int a=arc4random_uniform(10);
    
    if (a%2==0) {
        content=[NSString stringWithFormat:@"在找房子吗，朋友出国，急着出手，全网性价比最高【%@】【%@】更多拍卖房、学区房、紧俏房源，点击%@",type,_houseInfo.advTitle,url];
    }else{
        content=[NSString stringWithFormat:@"【%@】【%@】更多拍卖房、学区房、紧俏房源，点击%@",type,_houseInfo.advTitle,url];
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"合发房银"
                                                image:[ShareSDK imageWithUrl:_shareImageUrl]
                                                title:@"合发房银"
                                                  url:url
                                          description:@"合发房银房源分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [MBProgressHUD showSuccess:@"分享成功!" toView:self.view];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"###%d,%@", [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:@"分享失败!" toView:self.view];
                                }
                                
                            }];
    
}


-(void)dealloc
{
    _infoView.delegate=nil;
}
@end
