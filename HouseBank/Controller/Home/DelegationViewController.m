//
//  DelegationViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "DelegationViewController.h"
#import "ViewUtil.h"
#import "AddressChooseView.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "WaitingView.h"
#import "BusinessWsImpl.h"
#import "UIPlaceHolderTextView.h"

@interface DelegationViewController ()<AddressDelegation,UITextFieldDelegate,UITextViewDelegate>{
    __weak UIView *_currentText;
    CGPoint _defaultCenter ;
    
    NSString *_cityName;
    NSString *_cityId;
    NSString *_regionName;
    NSString *_regionId;
    NSString *_blockName;
    NSString *_blockId;
    
    BOOL _isCityChoose;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *editText;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIButton *rent;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UITextField *phone1Text;
@property (weak, nonatomic) IBOutlet UITextField *phone2Text;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)cityBtnTapped:(id)sender;
- (IBAction)submitBtnTapped:(id)sender;

- (IBAction)sellBtnTapped:(id)sender;
- (IBAction)rentBtnTapped:(id)sender;
- (IBAction)shopBtnTapped:(id)sender;
- (IBAction)houseBtnTapped:(id)sender;
- (IBAction)manBtnTapped:(id)sender;
- (IBAction)womenBtnTapped:(id)sender;

-(void) initialize ;
-(void) resignTextFirstResponder;
-(void) setBtnImage : (UIButton *) btn ;

-(void) keyboardWillShow: (NSNotification *)notify;
-(void) keyboardWillHide: (NSNotification *)notify;

@end

@implementation DelegationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
}

-(void) resignTextFirstResponder{
    [_currentText resignFirstResponder];
}

-(void) setBtnImage:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"choose_btn"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"choose_btn_check"] forState:UIControlStateSelected];
}

- (IBAction)cityBtnTapped:(id)sender {
    [self resignTextFirstResponder];
    
    AddressChooseView *addressView = [[AddressChooseView alloc] initWithFrame:self.view.bounds];
    addressView.delegation = self;
    [addressView show];
}

- (IBAction)submitBtnTapped:(id)sender {
    NSString *name = _nameText.text;
    NSString *age = _ageText.text;
    NSString *phone1 = _phone1Text.text;
    NSString *phone2 = _phone2Text.text;
    NSString *msg = _editText.text;
    
    NSString *sex = _manBtn.isSelected ? @"1":@"2";
    NSString *tradetype = _sellBtn.isSelected ? @"1":@"2";
    NSString *purpose = _shopBtn.isSelected ? @"1":@"2";
    
    if ([TextUtil isEmpty:name] || [TextUtil isEmpty:phone1]) {
        [MBProgressHUD showError:@"信息不全，必填项都必须填上！" toView:self.view];
    }else if (!_isCityChoose){
        [MBProgressHUD showError:@"还没有选择区域哦！！" toView:self.view];
    }else{
        WaitingView *waittingView = [WaitingView defaultView];
        [waittingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在提交数据..."];
        
        BusinessWsImpl *ws = [BusinessWsImpl new];
        [ws submitUserDelegation:tradetype purpose:purpose consignorName:name consignorAge:age consignorGender:sex linkPhone1:phone1 linkPhone2:phone2 remark:msg cityId:_cityId regionId:_regionId blockId:_blockId result:^(BOOL isSuccess, id result, NSString *data) {
            [waittingView dismissWatingView];
            if ([@"0" isEqualToString:data]) {
                [MBProgressHUD showMessag:@"提交成功" toView:[AppDelegate shareApp].window];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showNetErrorToView:self.view];
            }
        }];
    }
}

- (IBAction)sellBtnTapped:(id)sender {
    _rent.selected = NO;
    _sellBtn.selected = YES;
}

- (IBAction)rentBtnTapped:(id)sender {
    _rent.selected = YES;
    _sellBtn.selected = NO;
}

- (IBAction)shopBtnTapped:(id)sender {
    _shopBtn.selected = YES;
    _houseBtn.selected = NO;
}

- (IBAction)houseBtnTapped:(id)sender {
    _shopBtn.selected = NO;
    _houseBtn.selected = YES;
}

- (IBAction)manBtnTapped:(id)sender {
    _manBtn.selected = YES;
    _womanBtn.selected = NO;
}

- (IBAction)womenBtnTapped:(id)sender {
    _manBtn.selected = NO;
    _womanBtn.selected = YES;
}

-(void) initialize{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.title = @"我要委托";
    
    [_editText setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"edit_back"]]];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 20);
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    
    _defaultCenter = self.view.center;
    
    [self setBtnImage:_sellBtn];
    [self setBtnImage:_rent];
    [self setBtnImage:_shopBtn];
    [self setBtnImage:_houseBtn];
    [self setBtnImage:_manBtn];
    [self setBtnImage:_womanBtn];
    
    _nameText.delegate = self;
    _ageText.delegate = self;
    _phone1Text.delegate = self;
    _phone2Text.delegate = self;
    
    _editText.delegate = self;
    
    _sellBtn.selected = YES;
    _shopBtn.selected = YES;
    _manBtn.selected = YES;
    
    _editText.placeholder = @"例如：产权情况，居住环境，周边配套，交通情况。";
}

-(void) keyboardWillShow: (NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    if (keyboardRect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        return;
    }
    
    float offset = 10;
    if(_currentText == _editText ){
        offset = 45;
        [_scrollView scrollRectToVisible:rect(0, _scrollView.contentSize.height - _scrollView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    }
    CGRect rect = [_currentText convertRect:_currentText.bounds toView:[AppDelegate shareApp].window];
    float bottom = rect.size.height + rect.origin.y + offset ;
    
    if (bottom > keyboardRect.origin.y && keyboardRect.origin.y > 0) {
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

#pragma mark textfield delegation
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentText = textField ;
};

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
};

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView != _editText) {
        [self resignTextFirstResponder];
    }
};

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _currentText = textView ;
};

#pragma mark address delegation
-(void) didChoose : (AddressChooseView *) addressView cityId : (NSString *) cityId cityName : (NSString *) cityName regionId : (NSString *)regionId regionName : (NSString *) regionName blockId : (NSString *) blockId blockName : (NSString *) blockName {
    _cityId = cityId;
    _cityName = cityName;
    _regionId = regionId;
    _regionName = regionName;
    _blockId = blockId;
    _blockName = blockName;
    
    _isCityChoose = YES;
    
    [_cityBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",_cityName,_regionName,_blockName] forState:UIControlStateNormal];
};

@end
