//
//  MoreInfos.m
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MoreInfos.h"
#import "NSObject+Json.h"

NSString *const kMoreInfos10ForCommunity = @"10";
NSString *const kMoreInfos2ForCommunity = @"2";
NSString *const kMoreInfos15ForCommunity = @"15";
NSString *const kMoreInfos9ForCommunity = @"9";
NSString *const kMoreInfos3ForCommunity = @"3";
NSString *const kMoreInfos11ForCommunity = @"11";
NSString *const kMoreInfos4ForCommunity = @"4";
NSString *const kMoreInfos5ForCommunity = @"5";
NSString *const kMoreInfos12ForCommunity = @"12";
NSString *const kMoreInfos6ForCommunity = @"6";
NSString *const kMoreInfos13ForCommunity = @"13";
NSString *const kMoreInfos7ForCommunity = @"7";
NSString *const kMoreInfos8ForCommunity = @"8";
NSString *const kMoreInfos255ForCommunity = @"255";
NSString *const kMoreInfos1ForCommunity = @"1";
NSString *const kMoreInfos14ForCommunity = @"14";



@implementation MoreInfos

@synthesize t_10 = _t_10;
@synthesize t_2 = _t_2;
@synthesize t_15 = _t_15;
@synthesize t_9 = _t_9;
@synthesize t_3 = _t_3;
@synthesize t_11 = _t_11;
@synthesize t_4 = _t_4;
@synthesize t_5 = _t_5;
@synthesize t_12 = _t_12;
@synthesize t_6 = _t_6;
@synthesize t_13 = _t_13;
@synthesize t_7 = _t_7;
@synthesize t_8 = _t_8;
@synthesize t_255 = _t_255;
@synthesize t_1 = _t_1;
@synthesize t_14 = _t_14;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.t_10 = [self objectOrNilForKey:kMoreInfos10ForCommunity fromDictionary:dict];
            self.t_2 = [self objectOrNilForKey:kMoreInfos2ForCommunity fromDictionary:dict];
            self.t_15 = [self objectOrNilForKey:kMoreInfos15ForCommunity fromDictionary:dict];
            self.t_9 = [self objectOrNilForKey:kMoreInfos9ForCommunity fromDictionary:dict];
            self.t_3 = [self objectOrNilForKey:kMoreInfos3ForCommunity fromDictionary:dict];
            self.t_11 = [self objectOrNilForKey:kMoreInfos11ForCommunity fromDictionary:dict];
            self.t_4 = [self objectOrNilForKey:kMoreInfos4ForCommunity fromDictionary:dict];
            self.t_5 = [self objectOrNilForKey:kMoreInfos5ForCommunity fromDictionary:dict];
            self.t_12 = [self objectOrNilForKey:kMoreInfos12ForCommunity fromDictionary:dict];
            self.t_6 = [self objectOrNilForKey:kMoreInfos6ForCommunity fromDictionary:dict];
            self.t_13 = [self objectOrNilForKey:kMoreInfos13ForCommunity fromDictionary:dict];
            self.t_7 = [self objectOrNilForKey:kMoreInfos7ForCommunity fromDictionary:dict];
            self.t_8 = [self objectOrNilForKey:kMoreInfos8ForCommunity fromDictionary:dict];
            self.t_255 = [self objectOrNilForKey:kMoreInfos255ForCommunity fromDictionary:dict];
            self.t_1 = [self objectOrNilForKey:kMoreInfos1ForCommunity fromDictionary:dict];
            self.t_14 = [self objectOrNilForKey:kMoreInfos14ForCommunity fromDictionary:dict];
    }
    return self;
}


@end
