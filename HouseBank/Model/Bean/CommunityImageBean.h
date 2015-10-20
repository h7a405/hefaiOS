//
//  Images.h
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CommunityImageBean : NSObject

@property (nonatomic, copy) NSString * imageId;
@property (nonatomic, copy) NSString * defaulted;
@property (nonatomic, copy) NSString *imagePath;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
