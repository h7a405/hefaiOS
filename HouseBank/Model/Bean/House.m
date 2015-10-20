//
//  Data.m
//
//  Created by   on 14-9-15
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "House.h"
#import "NSObject+Json.h"

NSString *const kDataLivingRooms = @"livingRooms";
NSString *const kDataHouseId = @"houseId";
NSString *const kDataCommunityId = @"communityId";
NSString *const kDataRegionId = @"regionId";
NSString *const kDataBedRooms = @"bedRooms";
NSString *const kDataPrice = @"price";
NSString *const kDataFeatureIcon = @"featureIcon";
NSString *const kDataRegion = @"region";
NSString *const kDataBuildArea = @"buildArea";
NSString *const kDataCommunity = @"community";
NSString *const kDataAdvTitle = @"advTitle";
NSString *const kDataImagePathForHouse = @"imagePath";



@implementation House

@synthesize livingRooms = _livingRooms;
@synthesize houseId = _houseId;
@synthesize communityId = _communityId;
@synthesize regionId = _regionId;
@synthesize bedRooms = _bedRooms;
@synthesize price = _price;
@synthesize featureIcon = _featureIcon;
@synthesize region = _region;
@synthesize buildArea = _buildArea;
@synthesize community = _community;
@synthesize advTitle = _advTitle;
@synthesize imagePath = _imagePath;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.livingRooms =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kDataLivingRooms fromDictionary:dict]];
        self.houseId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kDataHouseId fromDictionary:dict]];
        self.communityId =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kDataCommunityId fromDictionary:dict]];
        self.regionId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kDataRegionId fromDictionary:dict]];
        self.bedRooms =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kDataBedRooms fromDictionary:dict]];
        self.price = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kDataPrice fromDictionary:dict]];
        self.featureIcon = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kDataFeatureIcon fromDictionary:dict]];
        self.region = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kDataRegion fromDictionary:dict]];
        self.buildArea = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kDataBuildArea fromDictionary:dict]];
        self.community = [self objectOrNilForKey:kDataCommunity fromDictionary:dict];
       
        self.advTitle = [self objectOrNilForKey:kDataAdvTitle fromDictionary:dict];
        self.imagePath =[Tool imageUrlWithPath:[self objectOrNilForKey:kDataImagePathForHouse fromDictionary:dict] andTypeString:@"D01"];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.livingRooms forKey:kDataLivingRooms];
    [mutableDict setValue:self.houseId forKey:kDataHouseId];
    [mutableDict setValue:self.communityId forKey:kDataCommunityId];
    [mutableDict setValue:self.regionId forKey:kDataRegionId];
    [mutableDict setValue:self.bedRooms forKey:kDataBedRooms];
    [mutableDict setValue:self.price forKey:kDataPrice];
    [mutableDict setValue:self.featureIcon forKey:kDataFeatureIcon];
    [mutableDict setValue:self.region forKey:kDataRegion];
    [mutableDict setValue:self.buildArea forKey:kDataBuildArea];
    [mutableDict setValue:self.community forKey:kDataCommunity];
    [mutableDict setValue:self.advTitle forKey:kDataAdvTitle];
    
    [mutableDict setValue:self.imagePath forKey:kDataImagePathForHouse];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}




#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.livingRooms = [aDecoder decodeObjectForKey:kDataLivingRooms];
    self.houseId = [aDecoder decodeObjectForKey:kDataHouseId];
    self.communityId = [aDecoder decodeObjectForKey:kDataCommunityId];
    self.regionId = [aDecoder decodeObjectForKey:kDataRegionId];
    self.bedRooms = [aDecoder decodeObjectForKey:kDataBedRooms];
    self.price = [aDecoder decodeObjectForKey:kDataPrice];
    self.featureIcon = [aDecoder decodeObjectForKey:kDataFeatureIcon];
    self.region = [aDecoder decodeObjectForKey:kDataRegion];
    self.buildArea = [aDecoder decodeObjectForKey:kDataBuildArea];
    self.community = [aDecoder decodeObjectForKey:kDataCommunity];
    self.advTitle = [aDecoder decodeObjectForKey:kDataAdvTitle];
    self.imagePath = [aDecoder decodeObjectForKey:kDataImagePathForHouse];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_livingRooms forKey:kDataLivingRooms];
    [aCoder encodeObject:_houseId forKey:kDataHouseId];
    [aCoder encodeObject:_communityId forKey:kDataCommunityId];
    [aCoder encodeObject:_regionId forKey:kDataRegionId];
    [aCoder encodeObject:_bedRooms forKey:kDataBedRooms];
    [aCoder encodeObject:_price forKey:kDataPrice];
    [aCoder encodeObject:_featureIcon forKey:kDataFeatureIcon];
    [aCoder encodeObject:_region forKey:kDataRegion];
    [aCoder encodeObject:_buildArea forKey:kDataBuildArea];
    [aCoder encodeObject:_community forKey:kDataCommunity];
    [aCoder encodeObject:_advTitle forKey:kDataAdvTitle];
    [aCoder encodeObject:_imagePath forKey:kDataImagePathForHouse];
}

- (id)copyWithZone:(NSZone *)zone
{
    House *copy = [[House alloc] init];
    
    if (copy) {
        
        copy.livingRooms = self.livingRooms;
        copy.houseId = self.houseId;
        copy.communityId = self.communityId;
        copy.regionId = self.regionId;
        copy.bedRooms = self.bedRooms;
        copy.price = self.price;
        copy.featureIcon = self.featureIcon;
        copy.region = [self.region copyWithZone:zone];
        copy.buildArea = self.buildArea;
        copy.community = [self.community copyWithZone:zone];
        copy.advTitle = [self.advTitle copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
    }
    
    return copy;
}


@end
