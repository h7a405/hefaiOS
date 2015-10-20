//
//  MortgageCalculatorViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//


#define RateOf1276ForProvidentFund 4.5
#define RateOf1268ForProvidentFund 4.7
#define RateOf1276ForBusiness 6.55
#define RateOf1268ForBusiness 6.8


#import "MortgageCalculatorViewController.h"
#import "FullScreenPickerView.h"
#import "KGStatusBar.h"
#import "TextUtil.h"
#import "LoanResultViewController.h"
#import "LoanResultForBJViewController.h"
#import "AppDelegate.h"

// 房贷计算器
@interface MortgageCalculatorViewController ()<FullScreenPickerViewDelegation,UITextFieldDelegate>{
    CGPoint _indicatorDefaultCenter ;
    MortgageType _currentType ;
    
    NSArray *_repayStrings ;
    NSArray *_ageLimitStrings ;
    NSArray *_rateString ;
    
    UIButton *_currentBtn ;
    
    NSInteger _currentRepayIndex ;
    NSInteger _currentAgeLimitIndex ;
    NSInteger _currentRateIndex ;
    NSInteger _currentAgeLimitIndexForSecend ;
    NSInteger _currentRateIndexForSecend ;
    
    CGPoint _defaultCenter ;
    UIView *_currentEdittingView ;
}

-(void) initialize;
-(void) initializeIndicator;
-(void) initializeTextField;

-(void) moveIndicatorBy : (NSInteger) index;
-(void) resignTextFirstResponder ;

-(NSString *) ageStringBy : (NSInteger) index;

-(void) fixRate : (NSInteger) index ;
-(void) calculateMortgageAndShowNextVc : (float) rate total : (float) total years : (NSInteger) years ;
-(void) enterNextVcOfBX : (int) years total : (float) total totalForRepay : (float) totalForRepay totalForInterest : (float) totalForInterest monthForPay : (float) monthForPay;
-(void) calculateCombinationMortgageAndShowNextVc : (float) rate total : (float) total years : (NSInteger) years rateForBusiness : (float) rateForBusiness totalForBusiness : (float) totalForBusiness yearsForBusiness : (NSInteger) yearsForBusiness;

-(void) keyboardWillShow: (NSNotification *)notify;
-(void) keyboardWillHide: (NSNotification *)notify;

@property (weak, nonatomic) IBOutlet UILabel *indicator;

@property (weak, nonatomic) IBOutlet UIButton *repaymentTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ageLimitBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;

@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UITextField *rateText;
@property (weak, nonatomic) IBOutlet UIView *mortgageContainer;

@property (weak, nonatomic) IBOutlet UIView *mortageSecondContainer;

@property (weak, nonatomic) IBOutlet UITextField *businessTypeText;
@property (weak, nonatomic) IBOutlet UITextField *providentFundTypeText;
@property (weak, nonatomic) IBOutlet UITextField *businessTypeRateText;
@property (weak, nonatomic) IBOutlet UITextField *providentFundRateText;

@property (weak, nonatomic) IBOutlet UIButton *secendAgeLimitBtn;
@property (weak, nonatomic) IBOutlet UIButton *secendRateBtn;


- (IBAction)topBtnTapped:(UIButton *)sender;

- (IBAction)repaymentTypeTapped:(UIButton *)sender;
- (IBAction)ageLimitTapped:(UIButton *)sender;
- (IBAction)rateTapped:(UIButton *)sender;
- (IBAction)calculateTapped:(UIButton *)sender;


@end

@implementation MortgageCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self initializeIndicator];
    [self initializeTextField];
}

-(void) initializeTextField{
    _moneyText.delegate = self;
    _rateText.delegate = self;
    _businessTypeText.delegate = self;
    _providentFundTypeText.delegate = self;
    _businessTypeRateText.delegate = self;
    _providentFundRateText.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) initializeIndicator{
    UILabel *indicator = [[UILabel alloc] initWithFrame:_indicator.frame];
    indicator.backgroundColor = _indicator.backgroundColor;
    [_indicator removeFromSuperview];
    [self.view addSubview:indicator];
    
    _indicator = indicator;
}

