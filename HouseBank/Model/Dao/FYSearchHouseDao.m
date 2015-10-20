
//
//  FYSearchHouseDao.m
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYSearchHouseDao.h"

@interface Adapter : NSObject<DataAdapter>
@end
@implementation Adapter

-(id) stmt2Object:(sqlite3_stmt *)stmt{
    NSMutableArray *array = [NSMutableArray array];
    while (sqlite3_step(stmt)==SQLITE_ROW) {
        NSString *name =  [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
        [array addObject:name];
    }
    return array;
}

@end

@implementation FYSearchHouseDao

-(NSArray *) allSearchHouse {
    NSString *sql = @"select * from SearchHouseHistory";
    return [super dataByAdapter:[Adapter new] sql:sql];
};

-(void) insert : (NSString *) name houseId : (NSString *) houseId{
    NSString *sql = [NSString stringWithFormat:@"insert into SearchHouseHistory(name,tid) values('%@','%@')",name,houseId];
    [super update:[NSArray arrayWithObject:sql]];
};

-(void) removeAll{
    NSString *sql = @"delete from SearchHouseHistory";
    [super update:[NSArray arrayWithObject:sql]];
};

@end
