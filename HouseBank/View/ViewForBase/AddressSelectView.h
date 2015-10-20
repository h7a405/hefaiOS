//
//  AddressSelectView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  地址选择器

#import <UIKit/UIKit.h>
@class AddressSelectView;
@protocol AddressSelectViewDelegate <NSObject>

-(void)addressSelectView:(AddressSelectView *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId;
-(void)addressAll;
-(void)cityAll : (NSString *) cityId;
-(void)areaAll : (NSString *) areaId;

@end

@interface AddressSelectView : UIView
@property(nonatomic,weak)id<AddressSelectViewDelegate>delegate;
-(void)show;
@end
