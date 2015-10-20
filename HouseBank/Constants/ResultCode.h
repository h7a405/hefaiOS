//
//  ResultCode.h
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

/**
 该头文件用于记录服务器结果参数。
 */

#ifndef HouseBank_ResultCode_h
#define HouseBank_ResultCode_h

#define SUCCESS    0
#define ERROR    1

#define HadRegister 0 //注册返回码，已经注册
#define Register(x) x > HadRegister //注册返回码，是否注册成功

/**
 * 用户不存在
 */
#define USER_NOT_EXISTS    101

/**
 * 用户已存在
 */
#define USER_EXISTS    102


/**
 * 合作信息已经存在
 */
#define COOP_NOTNULL  1

/**
 * 是自己的房源
 */
#define HOUSE_IS_ME  2

//////     统一返回码
#define ResultOk 200 //返回OK
#define HouseNotExists 511//:房源不存在
#define CommunityNotExists 521//:小区不存在
#define BrokerNotExists 531//:经纪人不存在
#define BrokerAlreadyExists 532//：经纪人已存在
#define UserOrPasswordError 533//：用户名或密码错误
#define AccountDisable 534//：账号已禁用
#define IsFriendAndNotInviteAgain 541//：已是您的人脉，无需再邀请
#define PageNotExists 591//：页面不存在
#define IllegalOperation 592//：非法操作

/**
 * 经纪人信息是空
 */
#define BROKER_INFO_NULL  3

/**
 *房源id为空
 */
#define HOUSE_ID_NULL  2

/**
 * 没有 同意 合作协议
 */
#define COOP_AGREE_NULL  7

#endif
