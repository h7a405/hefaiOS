//
//  XSNewHouseInfoViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNewHouseInfoViewController.h"
#import "XSNewHouseInfoView.h"
#import "NewHouseInfoBean.h"
#import "CommunityBean.h"
#import "NewHouseTypeBean.h"
#import "HouseMapViewController.h"
#import "XSHouseTypeViewController.h"
#import "XSAwardViewController.h"
#import "XSCommissionViewController.h"
#import "XSOrderApplyViewController.h"
#import "AFNetworking.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "NewHouseWsImpl.h"
#import "HouseWsImpl.h"
#import "FYUserDao.h"
#import "Share.h"

@interface XSNewHouseInfoViewController ()<XSNewHouseInfoViewDelegate>{
    XSNewHouseInfoView *_infoView;
    
    NewHouseInfoBean *_houseInfo;
    NSMutableArray *_houseTypes;
    CommunityBean *_houseComnunity;
}
@end

@implementation XSNewHouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _houseTypes=[NSMutableArray array];
    _infoView=[[XSNewHouseInfoView alloc]init];
    self.view=_infoView;
    [self getProjectDataFormServer];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [_infoView showMap];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_infoView hideMap];
    
    [super viewWillDisappear:animated];
}

#pragma mark - 获取楼盘信息
-(void)getProjectDataFormServer{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NewHouseWsImpl *ws = [NewHouseWsImpl new];
    [ws requestHouseInfo:_projectId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            _houseInfo= [NewHouseInfoBean modelObjectWithDictionary:[result allStringObjDict]];
            [self getAllHouseType:_houseInfo.communityId];
            self.navigationItem.title = _houseInfo.projectName;
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark - 获取房型
-(void)getAllHouseType:(NSString *)communityId{
    NewHouseWsImpl *ws = [NewHouseWsImpl new];
    [ws requestHouseModel:communityId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            NSArray *data=[result objectForKey:@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_houseTypes addObject:[NewHouseTypeBean modelObjectWithDictionary:[obj allStringObjDict]]];
            }];
            
            [self getCommunityFormServer:communityId];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark - 小区信息
-(void)getCommunityFormServer:(NSString *)communityId{
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws loadCommunityInfoByCommunityId:communityId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            _houseComnunity=[CommunityBean communityBeanWithDictionary:[result allStringObjDict]];
            [self refreshInfoView];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 刷新界面
-(void)refreshInfoView
{
    _infoView.community=_houseComnunity;
    _infoView.houseTypes=_houseTypes;
    _infoView.info=_houseInfo;
    _infoView.delegate=self;
    [_infoView refreshView];
    
}

-(void)xsNewHouseInfoViewDidClickApplyFor:(XSNewHouseInfoView *)view{
    if([_handler handleUserPermission:self])
        [self performSegueWithIdentifier:@"appleFor" sender:nil];
}
/**
 *  佣金
 *
 *  @param view
 */
-(void)xsNewHouseInfoViewdidClickCommission:(XSNewHouseInfoView *)view
{
    [self performSegueWithIdentifier:@"Commission" sender:nil];
}
/**
 *  奖励
 *
 *  @param view
 */
-(void)xsNewHouseInfoViewdidClickaAward:(XSNewHouseInfoView *)view
{
    [self performSegueWithIdentifier:@"Award" sender:nil];
}
#pragma mark - 查看地图
-(void)xsNewHouseInfoView:(XSNewHouseInfoView *)info didClickMapView:(CLLocationCoordinate2D)location
{
    HouseMapViewController *map=[[HouseMapViewController alloc]init];
    map.location=location;
    [self.navigationController pushViewController:map animated:YES];
}
#pragma mark - 查看房型
-(void)xsNewHouseInfoView:(XSNewHouseInfoView *)info didClickHouseTypeAtIndex:(NSInteger)index
{
    [self performSegueWithIdentifier:@"houseTypeController" sender:_houseTypes[index]];
}
#pragma mark - 跳转页面设置
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"houseTypeController"]) {
        XSHouseTypeViewController *type=segue.destinationViewController;
        type.title=_houseInfo.projectName;
        type.propertyTypeString=_houseInfo.propertyType;
        type.type=sender;
    }else if([segue.identifier isEqualToString:@"Award"]){
        /// －－－－
        XSAwardViewController *award=segue.destinationViewController;
        award.projectNameString=_houseInfo.projectName;
        award.projectId=_projectId;
    }else if([segue.identifier isEqualToString:@"Commission"]){
        /// ----
        XSCommissionViewController *commission=segue.destinationViewController;
        commission.projectNameString=_houseInfo.projectName;
        commission.projectId=_projectId;
    }else if ([segue.identifier isEqualToString:@"appleFor"]) {
        /// =====
        XSOrderApplyViewController *order=segue.destinationViewController;
        order.projectId=_projectId;
    }
    
}

- (IBAction)share:(id)sender{
    NSString *url=[NSString stringWithFormat:@"http://m.fybanks.cn/newhouse/detail.do?u=&id=%@",_houseInfo.projectId];;
    
    NSString * content=nil;
    
    content=[NSString stringWithFormat:@"新楼盘【%@】，【%@】【http://m.fybanks.cn/newhouse/detail.do?u=&id=%@】",_houseInfo.projectName,_houseInfo.customerDiscount,_houseInfo.projectId];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"合发房银"
                                                image:[ShareSDK imageWithUrl:[NSString stringWithFormat:@"%@",[[NSBundle mainBundle]URLForResource:@"noimgBig" withExtension:@"png"]]]
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

@end
