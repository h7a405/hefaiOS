//
//  FYSearchHouseDao.h
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"

@interface FYSearchHouseDao : FYBaseDao

-(NSArray *) allSearchHouse ;
-(void) insert : (NSString *) name houseId : (NSString *) houseId ;
-(void) removeAll ;

@end
