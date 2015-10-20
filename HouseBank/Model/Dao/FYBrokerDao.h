//
//  BrokerDao.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrokerInfoBean.h"
#import "FYBaseDao.h"

@interface FYBrokerDao : FYBaseDao

// 保存broker对象
-(void) saveBroker : (BrokerInfoBean *) broker;
//获取broker对象
-(BrokerInfoBean *) brokerInfo;

@end
