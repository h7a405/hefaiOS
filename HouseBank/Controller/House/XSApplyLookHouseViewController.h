//
//  XSApplyLookHouseViewController.h
//  HouseBank
//  看房申请
//  Created by 鹰眼 on 14-9-30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"
@class HouseInfoBean,BrokerInfoBean,CommunityBean;
@interface XSApplyLookHouseViewController : BaseViewController
@property(nonatomic,strong)HouseInfoBean *houseInfo;
@property(nonatomic,strong)BrokerInfoBean *broker;
@property(nonatomic,strong)CommunityBean *communtitys;
@property(nonatomic,copy)NSString *communityString;
@property(nonatomic,assign)HouseType type;
@end
