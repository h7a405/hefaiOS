//
//  FYAddressDao.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"
#import "Address.h"

@interface FYAddressDao : FYBaseDao

//保存城市
-(void) saveAddress : (NSArray *) datas;

//保存更新时间
-(void) saveUploadCityTime : (long) time;
// 上次更新时间
-(long) uploadCityTime;

-(NSArray *) allProvience;

/**
 *  根据省id返回所有城市
 *
 *  @param provience
 *
 *  @return
 */
-(NSArray *)citysWithProvience:(Address *)provience;
/**
 *  根据城市id返回所有区域
 *
 *  @param city
 *
 *  @return
 */
-(NSArray *)areasWithCity:(Address *)city;
/**
 *  根据区域id返回所有板块
 *
 *  @param area
 *
 *  @return
 */
-(NSArray *)streesWithArea:(Address *)area;
/**
 *  根据父级id返回地址
 *
 *  @param pid
 *
 *  @return
 */
-(NSArray *)addressDataWithPid:(NSString *)pid;
/**
 *  根据id返回地址
 *
 *  @param aid
 *
 *  @return
 */
-(NSArray *)addressByAId : (id) aid;
/**
 *  所有城市
 *
 *  @return
 */
-(NSArray *)allCity;
/**
 *  根据板块id返回地址
 *
 *  @param regionId
 *
 *  @return
 */
-(NSString *)addressWithRegionId:(NSString *)regionId;
-(NSString *)addressIdWithCityName:(NSString *)name;

@end
