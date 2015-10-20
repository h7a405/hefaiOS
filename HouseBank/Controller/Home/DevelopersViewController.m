//
//  DevelopersViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "DevelopersViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "AddressChooseView.h"
#import "BusinessWsImpl.h"
#import "AppDelegate.h"
#import "WaitingView.h"
#import "UIPlaceHolderTextView.h"

@interface DevelopersViewController ()<UITextFieldDelegate,UITextViewDelegate,AddressDelegation>{
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
@property (weak, nonatomic) IBOutlet UIScrollView *editText;
@property (weak, nonatomic) IBOutlet UITextField *houseName;
@property (weak, nonatomic) IBOutlet UITextField *houseAddress;
@property (weak, nonatomic) IBOutlet UITextField *houseArea;
@property (weak, nonatomic) IBOutlet UITextField *houseCount;
@property (weak, nonatomic) IBOutlet UITextField *housePrice;
@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPositions;
@property (weak, nonatomic) IBOutlet UITextField *userPhone1;
@property (weak, nonatomic) IBOutlet UITextField *userPhone2;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *messageText;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;



- (void) initialize;
- (void) initializeText;
- (void) resignTextFirstResponder ;
- (IBAction)submitTapped:(id)sender;
- (IBAction)cityBtnTapped:(id)sender;

-(void) keyboardWillShow: (NSNotification *)notify;
-(void) keyboardWillHide: (NSNotification *)notify;

@end

@implementation DevelopersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新房项目委托";
    
    [self initialize];
    [self initializeText];
}

-(void) initializeText{
    _defaultCenter = self.view.center;
    
    _houseName.delegate = self ;
    _houseAddress.delegate = self ;
    _houseArea.delegate = self;
    _houseCount.delegate = self;
    _housePrice.delegate = self;
    _companyName.delegate = self;
    _userName.delegate = self;
    _userPositions.delegate = self;
    _userPhone1.delegate = self;
    _userPhone2.delegate = self;
    _messageText.delegate = self;
    
    _scrollView.delegate = self;
    
    _messageText.placeholder = @"例如：产权情况，居住环境，周边配套，交通情况。";
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignTextFirstResponder];
}

-(void) resignTextFirstResponder{
    [_currentText resignFirstResponder];
}

-(void) keyboardWillShow: (NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    if (keyboardRect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        return;
    }
    
    float offset = 10;
    if(_currentText == _messageText ){
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

-(void) initialize{
    [_editText setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"edit_back"]]];
    
    _scrollView.contentSize = CGSizeMake(320, _scrollView.frame.size.height);
    
    self.view.frame = [UIScreen mainScreen].bounds;
    _scrollView.frame = self.view.bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (IBAction)submitTapped:(id)sender {
    [self resignTextFirstResponder];
    
    NSString *houseName = _houseName.text;
    NSString *houseAddress = _houseAddress.text;
    NSString *houseArea = _houseArea.text;
    NSString *houseCount = _houseCount.text;
    NSString *housePrice = _housePrice.text;
    NSString *companyName = _companyName.text;
    NSString *userName = _userName.text;
    NSString *userPositions = _userPositions.text;
    NSString *userPhone1 = _userPhone1.text;
    NSString *userPhone2 = _userPhone2.text;
    
    NSString *message = _messageText.text;
    if ([TextUtil isEmpty:houseName]||[TextUtil isEmpty:houseAddress]||[TextUtil isEmpty:companyName]||[TextUtil isEmpty:userName]||[TextUtil isEmpty:userPhone1]) {
        [MBProgressHUD showError:@"信息不全，必填项都必须填上！" toView:self.view];
    }else if (!_isCityChoose){
        [MBProgressHUD showError:@"还没有选择区域哦！！" toView:self.view];
    }else{
        WaitingView *waittingView = [WaitingView defaultView];
        [waittingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在提交数据..."];
        
        BusinessWsImpl *ws = [BusinessWsImpl new];
        [ws submitDeveloperHouse:houseName communityAddress:houseAddress coverArea:houseArea unitCount:houseCount avgPrice:housePrice companyName:companyName consignorName:userName consignorPosition:userPositions linkPhone1:userPhone1 linkPhone2:userPhone2 remark:message cityId:_cityId regionId:_regionId blockId:_blockId result:^(BOOL isSuccess, id result, NSString *data) {
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

- (IBAction)cityBtnTapped:(id)sender {
    [self resignTextFirstResponder];
    
    AddressChooseView *addressView = [[AddressChooseView alloc] initWithFrame:self.view.bounds];
    addressView.delegation = self;
    [addressView show];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    if (scrollView != _messageText) {
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
