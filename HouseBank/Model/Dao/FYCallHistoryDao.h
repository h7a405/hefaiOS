//
//  FYCallHistoryDao.h
//  HouseBank
//
//  Created by CSC on 14/12/4.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"

@interface FYCallHistoryDao : FYBaseDao

/**
 *  保存通话记录
 *
 *  @param houseId   房子ID
 *  @param houseType 1：二手房 2：租房 3：新房
 */
-(void)saveCallHistoryWithHouseId:(NSString *)houseId andHouseType:(NSString *)houseType;


@end
