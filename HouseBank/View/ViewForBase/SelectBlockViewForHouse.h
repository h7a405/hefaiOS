//
//  AddressSelectView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  地址选择器

#import <UIKit/UIKit.h>
@class SelectBlockViewForHouse;
@protocol SelectBlockViewForHouseDelegate <NSObject>

-(void)blockSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId;
-(void)blockAll;
-(void)streetAll : (NSString *) areaId;
@end

@interface SelectBlockViewForHouse : UIView
@property(nonatomic,weak)id<SelectBlockViewForHouseDelegate>delegate;
@property(nonatomic,copy)NSString * cityId;

-(void)show;
@end
