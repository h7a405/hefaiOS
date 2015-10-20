//
//  CSBaseDao.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"

@interface FYBaseDao : BaseDao

-(NSManagedObjectContext *)openDB;

@end
