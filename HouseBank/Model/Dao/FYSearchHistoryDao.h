//
//  FYSearchHistoryDao.h
//  HouseBank
//
//  Created by CSC on 14/12/2.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"

//房子搜索记录数据操作类
@interface FYSearchHistoryDao : FYBaseDao

/**
 *  二手房搜索历史
 *
 *  @return
 */
-(NSArray *)searchHistory;

/**
 *  保存历史
 *
 *  @param dict
 */
-(void)saveHistory:(NSDictionary *)dict;

/**
 *  删除所有搜索记录
 */
-(void)removeAllHistory;

@end
