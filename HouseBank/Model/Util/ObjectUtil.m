//
//  ObjectUtil.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "ObjectUtil.h"
#import <objc/runtime.h>

@implementation ObjectUtil
+(id) objFromDic : (NSDictionary *) dic obj:(id)obj{
    NSEnumerator *keyEnumerator = [dic keyEnumerator];
    for (NSString *key in keyEnumerator) {
        [obj setValue:[dic objectForKey:key] forKey:key];
    }
    
    return obj;
};

+(id) object2Dictionary:(id)obj{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSUInteger outCount = 0;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for( int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const  char *c = property_getName(property);
        NSString *key = [NSString stringWithUTF8String : c];
        id value = [obj valueForKey:key];
        if (value) {
            [dic setObject:value forKey:key];
        }else{
            [dic setObject:@"" forKey:key];
        }
    }
    free(properties);
    return dic;
}

+(id) replaceNil :(id) replace {
    if (replace == nil) {
        return @"";
    }
    return replace  ;
};

@end
