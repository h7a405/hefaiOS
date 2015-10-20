//
//  NewHouseTaxResultViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "NewHouseTaxResultViewController.h"

@interface NewHouseTaxResultViewController (){
    float _price ;
    float _area ;
}

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//房款总价

@property (weak, nonatomic) IBOutlet UILabel *yinhuashuiLabel;//印花税
@property (weak, nonatomic) IBOutlet UILabel *notarialFeesLabel;//公正费
@property (weak, nonatomic) IBOutlet UILabel *deedTaxLabel;//契税
@property (weak, nonatomic) IBOutlet UILabel *handleFeeLabel;//办理手续费
@property (weak, nonatomic) IBOutlet UILabel *closingCostsLabel;//买卖手续费


-(void) initialize ;

@end

@implementation NewHouseTaxResultViewController

@synthesize price = _price;
@synthesize area = _area;

- (void)viewDidLoad {
    [super viewDidLoad];
    @autoreleasepool {
        [self initialize];
    }
}

-(void) initialize {
    _totalLabel.text = [NSString stringWithFormat:@"%.1f 元",_price * _area];
    _yinhuashuiLabel.text = [NSString stringWithFormat:@"%.1f 元",roundf(_price*_area)*5.0/10000.0];
    _notarialFeesLabel.text = [NSString stringWithFormat:@"%.1f 元",roundf(_price*_area)*3.0/1000.0];
    _deedTaxLabel.text = [NSString stringWithFormat:@"%.1f 元",roundf(_price*_area)*3.0/100.0];
    _closingCostsLabel.text = @"500 元";
    _handleFeeLabel.text = [NSString stringWithFormat:@"%.1f 元",roundf(_price*_area)*3.0/1000.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
