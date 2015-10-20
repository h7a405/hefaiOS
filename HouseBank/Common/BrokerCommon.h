//
//  BrokerCommon.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//
//个人中心公共类

/**
 个人信息验证码
 */
typedef  enum {
    NOPASSED = 1,
    AUTHSTR = 2,
    ISPASSED = 3,
    UNPASSED = 4
}AuthStatus ;

#ifndef HouseBank_BrokerCommon_h
#define HouseBank_BrokerCommon_h

#define NoPassStr @"未认证"
#define AuthStr @"待认证"
#define IsPassStr @"已认证"
#define UnPassStr @"认证未通过"
#define OtherStr @"其他"

#endif
