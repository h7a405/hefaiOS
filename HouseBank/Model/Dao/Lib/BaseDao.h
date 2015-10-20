//
//  BaseDao.h
//  wasai
//
//  Created by apple on 14-3-27.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SqliteHelper.h"

@protocol DataAdapter <NSObject>
@required
-(id) stmt2Object : (sqlite3_stmt *) stmt ;
@end

/**
 数据库基类，负责与数据库对接的类，所有的数据库操作都在该类执行，包括打开数据库，关闭数据库
 增删改查等等操作，需要与数据库进行交互的类需要继承该类 。
 */
@interface BaseDao : SqliteHelper{
    NSInteger _version;
    NSString *_path;
}

/**
 1、该方法传入一个字符串可变参数，可变参数里的每一个参数都对应一句sql语句
 2、开启事务提交每一句sql语句
 3、该方法已经处理了异常，出现错误将不会导致程序崩溃，但是可能会导致数据没有被处理。
 5、该方法处理的是数据库直接提交的处理，没有返回值，即增、删、改等操作
 */
-(void) update : (NSArray *) sqls ;

/**
 1 、根据数据适配器获取数据，该方法返回值很可能时一个可变数组，具体什么类型的返回值将由适配器决定。
 2 、该方法的第二个参数是一个sql语句，对数据库的查询将由该语句执行。
 */
-(id) dataByAdapter : (id<DataAdapter>) adapter sql : (NSString *) sql ;

/**
 当version与当前版本的version不一致时将执行onUpgrade方法 version必须要大于0，否则将强制使用1
 使用不同的version可能导致-(void) onUpgrade : (sqlite3 *) db oldVersion : (NSInteger) oldVersion newVersion : (NSInteger) newVersion ; 方法的执行
 */
-(id) initWithVersionAndName : (NSInteger) version path : (NSString *) path;

-(NSString *) object2InsertSql : (NSString *) tableName obj : (id) obj;

-(void) test;

@end


