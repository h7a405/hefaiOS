//
//  FYNewsDao.h
//  HouseBank
//
//  Created by CSC on 14/12/8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"

@interface FYNewsDao : FYBaseDao
-(void)saveAllNewsWithData:(NSArray *)data;
-(NSArray *)allNews;
@end
