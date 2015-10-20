//
//  CallRecords.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-18.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CallRecords : NSManagedObject

@property (nonatomic, retain) NSString * tid;
@property (nonatomic, retain) NSString * brokerId;
@property (nonatomic, retain) NSString * relationType;
@property (nonatomic, retain) NSString * relationId;
@property (nonatomic, retain) NSString * createTime;
/**
 *  1：二手房 2：租房 3：新房
 */
@property (nonatomic, retain) NSString * houseType;
/**
 *  返回通话记录
 *
 *  @param brokerId
 *  @param houseType
 *
 *  @return
 */
+(NSArray *)allCallRectrdsWithBrokerId:(NSString *)brokerId andHouseType:(NSString *)houseType;
/**
 *  删除通话记录
 *
 *  @param brokerId
 *  @param houseType
 *
 *  @return
 */
+(BOOL)removeAllCallRecordsWithBrokerId:(NSString *)brokerId andHouseType:(NSString *)houseType;
/**
 *  保存通话记录
 *
 *  @param dict
 *
 *  @return 
 */
+(BOOL)callRecordsWithDict:(NSDictionary *)dict;
@end
