//
//  BaseClass.m
//
//  Created by   on 14-9-23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "NewHouseInfoBean.h"
#import "NSObject+Json.h"

NSString *const kBaseClassProjectNameForNewHouseInfoModel = @"projectName";
NSString *const kBaseClassPropertyYearForNewHouseInfoModel = @"propertyYear";
NSString *const kBaseClassHotPointForNewHouseInfoModel = @"hotPoint";
NSString *const kBaseClassDeliverDateForNewHouseInfoModel = @"deliverDate";
NSString *const kBaseClassPropertyTypeForNewHouseInfoModel = @"propertyType";
NSString *const kBaseClassCommunityIdForNewHouseInfoModel = @"communityId";
NSString *const kBaseClassAveragePriceForNewHouseInfoModel = @"averagePrice";
NSString *const kBaseClassCommissionRateForNewHouseInfoModel = @"commissionRate";
NSString *const kBaseClassOpenDateForNewHouseInfoModel = @"openDate";
NSString *const kBaseClassGreeningRateForNewHouseInfoModel = @"greeningRate";
NSString *const kBaseClassBrokerLinkmanForNewHouseInfoModel = @"brokerLinkman";
NSString *const kBaseClassProjectIdForNewHouseInfoModel = @"projectId";
NSString *const kBaseClassVolumeRateForNewHouseInfoModel = @"volumeRate";
NSString *const kBaseClassDecorationForNewHouseInfoModel = @"decoration";
NSString *const kBaseClassDeveloperForNewHouseInfoModel = @"developer";
NSString *const kBaseClassManageFeeForNewHouseInfoModel = @"manageFee";
NSString *const kBaseClassBrokerPhoneForNewHouseInfoModel = @"brokerPhone";
NSString *const kBaseClassPaymentForNewHouseInfoModel = @"payment";
NSString *const kBaseClassCustomerDiscountForNewHouseInfoModel = @"customerDiscount";


@implementation NewHouseInfoBean

@synthesize projectName = _projectName;
@synthesize propertyYear = _propertyYear;
@synthesize hotPoint = _hotPoint;
@synthesize deliverDate = _deliverDate;
@synthesize propertyType = _propertyType;
@synthesize communityId = _communityId;
@synthesize averagePrice = _averagePrice;
@synthesize commissionRate = _commissionRate;
@synthesize openDate = _openDate;
@synthesize greeningRate = _greeningRate;
@synthesize brokerLinkman = _brokerLinkman;
@synthesize projectId = _projectId;
@synthesize volumeRate = _volumeRate;
@synthesize decoration = _decoration;
@synthesize developer = _developer;
@synthesize manageFee = _manageFee;
@synthesize brokerPhone = _brokerPhone;
@synthesize payment = _payment;
@synthesize customerDiscount = _customerDiscount;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.projectName = [self objectOrNilForKey:kBaseClassProjectNameForNewHouseInfoModel fromDictionary:dict];
        self.propertyYear = [self objectOrNilForKey:kBaseClassPropertyYearForNewHouseInfoModel fromDictionary:dict];
        self.hotPoint = [self objectOrNilForKey:kBaseClassHotPointForNewHouseInfoModel fromDictionary:dict];
        self.deliverDate = [TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[[self objectOrNilForKey:kBaseClassDeliverDateForNewHouseInfoModel fromDictionary:dict] doubleValue]/1000] format:@"yyyy-MM-dd"];
        self.propertyType = [self objectOrNilForKey:kBaseClassPropertyTypeForNewHouseInfoModel fromDictionary:dict];
        self.communityId = [self objectOrNilForKey:kBaseClassCommunityIdForNewHouseInfoModel fromDictionary:dict];
        self.averagePrice = [self objectOrNilForKey:kBaseClassAveragePriceForNewHouseInfoModel fromDictionary:dict];
        self.commissionRate = [self objectOrNilForKey:kBaseClassCommissionRateForNewHouseInfoModel fromDictionary:dict];
        self.openDate = [TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[[self objectOrNilForKey:kBaseClassOpenDateForNewHouseInfoModel fromDictionary:dict] doubleValue]/1000]  format:@"yyyy-MM-dd"];
        self.greeningRate = [self objectOrNilForKey:kBaseClassGreeningRateForNewHouseInfoModel fromDictionary:dict];
        self.brokerLinkman =[self objectOrNilForKey:kBaseClassBrokerLinkmanForNewHouseInfoModel fromDictionary:dict];
        self.projectId = [self objectOrNilForKey:kBaseClassProjectIdForNewHouseInfoModel fromDictionary:dict];
        self.volumeRate = [self objectOrNilForKey:kBaseClassVolumeRateForNewHouseInfoModel fromDictionary:dict];
        self.decoration = [self objectOrNilForKey:kBaseClassDecorationForNewHouseInfoModel fromDictionary:dict];
        self.developer = [self objectOrNilForKey:kBaseClassDeveloperForNewHouseInfoModel fromDictionary:dict];
        self.manageFee = [self objectOrNilForKey:kBaseClassManageFeeForNewHouseInfoModel fromDictionary:dict];
        self.brokerPhone = [self objectOrNilForKey:kBaseClassBrokerPhoneForNewHouseInfoModel fromDictionary:dict];
        self.payment = [self objectOrNilForKey:kBaseClassPaymentForNewHouseInfoModel fromDictionary:dict];
        self.customerDiscount = [self objectOrNilForKey:kBaseClassCustomerDiscountForNewHouseInfoModel fromDictionary:dict];
        
    }
    
    return self;
    
}



@end
