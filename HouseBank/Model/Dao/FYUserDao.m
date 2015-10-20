//
//  CSUserDao.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYUserDao.h"

#define LoginStatus @"LoginS"

/**
 用户数据库类
 */
@implementation FYUserDao

// 是否登陆
-(BOOL) isLogin{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults boolForKey : LoginStatus];
};

//保存登陆状态
-(void) setLogin: (BOOL) isLogin{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:isLogin forKey:LoginStatus];
    [accountDefaults synchronize];
};

-(BOOL) isLaunch{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults boolForKey : @"launch"];
};

-(void) setIsLaunch : (BOOL) isLaunch{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:isLaunch forKey:@"launch"];
    [accountDefaults synchronize];
};

//用户类
-(UserBean *) user{
    return (UserBean *)[NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];;
};

//清除用户
-(void) removeUser {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:kFilePath]) {
        [defaultManager removeItemAtPath:kFilePath error:nil];
    }
}

//保存用户
-(void) saveUser : (UserBean *) user{
    [NSKeyedArchiver archiveRootObject:user toFile:kFilePath];
};

@end
