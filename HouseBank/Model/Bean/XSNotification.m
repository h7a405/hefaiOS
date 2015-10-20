//
//  XSNotification.m
//  HouseBank
//
//  Created by 鹰眼 on 14/10/21.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNotification.h"
#import "FYUserDao.h"
#import "NSDictionary+String.h"

@implementation XSNotification

@dynamic type;
@dynamic count;
@dynamic title;
@dynamic content;
@dynamic brokerId;
+(BOOL)notificationWithDict:(NSDictionary *)dict
{
    
    NSManagedObjectContext *context=(NSManagedObjectContext *)[Tool openDB];
    XSNotification *notification=[NSEntityDescription insertNewObjectForEntityForName:@"XSNotification" inManagedObjectContext:context];
    NSDictionary *data=[dict allStringObjDict];
    
    if (data[@"title"]) {
        notification.title=[NSString stringWithFormat:@"%@",data[@"title"]];
    }else{
        notification.title=@"";
    }
    if (data[@"content"]) {
        notification.content=[NSString stringWithFormat:@"%@",data[@"content"]];
    }else{
        notification.content=@"";
    }
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    notification.count=[NSString stringWithFormat:@"%@",data[@"count"]];
    notification.type=[NSString stringWithFormat:@"%@",data[@"type"]];
    notification.brokerId=[NSString stringWithFormat:@"%@",user.brokerId];
    return [context save:nil];
}
+(NSArray *)allNotification
{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    NSManagedObjectContext *context=(NSManagedObjectContext *)[Tool openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XSNotification"];
    request.predicate=[NSPredicate predicateWithFormat:@"brokerId==%@",user.brokerId];
    NSArray *data=[context executeFetchRequest:request error:nil];
    return data;
}
+(void)cleanAllNotification
{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    NSManagedObjectContext *context=(NSManagedObjectContext *)[Tool openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XSNotification"];
    request.predicate=[NSPredicate predicateWithFormat:@"brokerId==%@",user.brokerId];
    NSArray *data=[context executeFetchRequest:request error:nil];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [context deleteObject:obj];
    }];
    [context save:nil];
}
@end