-(void) initialize{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    _defaultCenter = self.view.center ;
    
    self.navigationItem.title = @"房贷计算器";
    _indicatorDefaultCenter = _indicator.center;
    _currentType = Business;
    
    _currentAgeLimitIndex = 19;
    _currentRateIndex = 3;
    _currentAgeLimitIndexForSecend = 19;
    _currentRateIndexForSecend = 3;
    
    _repayStrings = [NSArray arrayWithObjects:@"等额本息",@"等额本金", nil];
    _rateString = [NSArray arrayWithObjects:@"12年7月6日利率上限(1.1倍)",@"12年7月6日利率上限(85折)",@"12年7月6日利率上限(7折)",@"12年7月6日基准利率",@"12年6月8日利率上限(1.1倍)",@"12年6月8日利率下限(85折)",@"12年6月8日利率下限(7折)",@"12年6月8日基准利率", nil];
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 30; i++) {
        [array addObject:[self ageStringBy:i+1]];
    }
    
    _ageLimitStrings = array;
}

-(void) moveIndicatorBy : (NSInteger) index{
    int width = _indicator.bounds.size.width + 1 ;
    
    CGPoint center = CGPointMake(_indicatorDefaultCenter.x + width * index, _indicatorDefaultCenter.y) ;
    
    [UIView animateWithDuration:0.2 animations:^{
        _indicator.center = center ;
    }];
};

-(NSString *) ageStringBy : (NSInteger) index{
    return [NSString stringWithFormat:@"%d年（%d期）",index,index*12];
};

- (IBAction)topBtnTapped:(UIButton *)sender {
    if (sender.tag != _currentType) {
        _currentType = sender.tag;
        
        [self moveIndicatorBy:sender.tag];
        
        _mortageSecondContainer.hidden = sender.tag != Combination;
        
        [self resignTextFirstResponder];
    }
}

- (IBAction)repaymentTypeTapped:(UIButton *)sender {
    FullScreenPickerView *pickerView = [FullScreenPickerView new];
    pickerView.delegation = self;
    [pickerView showWith:_repayStrings index:_currentRepayIndex];
    
    _currentBtn = sender;
}

- (IBAction)ageLimitTapped:(UIButton *)sender {
    FullScreenPickerView *pickerView = [FullScreenPickerView new];
    pickerView.delegation = self;
    [pickerView showWith:_ageLimitStrings index:_currentType != Combination ? _currentAgeLimitIndex : _currentAgeLimitIndexForSecend];
    
    _currentBtn = sender;
}

- (IBAction)rateTapped:(UIButton *)sender {
    FullScreenPickerView *pickerView = [FullScreenPickerView new];
    pickerView.delegation = self;
    [pickerView showWith:_rateString index:_currentType != Combination ? _currentRateIndex : _currentRateIndexForSecend];
    
    _currentBtn = sender;
}

- (IBAction)calculateTapped:(UIButton *)sender {
    if(_currentType == Combination){
        NSString *total1 = _businessTypeText.text;
        NSString *total2 = _providentFundTypeText.text;
        if ([TextUtil isEmpty:total1] || [TextUtil isEmpty:total2]) {
            [KGStatusBar showErrorWithStatus:@"请分别输入商业贷款总额和公积金贷款总额"];
        }else {
            float totalFloat1 = [total1 floatValue] * 10000;
            float totalFloat2 = [total2 floatValue] * 10000;
            float rate1 = [_businessTypeRateText.text floatValue] / 100.0f / 12;
            float rate2 = [_providentFundRateText.text floatValue] / 100.0f / 12;
            
            NSInteger years = _currentAgeLimitIndexForSecend + 1;
            
            [self calculateCombinationMortgageAndShowNextVc:rate1 total:totalFloat1 years:years rateForBusiness:rate2 totalForBusiness:totalFloat2 yearsForBusiness:years];
        }
    }else{
        NSString *total = _moneyText.text;
        if ([TextUtil isEmpty:total]) {
            [KGStatusBar showErrorWithStatus:@"请输入贷款金额"];
        }else{
            float totalFloat = [total floatValue] * 10000;
            float rate = [_rateText.text floatValue] / 100.0f / 12;
            NSInteger years = _currentAgeLimitIndex + 1;
            
            [self calculateMortgageAndShowNextVc:rate total:totalFloat years:years];
        }
    }
}

