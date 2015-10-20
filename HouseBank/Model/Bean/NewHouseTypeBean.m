//
//  BaseClass.m
//
//  Created by   on 14-9-24
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "NewHouseTypeBean.h"
#import "NSDictionary+String.h"

NSString *const kBaseClassLivingRoomsForNewHouseType = @"livingRooms";
NSString *const kBaseClassUnitIdForNewHouseType = @"unitId";
NSString *const kBaseClassImagePathForNewHouseType = @"imagePath";
NSString *const kBaseClassTowardForNewHouseType = @"toward";
NSString *const kBaseClassHotPointForNewHouseType = @"hotPoint";
NSString *const kBaseClassCommunityIdForNewHouseType = @"communityId";
NSString *const kBaseClassSellStatusForNewHouseType = @"sellStatus";
NSString *const kBaseClassAveragePriceForNewHouseType = @"averagePrice";
NSString *const kBaseClassBedRoomsForNewHouseType = @"bedRooms";
NSString *const kBaseClassPurposeForNewHouseType = @"purpose";
NSString *const kBaseClassUnitNameForNewHouseType = @"unitName";
NSString *const kBaseClassWashRoomsForNewHouseType = @"washRooms";
NSString *const kBaseClassCreateUserIdForNewHouseType = @"createUserId";
NSString *const kBaseClassCreateTimeForNewHouseType = @"createTime";
NSString *const kBaseClassBuildAreaForNewHouseType = @"buildArea";
NSString *const kBaseClassMainUnitForNewHouseType = @"mainUnit";
NSString *const kBaseClassUnitCountForNewHouseType = @"unitCount";


@interface NewHouseTypeBean ()

- (id)objectOrNilForKey:(id)aKey  fromDictionary:(NSDictionary *)dict;

@end

@implementation NewHouseTypeBean

@synthesize livingRooms = _livingRooms;
@synthesize unitId = _unitId;
@synthesize imagePath = _imagePath;
@synthesize toward = _toward;
@synthesize hotPoint = _hotPoint;
@synthesize communityId = _communityId;
@synthesize sellStatus = _sellStatus;
@synthesize averagePrice = _averagePrice;
@synthesize bedRooms = _bedRooms;
@synthesize purpose = _purpose;
@synthesize unitName = _unitName;
@synthesize washRooms = _washRooms;
@synthesize createUserId = _createUserId;
@synthesize createTime = _createTime;
@synthesize buildArea = _buildArea;
@synthesize mainUnit = _mainUnit;
@synthesize unitCount = _unitCount;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:[dict allStringObjDict]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.livingRooms = [self objectOrNilForKey:kBaseClassLivingRoomsForNewHouseType  fromDictionary:dict] ;
            self.unitId = [self objectOrNilForKey:kBaseClassUnitIdForNewHouseType  fromDictionary:dict] ;
            self.imagePath = [Tool imageUrlWithPath:[self objectOrNilForKey:kBaseClassImagePathForNewHouseType fromDictionary:dict] andTypeString:@"D01"];;
            self.toward = [self objectOrNilForKey:kBaseClassTowardForNewHouseType  fromDictionary:dict] ;
            self.hotPoint = [self objectOrNilForKey:kBaseClassHotPointForNewHouseType  fromDictionary:dict];
            self.communityId = [self objectOrNilForKey:kBaseClassCommunityIdForNewHouseType  fromDictionary:dict] ;
            self.sellStatus = [self objectOrNilForKey:kBaseClassSellStatusForNewHouseType  fromDictionary:dict] ;
            self.averagePrice = [self objectOrNilForKey:kBaseClassAveragePriceForNewHouseType  fromDictionary:dict] ;
            self.bedRooms = [self objectOrNilForKey:kBaseClassBedRoomsForNewHouseType  fromDictionary:dict] ;
            self.purpose = [self objectOrNilForKey:kBaseClassPurposeForNewHouseType  fromDictionary:dict] ;
            self.unitName = [self objectOrNilForKey:kBaseClassUnitNameForNewHouseType  fromDictionary:dict];
            self.washRooms = [self objectOrNilForKey:kBaseClassWashRoomsForNewHouseType  fromDictionary:dict] ;
            self.createUserId = [self objectOrNilForKey:kBaseClassCreateUserIdForNewHouseType  fromDictionary:dict] ;
            self.createTime = [self objectOrNilForKey:kBaseClassCreateTimeForNewHouseType  fromDictionary:dict] ;
            self.buildArea = [self objectOrNilForKey:kBaseClassBuildAreaForNewHouseType  fromDictionary:dict] ;
            self.mainUnit = [self objectOrNilForKey:kBaseClassMainUnitForNewHouseType  fromDictionary:dict] ;
            self.unitCount =[self objectOrNilForKey:kBaseClassUnitCountForNewHouseType  fromDictionary:dict] ;

    }
    
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey  fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}


@end
