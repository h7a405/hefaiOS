//
//  BaseClass.m
//
//  Created by   on 14-9-23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "NewHouseBean.h"
#import "NSObject+Json.h"


NSString *const kBaseClassRegionForNewHouse = @"region";
NSString *const kBaseClassCommissionRateForNewHouse = @"commissionRate";
NSString *const kBaseClassImagePathForNewHouse = @"imagePath";
NSString *const kBaseClassLowestPriceForNewHouse = @"lowestPrice";
NSString *const kBaseClassProjectNameForNewHouse = @"projectName";
NSString *const kBaseClassHighestPriceForNewHouse = @"highestPrice";
NSString *const kBaseClassProjectIdForNewHouse = @"projectId";



@implementation NewHouseBean

@synthesize region = _region;
@synthesize commissionRate = _commissionRate;
@synthesize imagePath = _imagePath;
@synthesize lowestPrice = _lowestPrice;
@synthesize projectName = _projectName;
@synthesize highestPrice = _highestPrice;
@synthesize projectId = _projectId;
@synthesize totleHouse = _totleHouse;
@synthesize title = _title;
@synthesize address = _address;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.region = [self objectOrNilForKey:kBaseClassRegionForNewHouse fromDictionary:dict];
        self.commissionRate = [self objectOrNilForKey:kBaseClassCommissionRateForNewHouse fromDictionary:dict];
        self.imagePath = [Tool imageUrlWithPath:[self objectOrNilForKey:kBaseClassImagePathForNewHouse fromDictionary:dict] andTypeString:@"D01"];
        
        self.lowestPrice =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassLowestPriceForNewHouse fromDictionary:dict]];
        self.projectName = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassProjectNameForNewHouse fromDictionary:dict]];
        self.highestPrice =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassHighestPriceForNewHouse fromDictionary:dict]];
        self.projectId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassProjectIdForNewHouse fromDictionary:dict]];
        self.totleHouse = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:@"totleHouse" fromDictionary:dict]];
        self.title = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:@"title" fromDictionary:dict]];
    }
    return self;
    
}



@end
