//
//  NSObject+Json.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "NSObject+Json.h"
#import <objc/runtime.h>
@implementation NSObject (Json)

-(NSArray *)propertyKeys{
    unsigned int count;
    objc_property_t *propertyKeys = class_copyPropertyList([self class], &count);
    NSMutableArray *countArr = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        objc_property_t property = propertyKeys[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [countArr addObject:key];
    }
    free(propertyKeys);
    return countArr;
}
+(id)modelWithDict:(NSDictionary *)dict
{
    id obj=[[self alloc]initWithDict:dict];
    return obj;
}
-(id)initWithDict:(NSDictionary *)dict
{
    self=[self init];
    if (self) {
        NSArray *allKeys=[self propertyKeys];
        [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id property=[dict objectForKey:obj];
            [self setValue:property forKey:obj];
        }];
    }
    return self;
}
#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]||object==nil) {
        return @"";
    }
    return object;
}
@end
