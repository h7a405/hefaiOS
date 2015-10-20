//
//  ArticleData.h
//  HouseBank
//
//  Created by CSC on 14/12/8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString *const kDataForActicleTitle = @"title";
static NSString *const kDataForActicleContent = @"content";
static NSString *const kDataForActicleImagePath = @"imagePath";
static NSString *const kDataForActicleCreateUserName = @"createUserName";
static NSString *const kDataForActicleArticleId = @"articleId";
static NSString *const kUrl = @"url";

@interface ArticleData : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * articleId;
@property (nonatomic, copy) NSString * createUserName;
@property (nonatomic, copy) NSString * imagePath;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * url;
+(void)saveAllArticleData:(NSArray *)array;
+(NSArray *)allArticle;
@end
