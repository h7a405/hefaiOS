//
//  TaxCalculatorViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "TaxCalculatorViewController.h"
#import "KGStatusBar.h"
#import "NewHouseTaxResultViewController.h"
#import "FullScreenPickerView.h"
#import "SecondHandHouseViewController.h"

#define PriceTypeDatas [NSArray arrayWithObjects:@"按总价计算",@"按差价计算", nil];
#define HouseTypeDatas [NSArray arrayWithObjects:@"普通住宅",@"非普通住宅",@"经济适用房", nil];


//当前点击的按钮 ， 因为选择界面使用的是同一个pickerview，用作区分
typedef NS_ENUM(NSInteger, BtnType){
    Price,
    Property
};

//税率计算器
@interface TaxCalculatorViewController ()<FullScreenPickerViewDelegation>{
    CGPoint _indicatorDefaultCenter ;
    
    NSInteger _currentType;
    
    PriceType _currentPriceType;
    HouseProperty _currentHouseProperty;
    
    BtnType _currentBtn;
}

@property (weak, nonatomic) IBOutlet UILabel *indicator ;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *areaText;

@property (weak, nonatomic) IBOutlet UIView *secendContainer;
@property (weak, nonatomic) IBOutlet UISwitch *thirdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *secendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *firstSwitch;
@property (weak, nonatomic) IBOutlet UIButton *priceTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeBtn;

@property (weak, nonatomic) IBOutlet UITextField *areaTextForSecend;
@property (weak, nonatomic) IBOutlet UITextField *priceTextForSecond;
@property (weak, nonatomic) IBOutlet UITextField *originalPriceTextForSecond;

- (void) scaleView : (UIView *) view;

- (void) initialize ;
- (void) initializeIndicator ;
- (void) moveIndicatorBy : (NSInteger) index ;

- (void) resignFirstResponder;
- (void) showPickerViewBy : (NSArray *) datas index : (NSInteger) index;

- (IBAction)topBtnTapped:(UIButton *)sender ;
- (IBAction)newHouseResultBtnTapped:(UIButton *)sender;
- (IBAction)resultBtnTapped:(UIButton *)sender;
- (IBAction)priceTypeTapped:(UIButton *)sender;
- (IBAction)houseTypeTapped:(UIButton *)sender;

@end

@implementation TaxCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self initializeIndicator];
}

-(void) initialize{
    self.navigationItem.title = @"税率计算器";
    _indicatorDefaultCenter = _indicator.center;
    
    UIBarButtonItem *barItem = [UIBarButtonItem new];
    barItem.title = @"";
    self.navigationItem.backBarButtonItem = barItem;
    
    [self scaleView:_firstSwitch];
    [self scaleView:_secendSwitch];
    [self scaleView:_thirdSwitch];
}

-(void) initializeIndicator{
    //由于使用了autolayout 在位置变化之后如果textfield获得焦点，则指示器会回复到原位
    //所以重新定义一个替换原来的指示器
    UILabel *indicator = [[UILabel alloc] initWithFrame:_indicator.frame];
    indicator.backgroundColor = _indicator.backgroundColor;
    [self.view addSubview:indicator];
    
    [_indicator removeFromSuperview];
    _indicator = indicator;
}

- (IBAction)topBtnTapped:(UIButton *)sender {
    [self moveIndicatorBy:sender.tag];
    
    if(_currentType != sender.tag){
        _currentType = sender.tag;
        _secendContainer.hidden = _currentType == 0;
        [self resignTextFirstResponder];
    }
}

- (void) scaleView : (UIView *) view{
    view.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

- (IBAction)newHouseResultBtnTapped:(UIButton *)sender {
    NSString *priceStr = _priceText.text;
    NSString *areaStr = _areaText.text;
    
    if ([TextUtil isEmpty:priceStr] || [TextUtil isEmpty:areaStr]) {
        [KGStatusBar showErrorWithStatus:@"请分别输入单价和面积"];
        return ;
    }
    
    float price = [priceStr floatValue];
    float area = [areaStr floatValue];
    
    NewHouseTaxResultViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"NewHouseTaxResultViewController"];
    vc.price = price;
    vc.area = area;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)resultBtnTapped:(UIButton *)sender {
    NSString *areaStr = _areaTextForSecend.text;
    NSString *totalStr = _priceTextForSecond.text;
    NSString *originalPriceStr = _originalPriceTextForSecond.text;
    
    if ([TextUtil isEmpty:areaStr] || [TextUtil isEmpty:totalStr] || [TextUtil isEmpty:originalPriceStr]) {
        [KGStatusBar showErrorWithStatus:@"请分别输入面积、总价和原价"];
        return ;
    }
    
    SecondHandHouseViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondHandHouseViewController"];
    vc.area = [areaStr floatValue] ;
    vc.totalPrice = [totalStr floatValue] ;
    vc.originalPrice = [originalPriceStr floatValue] ;
    vc.priceType = _currentPriceType ;
    vc.houseProperty = _currentHouseProperty ;
    vc.isFiveYears = _firstSwitch.on ;
    vc.isFirstHouse = _secendSwitch.on ;
    vc.isOnlyOneHouse = _thirdSwitch.on ;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)priceTypeTapped:(UIButton *)sender {
    _currentBtn = Price;
    
    NSArray *array = PriceTypeDatas;
    [self showPickerViewBy:array index:_currentPriceType];
}

- (IBAction)houseTypeTapped:(UIButton *)sender {
    _currentBtn = Property;
    
    NSArray *array = HouseTypeDatas;
    [self showPickerViewBy:array index:_currentHouseProperty];
}


-(void) resignTextFirstResponder{
    [_areaText resignFirstResponder];
    [_priceText resignFirstResponder];
    [_areaTextForSecend resignFirstResponder];
    [_priceTextForSecond resignFirstResponder];
    [_originalPriceTextForSecond resignFirstResponder];
}

-(void) resignFirstResponder{
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignTextFirstResponder];
}

-(void) moveIndicatorBy : (NSInteger) index{
    int width = _indicator.bounds.size.width + 1;
    
    CGPoint center = CGPointMake(_indicatorDefaultCenter.x + width * index, _indicatorDefaultCenter.y);
    
    [UIView animateWithDuration:0.2 animations:^{
        _indicator.center = center;
    }];
};

-(void) showPickerViewBy:(NSArray *)datas index:(NSInteger)index{
    FullScreenPickerView *pickerView = [[FullScreenPickerView alloc] init];
    pickerView.delegation = self;
    [pickerView showWith:datas index:index];
}

#pragma mark pickerview delegation
-(void) didTappenBy : (FullScreenPickerView *) fullPickerView index : (NSInteger) index{
    [fullPickerView dismiss];
    
    if (_currentBtn == Price) {
        _currentPriceType = index;
        NSArray *array = PriceTypeDatas;
        [_priceTypeBtn setTitle:array[index] forState:UIControlStateNormal];
    }else{
        _currentHouseProperty = index;
        NSArray *array = HouseTypeDatas;
        [_houseTypeBtn setTitle:array[index] forState:UIControlStateNormal];
    }
};

@end
