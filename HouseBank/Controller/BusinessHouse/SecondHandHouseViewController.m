//
//  SecondHandHouseViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SecondHandHouseViewController.h"

@interface SecondHandHouseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deedTaxLabel;//契税

@property (weak, nonatomic) IBOutlet UILabel *businessTaxLabel;//营业税

@property (weak, nonatomic) IBOutlet UILabel *yinhuashuiLabel;//印花税

@property (weak, nonatomic) IBOutlet UILabel *individualIncomeTaxLabel;//个人所得税
@property (weak, nonatomic) IBOutlet UILabel *gbYinhuashuiLabel;//工本印花税
@property (weak, nonatomic) IBOutlet UILabel *landPricesLabel;//综合地价款
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//合计

@end

@implementation SecondHandHouseViewController

@synthesize area = _area;
@synthesize totalPrice = _totalPrice;
@synthesize originalPrice = _originalPrice;
@synthesize priceType = _priceType;
@synthesize houseProperty = _houseProperty;
@synthesize isFiveYears = _isFiveYears;
@synthesize isFirstHouse = _isFirstHouse;
@synthesize isOnlyOneHouse = _isOnlyOneHouse;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float totalTax = 0;
    float tax = 0;
    if (_isFirstHouse && _houseProperty != No_Ordinary) {
        tax = [self taxWith:1.5 / 100.0];
    }else{
        tax = [self taxWith: 3.0 / 100.0];
    }
    
    totalTax += tax;
    _deedTaxLabel.text = [NSString stringWithFormat:@"%.1f 元",tax];
    
    if ((_houseProperty == Ordinary || _houseProperty == No_Ordinary) && !_isFiveYears) {
        tax = 0;
    }else{
        tax = [self taxWith:0.056];
    }
    
    totalTax += tax;
    _businessTaxLabel.text = [NSString stringWithFormat:@"%.1f 元",tax];
    
    tax = [self taxWith:5.0/10000.0];
    totalTax += tax;
    _yinhuashuiLabel.text = [NSString stringWithFormat:@"%.1f 元",tax];
    
    
    if (((_houseProperty == No_Ordinary || _houseProperty == Ordinary) && (_isFiveYears && !_isOnlyOneHouse)) || (_houseProperty == Economic && !_isOnlyOneHouse)) {
        if (_priceType == DiffPrice && _totalPrice > _originalPrice) {
            tax = (-_originalPrice + _totalPrice)*20.0/100.0*10000.0;
        }else{
            tax = [self taxWith:0.01];
        }
    }else{
        tax = 0;
    }
    
    totalTax += tax;
    _individualIncomeTaxLabel.text = [NSString stringWithFormat:@"%.1f 元",tax];
    
    tax = 5;
    _gbYinhuashuiLabel.text = [NSString stringWithFormat:@"%.1f 元",tax];
    _totalPrice += tax;
    
    if (_houseProperty == Economic) {
        tax = [self taxWith:0.1];
    }else{
        tax = 0;
    }
    totalTax += tax;
    _landPricesLabel.text = [NSString stringWithFormat:@"%.1f 元",tax];
    
    _totalLabel.text = [NSString stringWithFormat:@"%.1f 元",totalTax];
}

-(float) taxWith : (float) tax{
    return _totalPrice * tax * 10000.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
