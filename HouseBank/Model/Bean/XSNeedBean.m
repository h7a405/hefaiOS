//
//  BaseClass.m
//
//  Created by   on 14-10-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "XSNeedBean.h"
#import "NSObject+Json.h"

NSString *const KNeedModelBedRoom = @"bedRoom";
NSString *const KNeedModelHouseFloorTo = @"houseFloorTo";
NSString *const KNeedModelFacilities = @"facilities";
NSString *const KNeedModelBlockIdMap = @"blockIdMap";
NSString *const KNeedModelPaymentType = @"paymentType";
NSString *const KNeedModelTradeType = @"tradeType";
NSString *const KNeedModelAreaFrom = @"areaFrom";
NSString *const KNeedModelBlockNameMap = @"blockNameMap";
NSString *const KNeedModelPriceFrom = @"priceFrom";
NSString *const KNeedModelHouseFloorFrom = @"houseFloorFrom";
NSString *const KNeedModelPriceTo = @"priceTo";
NSString *const KNeedModelMemo = @"memo";
NSString *const KNeedModelCommunityidMap = @"communityidMap";
NSString *const KNeedModelHouseType = @"houseType";
NSString *const KNeedModelDecorationState = @"decorationState";
NSString *const KNeedModelCustomerMobilephone = @"customerMobilephone";
NSString *const KNeedModelPurpose = @"purpose";
NSString *const KNeedModelTargetFormat = @"targetFormat";
NSString *const KNeedModelReqId = @"reqId";
NSString *const KNeedModelCommunityNameMap = @"communityNameMap";
NSString *const KNeedModelAreaTo = @"areaTo";
NSString *const KNeedModelCreateTime = @"createTime";
NSString *const KNeedModelCreateUserId = @"createUserId";
NSString *const KNeedModelToward = @"toward";
NSString *const KNeedModelCustomerName = @"customerName";




@implementation XSNeedBean

@synthesize bedRoom = _bedRoom;
@synthesize houseFloorTo = _houseFloorTo;
@synthesize facilities = _facilities;
@synthesize blockIdMap = _blockIdMap;
@synthesize paymentType = _paymentType;
@synthesize tradeType = _tradeType;
@synthesize areaFrom = _areaFrom;
@synthesize blockNameMap = _blockNameMap;
@synthesize priceFrom = _priceFrom;
@synthesize houseFloorFrom = _houseFloorFrom;
@synthesize priceTo = _priceTo;
@synthesize memo = _memo;
@synthesize communityidMap = _communityidMap;
@synthesize houseType = _houseType;
@synthesize decorationState = _decorationState;
@synthesize customerMobilephone = _customerMobilephone;
@synthesize purpose = _purpose;
@synthesize targetFormat = _targetFormat;
@synthesize reqId = _reqId;
@synthesize communityNameMap = _communityNameMap;
@synthesize areaTo = _areaTo;
@synthesize createTime = _createTime;
@synthesize createUserId = _createUserId;
@synthesize toward = _toward;
@synthesize customerName = _customerName;


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
        self.bedRoom = [self objectOrNilForKey:KNeedModelBedRoom fromDictionary:dict] ;
        self.houseFloorTo = [self objectOrNilForKey:KNeedModelHouseFloorTo fromDictionary:dict] ;
        self.facilities = [self objectOrNilForKey:KNeedModelFacilities fromDictionary:dict] ;
        
        self.paymentType = [self objectOrNilForKey:KNeedModelPaymentType fromDictionary:dict] ;
        self.tradeType = [self objectOrNilForKey:KNeedModelTradeType fromDictionary:dict] ;
        self.areaFrom = [self objectOrNilForKey:KNeedModelAreaFrom fromDictionary:dict] ;
        
        self.priceFrom = [self objectOrNilForKey:KNeedModelPriceFrom fromDictionary:dict] ;
        self.houseFloorFrom = [self objectOrNilForKey:KNeedModelHouseFloorFrom fromDictionary:dict] ;
        self.priceTo = [self objectOrNilForKey:KNeedModelPriceTo fromDictionary:dict] ;
        self.memo = [self objectOrNilForKey:KNeedModelMemo fromDictionary:dict];
        
        self.houseType = [self objectOrNilForKey:KNeedModelHouseType fromDictionary:dict] ;
        self.decorationState = [self objectOrNilForKey:KNeedModelDecorationState fromDictionary:dict] ;
        self.customerMobilephone = [self objectOrNilForKey:KNeedModelCustomerMobilephone fromDictionary:dict];
        self.purpose = [self objectOrNilForKey:KNeedModelPurpose fromDictionary:dict] ;
        self.targetFormat = [self objectOrNilForKey:KNeedModelTargetFormat fromDictionary:dict] ;
        self.reqId = [self objectOrNilForKey:KNeedModelReqId fromDictionary:dict] ;
        
        self.areaTo = [self objectOrNilForKey:KNeedModelAreaTo fromDictionary:dict] ;
        self.createTime = [self objectOrNilForKey:KNeedModelCreateTime fromDictionary:dict] ;
        self.createUserId = [self objectOrNilForKey:KNeedModelCreateUserId fromDictionary:dict] ;
        self.toward = [self objectOrNilForKey:KNeedModelToward fromDictionary:dict] ;
        self.customerName = [self objectOrNilForKey:KNeedModelCustomerName fromDictionary:dict];
        
        
        NSDictionary *tmpMap=[self objectOrNilForKey:KNeedModelCommunityNameMap fromDictionary:dict];
        if (![tmpMap isKindOfClass:[NSNull class]]) {
            NSMutableString *string=[NSMutableString string];
            [tmpMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (![obj isEqualToString:@""]) {
                     [string appendString:[NSString stringWithFormat:@"%@,",obj]];
                }
            }];
            if (string.length>0) {
                string= [NSMutableString stringWithString:[string substringToIndex:string.length-1]];
            }
            self.communityNameMap=string;
        }
        NSDictionary *tmpMap1=[self objectOrNilForKey:KNeedModelCommunityidMap fromDictionary:dict];
        if (![tmpMap1 isKindOfClass:[NSNull class]]) {
            NSMutableString *string=[NSMutableString string];
            [tmpMap1 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj integerValue]!=0) {
                    [string appendString:[NSString stringWithFormat:@"%@,",obj]];
                }
            }];
            if (string.length>0) {
                string= [NSMutableString stringWithString:[string substringToIndex:string.length-1]];
            }
            self.communityidMap=string;
        }
        NSDictionary *tmpMap2=[self objectOrNilForKey:KNeedModelBlockNameMap fromDictionary:dict];
        if (![tmpMap2 isKindOfClass:[NSNull class]]) {
            NSMutableString *string=[NSMutableString string];
            [tmpMap2 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (![obj isEqualToString:@""]) {
                    [string appendString:[NSString stringWithFormat:@"%@,",obj]];
                }
            }];
            if (string.length>0) {
                string= [NSMutableString stringWithString:[string substringToIndex:string.length-1]];
            }
            self.blockNameMap=string;
        }
        
        NSDictionary *tmpMap3=[self objectOrNilForKey:KNeedModelBlockNameMap fromDictionary:dict];
        if (![tmpMap3 isKindOfClass:[NSNull class]]) {
            NSMutableString *string=[NSMutableString string];
            [tmpMap3 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj integerValue]!=0) {
                    [string appendString:[NSString stringWithFormat:@"%@,",obj]];
                }
            }];
            if (string.length>0) {
                string= [NSMutableString stringWithString:[string substringToIndex:string.length-1]];
            }
            
            self.blockIdMap=string;
        }
        
    }

    return self;
    
}




@end
