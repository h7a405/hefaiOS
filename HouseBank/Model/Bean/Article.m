//
//  Data.m
//
//  Created by   on 14-9-15
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Article.h"
#import "NSObject+Json.h"

NSString *const kDataTitle = @"title";
NSString *const kDataContent = @"content";
NSString *const kDataImagePath = @"imagePath";
NSString *const kDataCreateUserName = @"createUserName";
NSString *const kDataArticleId = @"articleId";



@implementation Article

@synthesize title = _title;
@synthesize content = _content;
@synthesize imagePath = _imagePath;
@synthesize createUserName = _createUserName;
@synthesize articleId = _articleId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.title = [self objectOrNilForKey:kDataTitle fromDictionary:dict];
        self.content = [self objectOrNilForKey:kDataContent fromDictionary:dict];
        
        self.imagePath = [Tool imageUrlWithPath:[self objectOrNilForKey:kDataImagePath fromDictionary:dict] andTypeString:@"D02"];
        self.createUserName = [self objectOrNilForKey:kDataCreateUserName fromDictionary:dict];
        self.articleId = [self objectOrNilForKey:kDataArticleId fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kDataTitle];
    [mutableDict setValue:self.content forKey:kDataContent];
    [mutableDict setValue:self.imagePath forKey:kDataImagePath];
    [mutableDict setValue:self.createUserName forKey:kDataCreateUserName];
    [mutableDict setValue:self.articleId forKey:kDataArticleId];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    self.title = [aDecoder decodeObjectForKey:kDataTitle];
    self.content = [aDecoder decodeObjectForKey:kDataContent];
    self.imagePath = [aDecoder decodeObjectForKey:kDataImagePath];
    self.createUserName = [aDecoder decodeObjectForKey:kDataCreateUserName];
    self.articleId = [aDecoder decodeObjectForKey:kDataArticleId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:kDataTitle];
    [aCoder encodeObject:_content forKey:kDataContent];
    [aCoder encodeObject:_imagePath forKey:kDataImagePath];
    [aCoder encodeObject:_createUserName forKey:kDataCreateUserName];
    [aCoder encodeObject:_articleId forKey:kDataArticleId];
}

- (id)copyWithZone:(NSZone *)zone{
    Article *copy = [[Article alloc] init];
    if (copy) {
        copy.title = [self.title copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
        copy.createUserName = [self.createUserName copyWithZone:zone];
        copy.articleId = self.articleId;
    }
    
    return copy;
}


@end
