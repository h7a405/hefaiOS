//
//  LoanResultForBJViewController.h
//  HouseBank
//
//  Created by CSC on 14/12/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"
#import "MortgageCalculatorViewController.h"

@interface LoanResultForBJViewController : BaseViewController

@property (assign) MortgageType type ;

@property (assign) float total1 ;
@property (assign) int months1 ;
@property (assign) float rate1 ;

@property (assign) float total2 ;
@property (assign) int months2 ;
@property (assign) float rate2 ;

@end
