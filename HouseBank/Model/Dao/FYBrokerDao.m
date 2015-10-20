//
//  BrokerDao.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBrokerDao.h"
#import "UserBean.h"

@implementation FYBrokerDao

-(void) saveBroker : (BrokerInfoBean *) broker{
    [NSKeyedArchiver archiveRootObject:broker toFile:BrokerFilePath];
};

-(BrokerInfoBean *) brokerInfo{
    return (BrokerInfoBean *) [NSKeyedUnarchiver unarchiveObjectWithFile:BrokerFilePath];
};

@end
