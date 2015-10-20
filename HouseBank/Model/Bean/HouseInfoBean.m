//
//  BaseClass.m
//
//  Created by   on 14-9-19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HouseInfoBean.h"
#import "HouseInfoImageBean.h"
#import "NSObject+Json.h"

NSString *const kBaseClassBrokerIdForHouseInfo = @"brokerId";
NSString *const kBaseClassLivingRoomsHouseInfo = @"livingRooms";
NSString *const kBaseClassTotalFloorHouseInfo = @"totalFloor";
NSString *const kBaseClassTotalPriceHouseInfo = @"totalPrice";
NSString *const kBaseClassAdvTitleHouseInfo = @"advTitle";
NSString *const kBaseClassLeftCommissionHouseInfo = @"leftCommission";
NSString *const kBaseClassCommunityIdHouseInfo = @"communityId";
NSString *const kBaseClassExclusiveDelegateHouseInfo = @"exclusiveDelegate";
NSString *const kBaseClassTradeTypeHouseInfo = @"tradeType";
NSString *const kBaseClassTowardHouseInfo = @"toward";
NSString *const kBaseClassAdvDescHouseInfo = @"advDesc";
NSString *const kBaseClassBedRoomsHouseInfo = @"bedRooms";
NSString *const kBaseClassHouseFloorHouseInfo = @"houseFloor";
NSString *const kBaseClassImagesHouseInfo = @"images";
NSString *const kBaseClassBuildYearHouseInfo = @"buildYear";
NSString *const kBaseClassBuildAreaHouseInfo = @"buildArea";
NSString *const kBaseClassDecorationStateHouseInfo = @"decorationState";
NSString *const kBaseClassSellerDividedHouseInfo = @"sellerDivided";
NSString *const kBaseClassHouseIdHouseInfo = @"houseId";
NSString *const kBaseClassPurposeHouseInfo = @"purpose";
NSString *const kBaseClassCreateTimeHouseInfo = @"createTime";
NSString *const kBaseClassRightCommissionHouseInfo = @"rightCommission";
NSString *const kBaseClassBuyerDividedHouseInfo = @"buyerDivided";




@implementation HouseInfoBean

@synthesize brokerId = _brokerId;
@synthesize livingRooms = _livingRooms;
@synthesize totalFloor = _totalFloor;
@synthesize totalPrice = _totalPrice;
@synthesize advTitle = _advTitle;
@synthesize leftCommission = _leftCommission;
@synthesize communityId = _communityId;
@synthesize exclusiveDelegate = _exclusiveDelegate;
@synthesize tradeType = _tradeType;
@synthesize toward = _toward;
@synthesize advDesc = _advDesc;
@synthesize bedRooms = _bedRooms;
@synthesize houseFloor = _houseFloor;
@synthesize images = _images;
@synthesize buildYear = _buildYear;
@synthesize buildArea = _buildArea;
@synthesize decorationState = _decorationState;
@synthesize sellerDivided = _sellerDivided;
@synthesize houseId = _houseId;
@synthesize purpose = _purpose;
@synthesize createTime = _createTime;
@synthesize rightCommission = _rightCommission;
@synthesize buyerDivided = _buyerDivided;


+ (instancetype)houseInfoBeanWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.brokerId =[NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassBrokerIdForHouseInfo fromDictionary:dict]];
        self.livingRooms = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassLivingRoomsHouseInfo fromDictionary:dict]];
        self.totalFloor = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassTotalFloorHouseInfo fromDictionary:dict]];
        self.totalPrice =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassTotalPriceHouseInfo fromDictionary:dict] ];
        self.advTitle = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassAdvTitleHouseInfo fromDictionary:dict]];
        self.leftCommission =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassLeftCommissionHouseInfo fromDictionary:dict]] ;
        self.communityId =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassCommunityIdHouseInfo fromDictionary:dict] ];
        self.exclusiveDelegate =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassExclusiveDelegateHouseInfo fromDictionary:dict]];
        self.tradeType = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassTradeTypeHouseInfo fromDictionary:dict]] ;
        self.toward = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassTowardHouseInfo fromDictionary:dict]] ;
        self.advDesc =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassAdvDescHouseInfo fromDictionary:dict]];
        self.bedRooms =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassBedRoomsHouseInfo fromDictionary:dict]];
        self.houseFloor = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassHouseFloorHouseInfo fromDictionary:dict]] ;
        
        self.buildYear =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassBuildYearHouseInfo fromDictionary:dict]];
        self.buildArea =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassBuildAreaHouseInfo fromDictionary:dict] ];
        self.decorationState =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassDecorationStateHouseInfo fromDictionary:dict]] ;
        self.sellerDivided = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassSellerDividedHouseInfo fromDictionary:dict] ];
        self.houseId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassHouseIdHouseInfo fromDictionary:dict] ];
        self.purpose = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassPurposeHouseInfo fromDictionary:dict]] ;
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[self objectOrNilForKey:kBaseClassCreateTimeHouseInfo fromDictionary:dict] doubleValue]/1000];
        self.createTime = [TimeUtil timeStrByDataAndFormat:date format:@"yyyy-MM-dd"];
        
        self.rightCommission = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kBaseClassRightCommissionHouseInfo fromDictionary:dict] ];
        self.buyerDivided =[NSString stringWithFormat:@"%@", [self objectOrNilForKey:kBaseClassBuyerDividedHouseInfo fromDictionary:dict] ];
        NSObject *receivedImages = [dict objectForKey:kBaseClassImagesHouseInfo];
        NSMutableArray *parsedImages = [NSMutableArray array];
        if ([receivedImages isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedImages) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedImages addObject:[HouseInfoImageBean modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedImages isKindOfClass:[NSDictionary class]]) {
            [parsedImages addObject:[HouseInfoImageBean modelObjectWithDictionary:(NSDictionary *)receivedImages]];
        }
        self.images = [NSArray arrayWithArray:parsedImages];
    }
    return self;
    
}


@end
