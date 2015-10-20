//
//  AddNewContactViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "AddNewContactViewController.h"
#import "AppDelegate.h"
#import "AddressBookWsImpl.h"
#import "MBProgressHUD+Add.h"
#import "FYUserDao.h"
#import "Constants.h"
#import "FullScreenPickerView.h"
#import "WaitingView.h"
#import "CustomButton.h"

@interface AddNewContactViewController ()<UITextViewDelegate,UITextFieldDelegate,FullScreenPickerViewDelegation>{
    __weak UIView *_currentText;
    CGPoint _defaultCenter ;
    
    NSInteger _currentSource;
    NSInteger _currentLevel;
    NSInteger _currentType;
    
    UIButton *_currentBtn ;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextView *editText;

@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UITextField *nickText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UIButton *sourceBtn;
@property (weak, nonatomic) IBOutlet UIButton *importantsBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextField *industryText;
@property (weak, nonatomic) IBOutlet UITextField *companyText;
@property (weak, nonatomic) IBOutlet UITextField *positionsText;
@property (weak, nonatomic) IBOutlet UITextField *qqText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *wxText;

@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet CustomButton *deleteBtn;

- (IBAction)cancleTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;

- (IBAction)homeTapped:(id)sender;
- (IBAction)levelTapped:(id)sender;
- (IBAction)typeBtn:(id)sender;


-(void) initialize ;
-(void) initializeText ;
-(void) initializeContact ;
-(void) resignTextFirstResponder ;

@end

@implementation AddNewContactViewController

@synthesize contactId = _contactId;
@synthesize isUpdate = _isUpdate;
@synthesize contact = _contact;

@synthesize delegation ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self initializeText];
    [self initializeContact];
}

