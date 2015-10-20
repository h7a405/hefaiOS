//
//  ArticleData.m
//  HouseBank
//
//  Created by CSC on 14/12/8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "ArticleData.h"
#import "FYNewsDao.h"


@implementation ArticleData

@synthesize title;
@synthesize articleId;
@synthesize createUserName;
@synthesize imagePath;
@synthesize content;
@synthesize url;

+(void)saveAllArticleData:(NSArray *)array
{
    [[[FYNewsDao alloc]init]saveAllNewsWithData:array];
}
+(NSArray *)allArticle
{
    return [[[FYNewsDao alloc]init] allNews];
}
@end
