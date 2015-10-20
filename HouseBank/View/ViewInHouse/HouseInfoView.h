//
//  HouseInfo.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@class HouseInfoBean,CommunityBean,HouseInfoView,BrokerInfoBean;
@protocol HouseInfoDelegate <NSObject>

/**
 *  点击地图
 *
 *  @param info
 *  @param location
 */
-(void)houseInfo:(HouseInfoView *)info didClickMapView:(CLLocationCoordinate2D)location;
/**
 *  点击小区
 *
 *  @param info
 *  @param commonity
 */
-(void)houseInfo:(HouseInfoView *)info didClickCommunityView:(CommunityBean *)commonity;
/**
 *  点击查看经纪人信息
 *
 *  @param info
 *  @param brokerId
 */
-(void)houseInfo:(HouseInfoView *)info didClickBrokerInfo:(NSString *)brokerId;
/**
 *  点击看房申请
 *
 *  @param info
 *  @param houseInfo
 */
-(void)houseInfo:(HouseInfoView *)info didClickApplyLookHouse:(HouseInfoBean *)houseInfo;

@end
@interface HouseInfoView : UIView<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property(nonatomic,strong)HouseInfoBean *houseInfo;
@property(nonatomic,strong)CommunityBean *community;
@property(nonatomic,strong)BrokerInfoBean *broker;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,assign)HouseType type;
@property(nonatomic,assign)BOOL isBusiness;
@property(nonatomic,weak)id<HouseInfoDelegate>delegate;
/**
 *  刷新数据
 */
-(void)refreshData;
-(void)showMap;
-(void)hideMap;
@end