-(void) calculateMortgageAndShowNextVc : (float) rate total : (float) total years : (NSInteger) years{
    if(_currentRepayIndex == 0){
        float monthForPay = total*rate*pow((1 + rate), years*12)/(pow((1 + rate), years*12)-1);
        float totalForRepay = monthForPay * years * 12;
        float totalForInterest = totalForRepay - total;
        
        [self enterNextVcOfBX:years total:total totalForRepay:totalForRepay totalForInterest:totalForInterest monthForPay:monthForPay];
    }else{
        LoanResultForBJViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanResultForBJViewController"];
        vc.type = _currentType;
        
        vc.total1 = total;
        vc.months1 = years*12;
        vc.rate1 = rate;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
};

-(void) enterNextVcOfBX : (int) years total : (float) total totalForRepay : (float) totalForRepay totalForInterest : (float) totalForInterest monthForPay : (float) monthForPay{
    LoanResultViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanResultViewController"];
    vc.totalForLoadStr = [NSString stringWithFormat:@"%.0lf",total/10000];
    vc.totalForRepayStr = [NSString stringWithFormat:@"%.2lf",totalForRepay];
    vc.totalForInterestStr = [NSString stringWithFormat:@"%.2lf",totalForInterest];
    vc.monthStr = [NSString stringWithFormat:@"%d",years*12];
    vc.moneyForMonthRepayStr = [NSString stringWithFormat:@"%.2lf",monthForPay];
    
    if(_currentType == Business){
        vc.title = @"商业" ;
    }else if(_currentType == ProvidentFund){
        vc.title = @"公积金" ;
    }else{
        vc.title = @"组合" ;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
};

-(void) calculateCombinationMortgageAndShowNextVc : (float) rate total : (float) total years : (NSInteger) years rateForBusiness : (float) rateForBusiness totalForBusiness : (float) totalForBusiness yearsForBusiness : (NSInteger) yearsForBusiness{
    if(_currentRepayIndex == 0){
        float monthForPay = total*rate*pow((1 + rate), years*12)/(pow((1 + rate), years*12)-1);
        float totalForRepay = monthForPay * years * 12;
        float totalForInterest = totalForRepay - total;
        
        float monthForPay1 = totalForBusiness*rateForBusiness*pow((1 + rateForBusiness), yearsForBusiness*12)/(pow((1 + rateForBusiness), yearsForBusiness*12)-1);
        float totalForRepay1 = monthForPay1 * yearsForBusiness * 12;
        float totalForInterest1 = totalForRepay1 - totalForBusiness;
        
        [self enterNextVcOfBX:years total:total+totalForBusiness totalForRepay:totalForRepay+totalForRepay1 totalForInterest:totalForInterest+totalForInterest1 monthForPay:monthForPay + monthForPay1];
    }else{
        LoanResultForBJViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanResultForBJViewController"];
        vc.type = _currentType;
        
        vc.total1 = total ;
        vc.months1 = years*12 ;
        vc.rate1 = rate ;
        
        vc.total2 = totalForBusiness ;
        vc.months2 = years * 12 ;
        vc.rate2 = rateForBusiness  ;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
};

-(void) fixRate : (NSInteger) index{
    float base = 1.0;
    if (index%4 == 0 ) {
        base = 1.1;
    }else if(index%4 == 1){
        base = 0.85;
    }else if(index%4 == 2){
        base = 0.7;
    }
    
    float rate = 0;
    float rateOfBusiness = 0;
    
    if (_currentType == Business) {
        if (index >= 4) {
            rate = RateOf1268ForBusiness;
        }else{
            rate = RateOf1276ForBusiness;
        }
        
        _rateText.text = [NSString stringWithFormat:@"%.2lf",base * rate];
    }else if(_currentType == ProvidentFund){
        if (index >= 4) {
            rate = RateOf1268ForProvidentFund;
        }else{
            rate = RateOf1276ForProvidentFund;
        }
        
        _rateText.text = [NSString stringWithFormat:@"%.2lf",rate];
    }else{
        if (index >= 4) {
            rate = RateOf1268ForProvidentFund;
            rateOfBusiness = RateOf1268ForBusiness;
        }else{
            rate = RateOf1276ForProvidentFund;
            rateOfBusiness = RateOf1276ForBusiness;
        }
        
        _providentFundRateText.text = [NSString stringWithFormat:@"%.2lf",rate];
        _businessTypeRateText.text = [NSString stringWithFormat:@"%.2lf",base * rateOfBusiness];
    }
};

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignTextFirstResponder];
}

-(void) resignTextFirstResponder{
    [_moneyText resignFirstResponder] ;
    [_rateText resignFirstResponder] ;
    [_businessTypeText resignFirstResponder] ;
    [_businessTypeRateText resignFirstResponder] ;
    [_providentFundTypeText resignFirstResponder] ;
    [_providentFundRateText resignFirstResponder] ;
}

-(void) keyboardWillShow: (NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect rect = [_currentEdittingView convertRect:_currentEdittingView.bounds toView:[AppDelegate shareApp].window];
    
    float bottom = rect.size.height + rect.origin.y + 10 ;
    
    if (bottom > keyboardRect.origin.y) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.center = CGPointMake(_defaultCenter.x, _defaultCenter.y - (bottom - keyboardRect.origin.y));
        }];
    }
};

