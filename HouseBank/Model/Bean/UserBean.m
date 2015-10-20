//
//  UserModel.m
//  GongChuang
//
//  Created by 鹰眼 on 14-8-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "UserBean.h"

@implementation UserBean
/**
 *  对象归档
 *
 *  @param decoder
 *
 *  @return
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.sid =[decoder decodeObjectForKey:@"sid"];
        self.brokerId =[decoder decodeObjectForKey:@"brokerId"];
        self.name =[decoder decodeObjectForKey:@"name"];
        self.storeName=[decoder decodeObjectForKey:@"storeName"];
        self.mobilephone=[decoder decodeObjectForKey:@"mobilephone"];
        self.headImageUrl=[decoder decodeObjectForKey:@"headImageUrl"];
        self.username=[decoder decodeObjectForKey:@"username"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.sid forKey:@"sid"];
    [encoder encodeObject:self.brokerId forKey:@"brokerId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.mobilephone forKey:@"mobilephone"];
    [encoder encodeObject:self.storeName forKey:@"storeName"];
    [encoder encodeObject:self.headImageUrl forKey:@"headImageUrl"];
    [encoder encodeObject:self.username forKey:@"username"];
}

/**
 *  保存用户信息
 *
 *  @param user 传入登录用户信息
 */
+(void)save:(UserBean *)user{
    [NSKeyedArchiver archiveRootObject:user toFile:kFilePath];
}

/**
 *  获取当前登录用户
 *
 *  @return 返回当前登录用户信息
 */
+(UserBean *)getUser{
    return (UserBean *)[NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
}

+(id)userWithDict:(NSDictionary *)dict{
    UserBean *usermodel=[[UserBean alloc]init];
    usermodel.sid=dict[@"sid"];
    usermodel.brokerId=dict[@"brokerId"];
    usermodel.name=dict[@"name"];
    usermodel.mobilephone=dict[@"mobilephone"];
    usermodel.storeName=dict[@"storeName"];
    usermodel.headImageUrl=dict[@"headImageUrl"];
    usermodel.cityId = dict[@"cityId"];
    usermodel.cityName = dict[@"cityName"];
    usermodel.username = dict[@"username"];
    return usermodel;
}
@end