-(void) initialize{
    if (_isUpdate) {
        self.navigationItem.title = @"编辑联系人";
    }else{
        self.navigationItem.title = @"添加联系人";
        [_deleteBtn setTitle:@"取 消" forState:UIControlStateNormal];
    }
    
    _defaultCenter = CGPointMake(self.view.center.x, self.view.center.y);
    
    _scrollview.contentSize = _scrollview.frame.size;
    self.view.frame = [UIScreen mainScreen].bounds;
    _scrollview.frame = self.view.bounds;
    [_editText setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"edit_back"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void) initializeText{
    _scrollview.delegate = self;
    
    _nameText.delegate = self;
    _nickText.delegate = self;
    _mobileText.delegate = self;
    _industryText.delegate = self;
    _companyText.delegate = self;
    _positionsText.delegate = self;
    _qqText.delegate = self;
    _emailText.delegate = self;
    _wxText.delegate = self;
    _addressText.delegate = self;
    _editText.delegate = self;
}

-(void) initializeContact{
    if (_isUpdate) {
        NSDictionary *result = _contact ;
        _nameText.text = [TextUtil replaceNull:result[@"name"]];
        _nickText.text = [TextUtil replaceNull:result[@"nickname"]];
        _mobileText.text = [TextUtil replaceNull:result[@"mobilephone1"]];
        _phoneText.text = [TextUtil replaceNull:result[@"telphone1"]];
        
        
        _industryText.text = [TextUtil replaceNull:result[@"industry"]];
        _companyText.text = [TextUtil replaceNull:result[@"company"]];
        _positionsText.text = [TextUtil replaceNull:result[@"position"]];
        _qqText.text = [TextUtil replaceNull:result[@"qq"]];
        _emailText.text = [TextUtil replaceNull:result[@"email"]];
        _wxText.text = [TextUtil replaceNull:result[@"weixin"]];
        _addressText.text = [TextUtil replaceNull:result[@"address"]];
        _editText.text = [TextUtil replaceNull:result[@"memo"]];
        
        NSArray *sourceArray = ContactSource;
        if ([result[@"sourceId"] integerValue] < sourceArray.count) {
            [_sourceBtn setTitle:sourceArray[[result[@"sourceId"] integerValue]] forState:UIControlStateNormal];
            _currentSource = [result[@"sourceId"] integerValue];
        }else {
            _currentSource = 0;
        }
        
        
        NSArray *levelArray = LevelStrs;
        if ([result[@"importantLevel"] integerValue]-1 < levelArray.count) {
            [_importantsBtn setTitle:levelArray[[result[@"importantLevel"] integerValue]-1] forState:UIControlStateNormal];
            _currentLevel = [result[@"importantLevel"] integerValue]-1;
        }else {
            _currentLevel = 1;
        }
        
        
        NSArray *typeArray = ContactType;
        if ([result[@"linkType"] integerValue] < typeArray.count) {
            [_typeBtn setTitle:typeArray[[result[@"linkType"] integerValue]] forState:UIControlStateNormal];
            _currentType = [result[@"linkType"] integerValue];
        }else{
            _currentType = 0;
        }
    }
}

-(void) keyboardWillShow: (NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect rect = [_currentText convertRect:_currentText.bounds toView:[AppDelegate shareApp].window];
    
    float offset = 10;
    if(_currentText == _editText ){
        offset = 45;
        [_scrollview scrollRectToVisible:rect(0, _scrollview.contentSize.height - _scrollview.frame.size.height, _scrollview.frame.size.width, _scrollview.frame.size.height) animated:NO];
    }
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

- (IBAction)cancleTapped:(id)sender {
    if (!_isUpdate) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    FYUserDao *userDao = [FYUserDao new];
    NSString *sid = [userDao user].sid;
    
    WaitingView *waittingView = [WaitingView defaultView];
    [waittingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在删除联系人"];
    
    Result result = ^(BOOL isSuccess, id result, NSString *data) {
        NSLog(@"%@ == ",result);
        
        [waittingView dismissWatingView];
        if ([@"0" isEqualToString:data]) {
            [MBProgressHUD showMessag:@"删除成功" toView:[AppDelegate shareApp].window];
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([self.delegation respondsToSelector:@selector(finishUpdate)]) {
                [self.delegation finishUpdate];
            }
        }else{
            [MBProgressHUD showNetErrorToView:self.view];
        }
    } ;
    
    AddressBookWsImpl *ws = [AddressBookWsImpl new];
    [ws deleteContactInfo:_contactId sid:sid result:result];
}

- (IBAction)saveTapped:(id)sender {
    NSString *name = _nameText.text;
    NSString *mobile = _mobileText.text;
    NSString *nickName = _nickText.text;
    NSString *phone = _phoneText.text;
    NSString *email = _emailText.text;
    NSString *qq = _qqText.text;
    NSString *weixin = _wxText.text;
    NSString *industry = _industryText.text;
    NSString *company = _companyText.text;
    NSString *position = _positionsText.text;
    NSString *address = _addressText.text;
    
    NSString *birthDay = @"";
    NSString *memorialDay = @"";
    NSString *sourceId = [NSString stringWithFormat:@"%d",_currentSource ];
    NSString *level = [NSString stringWithFormat:@"%d",_currentLevel + 1];
    NSString *linkType = [NSString stringWithFormat:@"%d",_currentType];
    
    NSString *memo = _editText.text;
    
    if ([TextUtil isEmpty:name] || [TextUtil isEmpty:mobile]) {
        [MBProgressHUD showError:@"请输入必填项" toView:self.view];
    }else{
        FYUserDao *dao = [FYUserDao new];
        NSString *sid = [dao user].sid;
        
        WaitingView *waittingView = [WaitingView defaultView];
        [waittingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在提交数据..."];
        
        
        
        AddressBookWsImpl *ws = [AddressBookWsImpl new];
        
        Result result = ^(BOOL isSuccess, id result, NSString *data) {
            [waittingView dismissWatingView];
            if ([@"0" isEqualToString:data]) {
                [MBProgressHUD showMessag:@"提交成功" toView:[AppDelegate shareApp].window];
                [self.navigationController popViewControllerAnimated:YES];
                
                if ([self.delegation respondsToSelector:@selector(finishUpdate)]) {
                    [self.delegation finishUpdate];
                }
            }else{
                [MBProgressHUD showNetErrorToView:self.view];
            }
        } ;
        if (!_isUpdate) {
            [ws addContact:sid name:name nickName:nickName mobilePhone:mobile telPhone:phone email:email qq:qq weixin:weixin industry:industry company:company position:position birthday:birthDay memorialDay:memorialDay importantLevel:level sourceId:sourceId memo:memo address:address linkType:linkType result:result];
        }else{
            [ws updateContact:sid contactId:_contactId name:name nickName:nickName mobilePhone:mobile telPhone:phone email:email qq:qq weixin:weixin industry:industry company:company position:position birthday:birthDay memorialDay:memorialDay importantLevel:level sourceId:sourceId memo:memo address:address linkType:linkType result:result];
        }
    }
}

- (IBAction)homeTapped:(id)sender {
    FullScreenPickerView *pickView = [[FullScreenPickerView alloc] init];
    pickView.delegation = self;
    [pickView showWith:ContactSource index:_currentSource];
    
    _currentBtn = sender;
}

- (IBAction)levelTapped:(id)sender {
    FullScreenPickerView *pickView = [[FullScreenPickerView alloc] init];
    pickView.delegation = self;
    [pickView showWith:LevelStrs index:_currentLevel];
    
    _currentBtn = sender;
}

- (IBAction)typeBtn:(id)sender {
    FullScreenPickerView *pickView = [[FullScreenPickerView alloc] init];
    pickView.delegation = self;
    [pickView showWith:ContactType index:_currentType];
    
    _currentBtn = sender;
}

-(void) resignTextFirstResponder{
    [_currentText resignFirstResponder];
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

-(void) didTappenBy : (FullScreenPickerView *) fullPickerView index : (NSInteger) index{
    NSArray *array = nil;
    
    if (_currentBtn == _sourceBtn) {
        _currentSource = index;
        array = ContactSource;
    }else if(_currentBtn == _importantsBtn){
        _currentLevel = index;
        array = LevelStrs;
    }else if(_currentBtn == _typeBtn){
        _currentType = index;
        array = ContactType;
    }
    
    NSString *str = array[index];
    [_currentBtn setTitle:str forState:UIControlStateNormal];
    
    [fullPickerView dismiss];
};

@end
