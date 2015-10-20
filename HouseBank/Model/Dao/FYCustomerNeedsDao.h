//
//  FYCustomerNeedsDao.h
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"

@interface FYCustomerNeedsDao : FYBaseDao

/**
 *  搜索客需记录
 *
 *  @return
 */
-(NSArray *)searchHistoryForNeed;
/**
 *  保存客需搜索记录
 *
 *  @param community
 */
-(void)saveHistoryForNeed:(NSDictionary *)community;
/**
 *  删除所有客需搜索记录
 */
-(void)removeAllHistoryForNeed;

@end
