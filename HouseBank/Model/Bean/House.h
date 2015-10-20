//
//  Data.h
//
//  Created by   on 14-9-15
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString* livingRooms;
@property (nonatomic, copy) NSString* houseId;
@property (nonatomic, copy) NSString* communityId;
@property (nonatomic, copy) NSString* regionId;
@property (nonatomic, copy) NSString* bedRooms;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* featureIcon;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString* buildArea;
@property (nonatomic, copy) NSString *community;
@property (nonatomic, copy) NSString *advTitle;
@property (nonatomic, strong) NSURL *imagePath;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
