//
//  NSObject+Json.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)
+(id)modelWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
/**
 *  去除model中数据为null
 *
 *  @param aKey
 *  @param dict
 *
 *  @return 
 */
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
@end
