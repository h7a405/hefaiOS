//
//  BrokerInfoModel.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BrokerInfoBean.h"
#import "ObjectUtil.h"

@implementation BrokerInfoBean

@synthesize authStatus ;
@synthesize blockId ;
@synthesize brokerHeadImg ;
@synthesize brokerId ;
@synthesize company ;
@synthesize companyId ;
@synthesize familiarBlock ;
@synthesize familiarCommunity ;
@synthesize mobilephone ;
@synthesize name ;
@synthesize region ;
@synthesize regionId ;
@synthesize resume ;
@synthesize store ;
@synthesize storeId ;
@synthesize workYear ;
@synthesize cityId ;

- (void)encodeWithCoder:(NSCoder *)encoder{
    NSDictionary *dic = [ObjectUtil object2Dictionary:self];
    NSEnumerator *keyEnumerator = [dic keyEnumerator];
    for (id key in keyEnumerator) {
        [encoder encodeObject:[dic objectForKey:key] forKey:key];
    }
}

-(id) initWithCoder:(NSCoder *) coder{
    if (self = [super init]) {
        NSDictionary *dic = [ObjectUtil object2Dictionary:self];
        NSEnumerator *keyEnumerator = [dic keyEnumerator];
        for (id key in keyEnumerator) {
            [self setValue:[coder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

+(BrokerInfoBean *) brokerFromDic:(NSDictionary *)dic{
    return [ObjectUtil objFromDic:dic obj:[BrokerInfoBean new]];
}

@end
