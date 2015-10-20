//
//  BaseClass.m
//
//  Created by   on 14-9-28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "XSCooperationBean.h"
#import "NSObject+Json.h"

NSString *const kBaseClassAcceptMessage = @"acceptMessage";
NSString *const kBaseClassBrokerHeaderImg = @"brokerHeaderImg";
NSString *const kBaseClassLookHouse = @"lookHouse";
NSString *const kBaseClassStatus = @"status";
NSString *const kBaseClassBuyerPayment = @"buyerPayment";
NSString *const kBaseClassExclusiveDelegate = @"exclusiveDelegate";
NSString *const kBaseClassSellerPayment = @"sellerPayment";
NSString *const kBaseClassStoreName = @"storeName";
NSString *const kBaseClassMobilephone = @"mobilephone";
NSString *const kBaseClassApplyUserId = @"applyUserId";
NSString *const kBaseClassIsFlagMy = @"isFlagMy";
NSString *const kBaseClassStoreNameOne = @"storeNameOne";
NSString *const kBaseClassBrokerInfoTow = @"brokerInfoTow";
NSString *const kBaseClassHouseInfo = @"houseInfo";
NSString *const kBaseClassCooperationId = @"cooperationId";
NSString *const kBaseClassName = @"name";
NSString *const kBaseClassCommentCounts = @"commentCounts";
NSString *const kBaseClassHouseId = @"houseId";
NSString *const kBaseClassSuperId = @"superId";
NSString *const kBaseClassShowTime = @"showTime";
NSString *const kBaseClassApplyTime = @"applyTime";
NSString *const kBaseClassAcceptComission = @"acceptComission";
NSString *const kBaseClassRecommend = @"recommend";
NSString *const kBaseClassApplyCommission = @"applyCommission";
NSString *const kBaseClassAcceptTime = @"acceptTime";
NSString *const kBaseClassBrokerInfo = @"brokerInfo";
NSString *const kBaseClassStoreNameTow = @"storeNameTow";
NSString *const kBaseClassHasImage = @"hasImage";
NSString *const kBaseClassApplyMessage = @"applyMessage";
NSString *const kBaseClassAcceptUserId = @"acceptUserId";



@implementation XSCooperationBean

@synthesize acceptMessage = _acceptMessage;
@synthesize brokerHeaderImg = _brokerHeaderImg;
@synthesize lookHouse = _lookHouse;
@synthesize status = _status;
@synthesize buyerPayment = _buyerPayment;
@synthesize exclusiveDelegate = _exclusiveDelegate;
@synthesize sellerPayment = _sellerPayment;
@synthesize storeName = _storeName;
@synthesize mobilephone = _mobilephone;
@synthesize applyUserId = _applyUserId;
@synthesize isFlagMy = _isFlagMy;
@synthesize storeNameOne = _storeNameOne;
@synthesize brokerInfoTow = _brokerInfoTow;
@synthesize houseInfo = _houseInfo;
@synthesize cooperationId = _cooperationId;
@synthesize name = _name;
@synthesize commentCounts = _commentCounts;
@synthesize houseId = _houseId;
@synthesize superId = _superId;
@synthesize showTime = _showTime;
@synthesize applyTime = _applyTime;
@synthesize acceptComission = _acceptComission;
@synthesize recommend = _recommend;
@synthesize applyCommission = _applyCommission;
@synthesize acceptTime = _acceptTime;
@synthesize brokerInfo = _brokerInfo;
@synthesize storeNameTow = _storeNameTow;
@synthesize hasImage = _hasImage;
@synthesize applyMessage = _applyMessage;
@synthesize acceptUserId = _acceptUserId;


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
            self.acceptMessage = [self objectOrNilForKey:kBaseClassAcceptMessage fromDictionary:dict];
            self.brokerHeaderImg =[Tool imageUrlWithPath: [self objectOrNilForKey:kBaseClassBrokerHeaderImg fromDictionary:dict] andTypeString:@"D03"];
            self.lookHouse = [self objectOrNilForKey:kBaseClassLookHouse fromDictionary:dict] ;
            self.status = [self objectOrNilForKey:kBaseClassStatus fromDictionary:dict] ;
            self.buyerPayment = [self objectOrNilForKey:kBaseClassBuyerPayment fromDictionary:dict] ;
            self.exclusiveDelegate = [self objectOrNilForKey:kBaseClassExclusiveDelegate fromDictionary:dict] ;
            self.sellerPayment = [self objectOrNilForKey:kBaseClassSellerPayment fromDictionary:dict] ;
            self.storeName = [self objectOrNilForKey:kBaseClassStoreName fromDictionary:dict];
            self.mobilephone = [self objectOrNilForKey:kBaseClassMobilephone fromDictionary:dict];
            self.applyUserId = [self objectOrNilForKey:kBaseClassApplyUserId fromDictionary:dict] ;
            self.isFlagMy = [self objectOrNilForKey:kBaseClassIsFlagMy fromDictionary:dict] ;
            self.storeNameOne = [self objectOrNilForKey:kBaseClassStoreNameOne fromDictionary:dict];
            self.brokerInfoTow = [self objectOrNilForKey:kBaseClassBrokerInfoTow fromDictionary:dict];
            self.houseInfo = [self objectOrNilForKey:kBaseClassHouseInfo fromDictionary:dict];
            self.cooperationId = [self objectOrNilForKey:kBaseClassCooperationId fromDictionary:dict] ;
            self.name = [self objectOrNilForKey:kBaseClassName fromDictionary:dict];
            self.commentCounts = [self objectOrNilForKey:kBaseClassCommentCounts fromDictionary:dict] ;
            self.houseId = [self objectOrNilForKey:kBaseClassHouseId fromDictionary:dict] ;
            self.superId = [self objectOrNilForKey:kBaseClassSuperId fromDictionary:dict] ;
            self.showTime = [self objectOrNilForKey:kBaseClassShowTime fromDictionary:dict];
            self.applyTime = [self objectOrNilForKey:kBaseClassApplyTime fromDictionary:dict] ;
            self.acceptComission = [self objectOrNilForKey:kBaseClassAcceptComission fromDictionary:dict] ;
            self.recommend = [self objectOrNilForKey:kBaseClassRecommend fromDictionary:dict];
            self.applyCommission = [self objectOrNilForKey:kBaseClassApplyCommission fromDictionary:dict] ;
            self.acceptTime = [self objectOrNilForKey:kBaseClassAcceptTime fromDictionary:dict] ;
            self.brokerInfo = [self objectOrNilForKey:kBaseClassBrokerInfo fromDictionary:dict];
            self.storeNameTow = [self objectOrNilForKey:kBaseClassStoreNameTow fromDictionary:dict];
            self.hasImage = [self objectOrNilForKey:kBaseClassHasImage fromDictionary:dict] ;
            self.applyMessage = [self objectOrNilForKey:kBaseClassApplyMessage fromDictionary:dict];
            self.acceptUserId = [self objectOrNilForKey:kBaseClassAcceptUserId fromDictionary:dict] ;

    }
    
    return self;
    
}



@end