-(void) keyboardWillHide: (NSNotification *)notification{
    self.view.center = _defaultCenter;
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark
-(void) didTappenBy : (FullScreenPickerView *) fullPickerView index : (NSInteger) index{
    [fullPickerView dismiss];
    NSArray *array = nil;
    
    if (_currentBtn == _repaymentTypeBtn) {
        _currentRepayIndex = index;
        array = _repayStrings;
    }else if(_currentBtn == _ageLimitBtn || _currentBtn == _secendAgeLimitBtn){
        array = _ageLimitStrings;
        if (_currentBtn == _ageLimitBtn ) {
            _currentAgeLimitIndex = index;
        }else{
            _currentAgeLimitIndexForSecend = index;
        }
        
        [self fixRate:index];
    }else{
        array = _rateString;
        if (_currentBtn == _rateBtn) {
            _currentRateIndex = index;
        }else{
            _currentRateIndexForSecend = index;
        }
        
        [self fixRate:index];
    }
    
    [_currentBtn setTitle:array[index] forState:UIControlStateNormal];
};

#pragma mark textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
};

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _moneyText || textField == _businessTypeText || textField == _providentFundTypeText) {
        if (![TextUtil isPureInt:string] && ![TextUtil isEmpty:string]) {
            return NO;
        }
    }else{
        NSRange foundObj=[textField.text rangeOfString: @"." options:NSCaseInsensitiveSearch];
        
        if (foundObj.length == 0 && [string isEqualToString:@"."]) {
            return YES;
        }
        
        if (![TextUtil isPureInt:string] && ![TextUtil isEmpty:string]) {
            return NO;
        }
    }
    return YES;
};

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _currentEdittingView = textField;
    return YES;
};

@end
