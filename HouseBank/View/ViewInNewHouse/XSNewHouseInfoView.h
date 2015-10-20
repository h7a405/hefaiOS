//
//  XSNewHouseInfoView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@class NewHouseInfoBean,CommunityBean,XSNewHouseInfoView;
@protocol XSNewHouseInfoViewDelegate <NSObject>

-(void)xsNewHouseInfoViewDidClickApplyFor:(XSNewHouseInfoView *)view;
-(void)xsNewHouseInfoViewdidClickCommission:(XSNewHouseInfoView *)view;
-(void)xsNewHouseInfoViewdidClickaAward:(XSNewHouseInfoView *)view;

-(void)xsNewHouseInfoView:(XSNewHouseInfoView *)info didClickMapView:(CLLocationCoordinate2D)location;
-(void)xsNewHouseInfoView:(XSNewHouseInfoView *)info didClickHouseTypeAtIndex:(NSInteger)index;

@end
@interface XSNewHouseInfoView : UIView
@property(nonatomic,strong)NewHouseInfoBean *info;
@property(nonatomic,strong)CommunityBean *community;
@property(nonatomic,strong)NSArray *houseTypes;
@property(nonatomic,weak)id<XSNewHouseInfoViewDelegate>delegate;
/**
 *  刷新UI
 */
-(void)refreshView;
-(void)showMap;
-(void)hideMap;
@end
