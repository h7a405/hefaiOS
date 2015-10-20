//
//  SqliteHelper.h
//  Jnrlink
//
//  Created by apple on 14-4-12.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@protocol SqliteDelegation
@optional
-(void) onCreate : (sqlite3 *) db ; //当数据库创建时回调
-(void) onUpgrade : (sqlite3 *) db oldVersion : (NSInteger) oldVersion newVersion : (NSInteger) newVersion ;//当数据库版本发生变化时回调
@end

@interface SqliteHelper : NSObject<SqliteDelegation>
-(sqlite3 *) openWithVersion : (NSInteger) version  path : (NSString *) path;//获得一个db实例

@end
