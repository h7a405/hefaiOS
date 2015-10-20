//
//  SecondHandHouseViewController.h
//  HouseBank
//
//  Created by CSC on 14/12/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"
#import "TaxCalculatorViewController.h"

//二手房税费结果
@interface SecondHandHouseViewController : BaseViewController

@property (assign,nonatomic) float area ;
@property (assign,nonatomic) float totalPrice ;
@property (assign,nonatomic) float originalPrice ;
@property (assign,nonatomic) PriceType priceType ;
@property (assign,nonatomic) HouseProperty houseProperty ;
@property (assign,nonatomic) BOOL isFiveYears ;
@property (assign,nonatomic) BOOL isFirstHouse ;
@property (assign,nonatomic) BOOL isOnlyOneHouse ;

@end
