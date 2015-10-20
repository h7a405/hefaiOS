//
//  BaseClass.m
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CommunityBean.h"
#import "MoreInfos.h"
#import "CommunityImageBean.h"
#import "NSObject+Json.h"

NSString *const kBaseClassBlockIdForCommunity = @"blockId";
NSString *const kBaseClassDeveloperCorpForCommunity = @"developerCorp";
NSString *const kBaseClassMoreInfosForCommunity = @"moreInfos";
NSString *const kBaseClassPropertyTypeForCommunity = @"propertyType";
NSString *const kBaseClassCommunityIdForCommunity = @"communityId";
NSString *const kBaseClassLongitudeForCommunity = @"longitude";
NSString *const kBaseClassHouseNumForCommunity = @"houseNum";
NSString *const kBaseClassLatitudeForCommunity = @"latitude";
NSString *const kBaseClassRegionIdForCommunity = @"regionId";
NSString *const kBaseClassPriceForCommunity = @"price";
NSString *const kBaseClassAddressForCommunity = @"address";
NSString *const kBaseClassRegionForCommunity = @"region";
NSString *const kBaseClassImagesForCommunity = @"images";
NSString *const kBaseClassCommunityForCommunity = @"community";
NSString *const kBaseClassPropertyCorpForCommunity = @"propertyCorp";
NSString *const kBaseClassCompletionDateForCommunity = @"completionDate";




@implementation CommunityBean

@synthesize blockId = _blockId;
@synthesize developerCorp = _developerCorp;
@synthesize moreInfos = _moreInfos;
@synthesize propertyType = _propertyType;
@synthesize communityId = _communityId;
@synthesize longitude = _longitude;
@synthesize houseNum = _houseNum;
@synthesize latitude = _latitude;
@synthesize regionId = _regionId;
@synthesize price = _price;
@synthesize address = _address;
@synthesize region = _region;
@synthesize images = _images;
@synthesize community = _community;
@synthesize propertyCorp = _propertyCorp;
@synthesize completionDate = _completionDate;


+ (instancetype)communityBeanWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.blockId =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassBlockIdForCommunity fromDictionary:dict]] ;
        self.developerCorp =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassDeveloperCorpForCommunity fromDictionary:dict]];
        self.moreInfos = [MoreInfos modelObjectWithDictionary:[dict objectForKey:kBaseClassMoreInfosForCommunity]];
        self.propertyType = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassPropertyTypeForCommunity fromDictionary:dict]];
        self.communityId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassCommunityIdForCommunity fromDictionary:dict] ];
        self.longitude =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassLongitudeForCommunity fromDictionary:dict]] ;
        self.houseNum =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassHouseNumForCommunity fromDictionary:dict] ];
        self.latitude = [self objectOrNilForKey:kBaseClassLatitudeForCommunity fromDictionary:dict] ;
        self.regionId =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassRegionIdForCommunity fromDictionary:dict] ];
        self.price = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassPriceForCommunity fromDictionary:dict] ];
        self.address =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassAddressForCommunity fromDictionary:dict]];
        self.region = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassRegionForCommunity fromDictionary:dict]];
        NSObject *receivedImages = [dict objectForKey:kBaseClassImagesForCommunity];
        NSMutableArray *parsedImages = [NSMutableArray array];
        if ([receivedImages isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedImages) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedImages addObject:[CommunityImageBean modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedImages isKindOfClass:[NSDictionary class]]) {
            [parsedImages addObject:[CommunityImageBean modelObjectWithDictionary:(NSDictionary *)receivedImages]];
        }
        self.images = [NSArray arrayWithArray:parsedImages];
        self.community =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassCommunityForCommunity fromDictionary:dict]];
        self.propertyCorp = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassPropertyCorpForCommunity fromDictionary:dict]];
        self.completionDate = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassCompletionDateForCommunity fromDictionary:dict]];
    }
    
    return self;
}

@end
