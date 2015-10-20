//
//  Data.h
//  首页新闻模型
//  Created by   on 14-9-15
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSURL *imagePath;
@property (nonatomic, copy) NSString *createUserName;
@property (nonatomic, copy) NSString *articleId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
