//
//  LoanResultViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/25.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "LoanResultViewController.h"

@interface LoanResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalForLoad;

@property (weak, nonatomic) IBOutlet UILabel *totalForRepay;

@property (weak, nonatomic) IBOutlet UILabel *totalForInterest;

@property (weak, nonatomic) IBOutlet UILabel *months;

@property (weak, nonatomic) IBOutlet UILabel *moneyForMonthRepay;


@end

@implementation LoanResultViewController

@synthesize totalForLoadStr ;
@synthesize totalForRepayStr ;
@synthesize totalForInterestStr ;
@synthesize monthStr ;
@synthesize moneyForMonthRepayStr ;
@synthesize title ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _totalForLoad.text = [NSString stringWithFormat:@"%@ 万元",totalForLoadStr];
    _totalForRepay.text = [NSString stringWithFormat:@"%@ 元",totalForRepayStr];
    _totalForInterest.text = [NSString stringWithFormat:@"%@ 元",totalForInterestStr];
    _months.text = [NSString stringWithFormat:@"%@（月）",monthStr];
    _moneyForMonthRepay.text = [NSString stringWithFormat:@"%@ 元",moneyForMonthRepayStr];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@贷款计算结果",title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
