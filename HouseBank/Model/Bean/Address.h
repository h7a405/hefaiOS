//
//  Address.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-12.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, AddressLevel){
    AddressLevelProvince,
    AddressLevelCity,
    AddressLevelArea,
    AddressLevelStreet,
    
};
@interface Address : NSManagedObject

@property (nonatomic, retain) NSNumber * tid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pinyin;
@property (nonatomic, retain) NSString * py;
@property (nonatomic, retain) NSString * sort;

/**
 *  获取全部省份
 *
 *  @return
 */
+(NSArray *)getAllProvience;
/**
 *  根据省id返回所有城市
 *
 *  @param provience
 *
 *  @return
 */
+(NSArray *)citysWithProvience:(Address *)provience;
/**
 *  根据城市id返回所有区域
 *
 *  @param city
 *
 *  @return
 */
+(NSArray *)areasWithCity:(Address *)city;
/**
 *  根据区域id返回所有板块
 *
 *  @param area
 *
 *  @return
 */
+(NSArray *)streesWithArea:(Address *)area;
/**
 *  根据父级id返回地址
 *
 *  @param pid
 *
 *  @return 
 */
+(NSArray *)addressDataWithPid:(NSString *)pid;
/**
 *  根据id返回地址
 *
 *  @param aid
 *
 *  @return
 */
+(NSArray *)addressByAId : (id) aid;
/**
 *  所有城市
 *
 *  @return
 */
+(NSArray *)allCity;
/**
 *  根据板块id返回地址
 *
 *  @param regionId
 *
 *  @return
 */
+(NSString *)addressWithRegionId:(NSString *)regionId;
+(NSString *)addressIdWithCityName:(NSString *)name;
@end
