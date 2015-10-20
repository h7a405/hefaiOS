//
//  TaxCalculatorViewController.h
//  HouseBank
//
//  Created by CSC on 14/12/24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, PriceType){
    TotalPrice  =  0, //总价计算
    DiffPrice = 1//差价计算
};

typedef NS_ENUM(NSInteger, HouseProperty){
    Ordinary = 0, //普通住宅
    No_Ordinary = 1, //非普通住宅
    Economic = 2//经济适用房
};

@interface TaxCalculatorViewController : BaseViewController

@end
