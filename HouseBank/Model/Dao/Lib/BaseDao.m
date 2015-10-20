//
//  BaseDao.m
//  wasai
//
//  Created by apple on 14-3-27.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import "BaseDao.h"
#import "Config.h"
#import "ObjectUtil.h"
#import "TextUtil.h"

#define DbName @"FY.db"
#define DbVersion 3

@interface BaseDao (Private)
-(void) createTable :(sqlite3 *)db ;
-(void) update: (sqlite3 *)db sqls : (NSArray *) sqls  ; //执行数据库升级方法
-(void) close : (sqlite3 *) dbHandle; //关闭一个数据库
-(void) onCreate : (sqlite3 *) db ; //当数据库创建时回调
-(void) onUpgrade : (sqlite3 *) db oldVersion : (NSInteger) oldVersion newVersion : (NSInteger) newVersion ;//当数据库版本发生变化时回调
@end

@implementation BaseDao

-(void) onCreate:(sqlite3 *)db{
    [self createTable : db];
    [self onUpgrade:db oldVersion:0 newVersion:_version];
}

-(void) onUpgrade:(sqlite3 *)db oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion {
    NSLog(@"onUpgrade %ld , %ld",(long)oldVersion,(long)newVersion);
    
    NSString *newsTable = @"create table if not exists News(articleId primary key,title,content,imagePath,createUserName,url)";
    
    NSMutableArray *sqls = [[NSMutableArray alloc] init];
    [sqls addObject:newsTable];
    [self update:db sqls : sqls];
    [sqls release];
}

-(void) close:(sqlite3 *)dbHandle{
    if (dbHandle != nil) {
        sqlite3_close(dbHandle);
        dbHandle = nil;
    }
}

-(id) initWithVersionAndName:(NSInteger)version path:(NSString *)path{
    if (self = [super init]) {
        _version = version < 1 ? 1 : version;
        _path = [path retain];
    }
    return self;
}

-(void) createTable : (sqlite3 *)db{
    NSLog(@"%@",_path);
    @autoreleasepool {;
        NSString *searchHouseTable = @"create table if not exists SearchHouseHistory(ID integer primary key,name,tid)";
        
        NSMutableArray *sqls = [[NSMutableArray alloc] init];
        [sqls addObject:searchHouseTable];
        [self update:db sqls : sqls];
        [sqls release];
    }
}

-(id) init{
    if (self = [super init]) {
        _version = DbVersion;
        _path = [self sqlitePathWithName:DbName];
    }
    return self;
}

-(NSString *) sqlitePathWithName : (NSString *) name{
    NSString *documentsDirectory = [self documentPath];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:name];
    return writableDBPath;
}

-(NSString *) documentPath {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
};

-(void) update:(sqlite3 *)db sqls:(NSArray *)sqls{
    char *begin = "BEGIN";
    char *commit = "COMMIT";
    char *errorMsg;
    @try {
        if (sqls) {
            if (sqlite3_exec(db, begin, NULL, NULL, &errorMsg)==SQLITE_OK){
                sqlite3_free(errorMsg);
                for (NSString *sql in sqls) {
                    sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
                    sqlite3_free(errorMsg) ;
                }
            }else{
                sqlite3_free(errorMsg);
            }
            sqlite3_exec(db, commit, NULL, NULL, &errorMsg);
            sqlite3_free(errorMsg) ;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"name : %@ , reason : %@",[exception name],[exception reason]);
        [exception release];
    }
}

-(void) update:(NSArray *) sqls {
    if (sqls) {
        sqlite3* db = [super openWithVersion:_version path:_path];
        @try{
            [self update:db sqls:sqls];}
        @finally {
            [self close : db];
        }
    }
}

-(id) dataByAdapter:(id<DataAdapter>)adapter sql:(NSString *)sql{
    if ([adapter respondsToSelector:@selector(stmt2Object:)]) {
        sqlite3* db = [super openWithVersion:_version path:_path];
        sqlite3_stmt *stmt;
        const char * sqlChar =[sql UTF8String];
        @try {
            if (sqlite3_prepare_v2(db,sqlChar , -1, &stmt, nil) == SQLITE_OK) {
                return [adapter stmt2Object : stmt];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"name : %@ , reason : %@",[exception name],[exception reason]);
            [exception release];
        }
        @finally {
            sqlite3_finalize(stmt);
            [self close:db];
        }
    }
    return nil;
}

-(NSString *) object2InsertSql:(NSString *)tableName obj:(id)obj{
    NSMutableString *mutableSql = [[[NSMutableString alloc] init]autorelease];
    [mutableSql appendFormat:@"insert into %@(",tableName];
    NSDictionary *dic = [ObjectUtil object2Dictionary:obj];
    NSArray *keys = [dic allKeys];
    for (int i=0; i<[keys count]; i++) {
        [mutableSql appendString:[ keys objectAtIndex:i]];
        if (i<[keys count]-1) {
            [mutableSql appendString:@","];
        }
    }
    [mutableSql appendString:@")"];
    [mutableSql appendString:@"values("];
    for (int i=0; i<[keys count]; i++) {
        [mutableSql appendFormat:@"%@%@%@",@"'",[TextUtil sqliteEscape:[dic valueForKey:[ keys objectAtIndex:i]]],@"'"];
        if (i<[keys count]-1) {
            [mutableSql appendString:@","];
        }
    }
    [mutableSql appendString:@");"];
    return [mutableSql description];
}

-(void) test{
    sqlite3 *db =  [self openWithVersion:_version path:_path];
    [self close:db];
    NSLog(@"%@",_path);
}

@end
