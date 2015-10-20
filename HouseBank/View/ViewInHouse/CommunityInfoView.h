//
//  CommunityView.h
//  HouseBank
//
//  Created by 植梧培 on 14-9-21.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@class CommunityBean,CommunityInfoView;
@protocol CommunityInfoViewDelegate <NSObject>

-(void)communityInfo:(CommunityInfoView *)info didClickMapView:(CLLocationCoordinate2D)location;
@end

@interface CommunityInfoView : UIView
@property(nonatomic,strong)CommunityBean *community;
@property(nonatomic,weak)id<CommunityInfoViewDelegate>delegate;
-(void)showMap;
-(void)hideMap;
@end
