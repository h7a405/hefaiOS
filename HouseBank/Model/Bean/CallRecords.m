//
//  CallRecords.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-18.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CallRecords.h"


@implementation CallRecords

@dynamic tid;
@dynamic brokerId;
@dynamic relationType;
@dynamic relationId;
@dynamic createTime;
@dynamic houseType;

+(NSArray *)allCallRectrdsWithBrokerId:(NSString *)brokerId andHouseType:(NSString *)houseType
{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"CallRecords"];
    NSManagedObjectContext *context=(NSManagedObjectContext *)[Tool openDB];
    request.predicate=[NSPredicate predicateWithFormat:@"brokerId==%@ and houseType=%@",brokerId,houseType];
    NSArray *data=[context executeFetchRequest:request error:nil];
    return data;
}
+(BOOL)removeAllCallRecordsWithBrokerId:(NSString *)brokerId andHouseType:(NSString *)houseType
{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"CallRecords"];
    NSManagedObjectContext *context=(NSManagedObjectContext *)[Tool openDB];
    request.predicate=[NSPredicate predicateWithFormat:@"brokerId==%@ and houseType=%@",brokerId,houseType];
    NSArray *data=[context executeFetchRequest:request error:nil];
   
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [context deleteObject:obj];
    }];
    return [context save:nil];
}
+(BOOL)callRecordsWithDict:(NSDictionary *)dict
{
    NSManagedObjectContext *context=(NSManagedObjectContext *)[Tool openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"CallRecords"];
    NSArray *data=[context executeFetchRequest:request error:nil];
    NSString *tid=@"0";
    if (data) {
        CallRecords *call=[data lastObject];
        tid=[NSString stringWithFormat:@"%d",[call.tid intValue]+1];
    }
    CallRecords *call=[NSEntityDescription insertNewObjectForEntityForName:@"CallRecords" inManagedObjectContext:context];
    call.tid=tid;
    call.brokerId=dict[@"brokerId"];
   
    call.relationId=dict[@"relationId"];
    call.createTime=dict[@"createTime"];
    call.houseType=dict[@"houseType"];
    return [context save:nil];
}
@end
