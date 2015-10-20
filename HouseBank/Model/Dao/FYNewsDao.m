//
//  FYNewsDao.m
//  HouseBank
//
//  Created by CSC on 14/12/8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYNewsDao.h"
#import "ArticleData.h"

@interface NewsAdapter : NSObject<DataAdapter>
@end

@implementation NewsAdapter

-(id) stmt2Object:(sqlite3_stmt *)stmt{
    NSMutableArray *array = [NSMutableArray new];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        ArticleData *article = [ArticleData new];
        article.articleId = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 0)];
        article.title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
        article.content = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)];
        article.imagePath = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 3)];
        article.createUserName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 4)];
        article.url = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 5)];
        [array addObject:article];
    }
    return array;
}

@end

@implementation FYNewsDao
-(void)saveAllNewsWithData:(NSArray *)data{
    NSMutableArray *sqls = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        NSString *sql = [NSString stringWithFormat:@"replace into News(articleId,title,content,imagePath,createUserName,url) values('%@','%@','%@','%@','%@','%@')",[NSString stringWithFormat:@"%@",dict[kDataForActicleArticleId]],dict[kDataForActicleTitle],[TextUtil sqliteEscape:dict[kDataForActicleContent]],[NSString stringWithFormat:@"%@",[Tool imageUrlWithPath:dict[kDataForActicleImagePath] andTypeString:@"D02"]],dict[kDataForActicleCreateUserName],dict[kUrl]];
        [sqls addObject:sql];
    }];
    
    [super update:sqls];
}

-(NSArray *)allNews{
    NSString *sql = @"select * from News";
    NSArray *tmp = [super dataByAdapter:[NewsAdapter new] sql:sql];
    return tmp;
}
@end
