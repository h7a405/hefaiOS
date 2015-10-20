//
//  SqliteHelper.m
//  Jnrlink
//
//  Created by apple on 14-4-12.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import "SqliteHelper.h"

@interface SqliteHelper (Private)
-(NSInteger) version : (sqlite3 *) db;//获取当前数据库版本
-(void) setVersion : (sqlite3*)db version : (NSInteger) version ;//设置当前数据库版本
@end

@implementation SqliteHelper
-(sqlite3 *) openWithVersion:(NSInteger) newVersion path:(NSString *)path{
    @autoreleasepool {
        sqlite3 *dbHandle;
        if (sqlite3_open([path UTF8String], &dbHandle)==SQLITE_OK) {
            NSInteger version = [self version : dbHandle];
            if (version != newVersion){
                if (version == 0) {
                    [self onCreate:dbHandle];
                }else {
                    [self onUpgrade:dbHandle oldVersion : version newVersion : newVersion];
                }
                [self setVersion:dbHandle version : newVersion];
            }
            return dbHandle;
        }
        return nil;
    }
}

-(NSInteger) version:(sqlite3 *)db{
    sqlite3_stmt *stmt;
    NSString *sql = @"PRAGMA user_version;";
    @try {
        if (sqlite3_prepare_v2(db,[sql UTF8String] , -1, &stmt, nil) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                int i = sqlite3_column_int(stmt, 0);
                return i;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"name : %@ , reason : %@",[exception name],[exception reason]);
        [exception release];
    }
    @finally {
        sqlite3_finalize(stmt);
    }
}

-(void) setVersion:(sqlite3 *)db version:(NSInteger)version{
    @autoreleasepool {
        char *errorMsg;
        NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version=%d",(int)version];
        sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
        sqlite3_free(errorMsg) ;
    }
}

-(void) close:(sqlite3 *)dbHandle{
    if (dbHandle != nil) {
        sqlite3_close(dbHandle);
        dbHandle = nil;
    }
}
@end
