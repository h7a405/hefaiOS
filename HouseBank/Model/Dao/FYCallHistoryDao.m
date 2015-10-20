//
//  FYCallHistoryDao.m
//  HouseBank
//
//  Created by CSC on 14/12/4.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYCallHistoryDao.h"
#import "FYUserDao.h"
#import "NSDictionary+String.h"
#import "CallRecords.h"

@implementation FYCallHistoryDao

-(void)saveCallHistoryWithHouseId:(NSString *)houseId andHouseType:(NSString *)houseType{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:houseId forKey:@"relationId"];
    [dict setObject:houseType forKey:@"houseType"];
    [dict setObject:[TimeUtil nowTimeStrByFormat:@"yyyy-MM-dd"] forKey:@"createTime"];
    if ([userDao isLogin]) {
        [dict setObject:user.brokerId forKey:@"brokerId"];
    }
    
    [CallRecords callRecordsWithDict:[dict allStringObjDict]];
}

@end
