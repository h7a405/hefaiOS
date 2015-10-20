//
//  NSDictionary+String.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "NSDictionary+String.h"

@implementation NSDictionary (String)
-(NSDictionary *)allStringObjDict
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:self];
    NSArray *allKey=[dict allKeys];
    [allKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id objDict=[self objectForKey:obj];
        if ([objDict isKindOfClass:[NSString class] ]||[objDict isKindOfClass:[NSArray class]]||[objDict isKindOfClass:[NSDictionary class]]) {
        }else if ([objDict isKindOfClass:[NSNull class]]||objDict==nil){
            [dict setObject:@"" forKey:obj];
        }else{
            [dict setObject:[NSString stringWithFormat:@"%@",objDict] forKey:obj];
        }
    }];
    return dict;
}
@end
