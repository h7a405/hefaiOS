//
//  UserModel.h
//  GongChuang
//
//  Created by 鹰眼 on 14-8-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kFileName @"user.data"
#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kFileName]
#define BrokerInfoFileName @"Broker.data"
#define BrokerFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:BrokerInfoFileName]

@interface UserBean : NSObject

@property(nonatomic,copy)NSString *sid;
@property(nonatomic,copy)NSString *brokerId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *mobilephone;
@property(nonatomic,copy)NSString *storeName;
@property(nonatomic,copy)NSString *headImageUrl;
@property(nonatomic,copy)NSString *cityId;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *username;

/**
 *  返回用户模型
 *
 *  @param dict
 *
 *  @return
 */
+(id)userWithDict:(NSDictionary *)dict;

@end
