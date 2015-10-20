//
//  LoanResultViewController.h
//  HouseBank
//
//  Created by CSC on 14/12/25.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"

@interface LoanResultViewController : BaseViewController

@property (copy,atomic) NSString *totalForLoadStr ;
@property (copy,atomic) NSString *totalForRepayStr ;
@property (copy,atomic) NSString *totalForInterestStr ;
@property (copy,atomic) NSString *monthStr ;
@property (copy,atomic) NSString *moneyForMonthRepayStr ;
@property (copy,atomic) NSString *title;

@end
