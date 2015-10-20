//
//  ChangeCommunityViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "ChangeCommunityViewController.h"
#import "ViewUtil.h"
#import "MLPAutoCompleteTextField.h"
#import "MLPCustomAutoCompleteCell.h"
#import "MyCenterWsImpl.h"
#import "Constants.h"
#import "URLCommon.h"
#import "NSString+Helper.h"
#import "KGStatusBar.h"
#import "WaitingView.h"
#import "BrokerDetailInfoBean.h"
#import "ResultCode.h"
#import "FYUserDao.h"

/**
 修改主营小区
 */

@interface ChangeCommunityViewController ()<UITextFieldDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate>{
    __weak BrokerInfoBean *_broker;
    
    __weak UIButton *_saveBtn;
    
    //主营小区输入框
    __weak MLPAutoCompleteTextField *_edit1;
    __weak MLPAutoCompleteTextField *_edit2;
    __weak MLPAutoCompleteTextField *_edit3;
    __weak MLPAutoCompleteTextField *_edit4;
    
    //主营小区标题文本
    __weak UILabel *_label1;
    __weak UILabel *_label2;
    __weak UILabel *_label3;
    __weak UILabel *_label4;
    
    //当前正在编辑的小区输入框
    __weak MLPAutoCompleteTextField *_currentEdit;
    
    //  当前view默认的中心点
    CGPoint center;
    
    //自动输入的文本
    NSMutableArray *_autoStrings;
    NSArray *_addresses;
    
    BrokerDetailInfoBean *_brokerDetail;
    BOOL _isInited;
    
    //当前正在下载的自动文本请求类，用于取消
    AFHTTPRequestOperationManager *_currentAfHttpForRequestCommunity;
}

-(void) doLoadView;
-(void) onSaveBtnClick;
-(void) onEditCheck : (NSInteger) index;
-(void) startAutoEdit : (NSString *) text;
-(void) textFieldDidChange:(UITextField *)textField;
-(void) loadData ;
-(void) setEditText;
@end

@implementation ChangeCommunityViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self doLoadView];
    center = self.view.center;
    self.navigationItem.title = @"编辑主营小区";
    [self loadData];
}

//加载界面
-(void) doLoadView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7?65:5;
    float itemHeight = 74;
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5, 100, 20)];
    lable1.text = @"主营小区一";
    lable1.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable1];
    
    _label1 = lable1;
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight, 100, 20)];
    lable2.text = @"主营小区二";
    lable2.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable2];
    
    _label2 = lable2;
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight*2, 100, 20)];
    lable3.text = @"主营小区三";
    lable3.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable3];
    
    _label3 = lable3;
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight*3, 100, 20)];
    lable4.text = @"主营小区四";
    lable4.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable4.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable4];
    
    _label4 = lable4;
    
    MLPAutoCompleteTextField *btn1 = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectMake(10, topOffset + 30, rect.size.width - 20, 44)];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    btn1.tag = 1;
    btn1.autocorrectionType = UITextAutocorrectionTypeNo;
    btn1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    btn1.textAlignment = NSTextAlignmentCenter;
    btn1.delegate = self;
    btn1.returnKeyType = UIReturnKeyDone;
    btn1.borderStyle = UITextBorderStyleRoundedRect;
    [btn1 registerAutoCompleteCellClass:[MLPCustomAutoCompleteCell class]
                 forCellReuseIdentifier:@"CustomCellId"];
    btn1.autoCompleteDataSource = self;
    btn1.autoCompleteDelegate = self;
    [btn1 setAutoCompleteTableViewHidden:NO];
    btn1.font = [UIFont systemFontOfSize:14];
    [btn1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:btn1];
    
    _edit1 = btn1;
    
    MLPAutoCompleteTextField *btn2 = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight, rect.size.width - 20, 44)];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    btn2.textAlignment = NSTextAlignmentCenter;
    btn2.autocorrectionType = UITextAutocorrectionTypeNo;
    btn2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    btn2.tag = 2;
    btn2.delegate = self;
    btn2.returnKeyType = UIReturnKeyDone;
    btn2.borderStyle = UITextBorderStyleRoundedRect;
    [btn2 registerAutoCompleteCellClass:[MLPCustomAutoCompleteCell class]
                 forCellReuseIdentifier:@"CustomCellId"];
    btn2.autoCompleteDataSource = self;
    btn2.autoCompleteDelegate = self;
    btn2.font = [UIFont systemFontOfSize:14];
    [btn2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:btn2];
    
    _edit2 = btn2;
    
    MLPAutoCompleteTextField *btn3 = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectMake(10, topOffset + 30 + itemHeight*2, rect.size.width - 20, 44)];
    btn3.backgroundColor = [UIColor whiteColor];
    btn3.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    btn3.textAlignment = NSTextAlignmentCenter;
    btn3.autocorrectionType = UITextAutocorrectionTypeNo;
    btn3.autocapitalizationType = UITextAutocapitalizationTypeNone;
    btn3.tag = 3;
    btn3.delegate = self;
    btn3.returnKeyType = UIReturnKeyDone;
    btn3.borderStyle = UITextBorderStyleRoundedRect;
    btn3.font = [UIFont systemFontOfSize:14];
    [btn3 registerAutoCompleteCellClass:[MLPCustomAutoCompleteCell class]
                 forCellReuseIdentifier:@"CustomCellId"];
    btn3.autoCompleteDataSource = self;
    btn3.autoCompleteDelegate = self;
    [btn3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:btn3];
    
    _edit3 = btn3;
    
    MLPAutoCompleteTextField *btn4 = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight*3, rect.size.width - 20, 44)];
    btn4.backgroundColor = [UIColor whiteColor];
    btn4.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    btn4.textAlignment = NSTextAlignmentCenter;
    btn4.autocorrectionType = UITextAutocorrectionTypeNo;
    btn4.autocapitalizationType = UITextAutocapitalizationTypeNone;
    btn4.tag = 4;
    btn4.delegate = self;
    btn4.font = [UIFont systemFontOfSize:14];
    btn4.borderStyle = UITextBorderStyleRoundedRect;
    [btn4 registerAutoCompleteCellClass:[MLPCustomAutoCompleteCell class]
                 forCellReuseIdentifier:@"CustomCellId"];
    btn4.autoCompleteDataSource = self;
    btn4.autoCompleteDelegate = self;
    btn4.returnKeyType = UIReturnKeyDone;
    [btn4 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:btn4];
    
    _edit4 = btn4;
    
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight*4, rect.size.width - 20, 44)];
    [saveBtn setBackgroundImage:[ViewUtil imageWithColor:[ViewUtil string2Color:@"ff9900"] ] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
    _saveBtn = saveBtn;
}

//加载数据
-(void) loadData{
    WaitingView *waitingView = [[WaitingView alloc] initWithFrame:self.view.bounds];
    [waitingView showWaitingViewWithHintTextInView:self.view hintText:@"正在连接..."];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestBrokerDetall:[URLCommon buildUrl:RESOURCE_BROKER_DETAIL resourceId:_broker.brokerId ] result:^(BOOL isSuccess , id result ,NSString *data){
        [waitingView dismissWatingView];
        if (isSuccess) {
            BrokerDetailInfoBean *brokerDetail = [BrokerDetailInfoBean brokerDetailByDic:result];
            _brokerDetail = brokerDetail;
            [self setEditText];
        }else{
            [KGStatusBar showErrorWithStatus:@"加载失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void) setEditText{
    if ([_brokerDetail.familiarCommunityName1 isKindOfClass:[NSString class]]) {
        _edit1.text = _brokerDetail.familiarCommunityName1;
    }
    
    if ([_brokerDetail.familiarCommunityName2 isKindOfClass:[NSString class]]) {
        _edit2.text = _brokerDetail.familiarCommunityName2;
    }
    
    if ([_brokerDetail.familiarCommunityName3 isKindOfClass:[NSString class]]) {
        _edit3.text = _brokerDetail.familiarCommunityName3;
    }
    
    if ([_brokerDetail.familiarCommunityName4 isKindOfClass:[NSString class]]) {
        _edit4.text = _brokerDetail.familiarCommunityName4;
    }
    
    _isInited = YES;
}

//当编辑框被点击时选择，index < 0 时表示未有编辑框选中
-(void) onEditCheck:(NSInteger)index {
    _label1.hidden = (index!=1 && index>0);
    _label2.hidden = (index!=2 && index>0);
    _label3.hidden = (index!=3 && index>0);
    _label4.hidden = (index!=4 && index>0);
    
    _edit1.hidden = (index!=1 && index>0);
    _edit2.hidden = (index!=2 && index>0);
    _edit3.hidden = (index!=3 && index>0);
    _edit4.hidden = (index!=4 && index>0);
    
    _saveBtn.hidden = index>0;
    
    float itemHeight = 74;
    
    NSInteger diff = index - 1;
    if (diff>0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(center.x, center.y-itemHeight*diff+10);
        }];
    }else if(index<0){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = center;
        }];
    }
}

//当有数据输入时开始查询自动输入
-(void) startAutoEdit:(NSString *)text{
    //取消上一次的查询，防止如果当次查询比上次查询快而导致的错位现象
    NSOperationQueue *queue = _currentAfHttpForRequestCommunity.operationQueue;
    [queue cancelAllOperations];
    
    if ([text isEmptyString] && !_isInited) {
        return;
    }
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    _currentAfHttpForRequestCommunity =  [ws requestAutoEdit:[URLCommon buildUrl:RESOURCE_COMMUNITY]  text:text result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            NSNumber *size = [result objectForKey:@"totalSize"];
            //当获取的记录数量大于0的时候刷新自动提示框
            if ([size intValue]>0) {
                NSArray *addresses = [result objectForKey:@"data"];
                _addresses = addresses;
                _autoStrings = [NSMutableArray new];
                for (id obj in addresses) {
                    [_autoStrings addObject:[obj objectForKey:@"communityName"]];
                }
                
            }else{
                //当没有记录的时候提示
                _autoStrings = nil;
                [KGStatusBar showErrorWithStatus:@"找不到小区，请联系：021-64300701"];
            }
            [_currentEdit reloadAutoData];
        }else{
            [KGStatusBar showErrorWithStatus:@"获取小区数据失败，请检查网络"];
        }
    }];
}

-(void) setBroker:(BrokerInfoBean *)broker{
    _broker = broker;
}

// 保存按钮点击事件
-(void) onSaveBtnClick{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    WaitingView *waitingView = [[WaitingView alloc] initWithFrame:self.view.bounds];
    [waitingView showWaitingViewWithHintTextInView:self.view hintText:@"正在连接..."];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws updateFamiliarCommunity:[URLCommon buildUrl:UPDATE_BROKER_INFO] sid:user.sid community1:_brokerDetail.familiarCommunity1 community2:_brokerDetail.familiarCommunity2 community3:_brokerDetail.familiarCommunity3 community4:_brokerDetail.familiarCommunity4 result:^(BOOL isSuccess, id result, NSString *data) {
        [waitingView dismissWatingView];
        if ([data intValue] == SUCCESS) {
            NSMutableString *string = [NSMutableString new];
            if ([_brokerDetail.familiarCommunityName1 isKindOfClass:[NSString class]]) {
                [string appendString:_brokerDetail.familiarCommunityName1];
                [string appendString:@" "];
            }
            
            if ([_brokerDetail.familiarCommunityName2 isKindOfClass:[NSString class]]) {
                [string appendString:_brokerDetail.familiarCommunityName2];
                [string appendString:@" "];
            }
            
            if ([_brokerDetail.familiarCommunityName3 isKindOfClass:[NSString class]]) {
                [string appendString:_brokerDetail.familiarCommunityName3];
                [string appendString:@" "];
            }
            
            if ([_brokerDetail.familiarCommunityName4 isKindOfClass:[NSString class]]) {
                [string appendString:_brokerDetail.familiarCommunityName4];
                [string appendString:@" "];
            }
            
            _broker.familiarCommunity = [NSString stringWithString:string];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [KGStatusBar showErrorWithStatus:@"加载失败"];
        }
    }];
};


- (void)textFieldDidChange:(UITextField *)textField{
    if (![textField.text isEmptyString]) {
        [self startAutoEdit:textField.text];
    }
};

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark text field delegation
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.5f;
    [self onEditCheck:textField.tag];
    _currentEdit = (MLPAutoCompleteTextField*)textField;
};

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 0.0f;
    [self onEditCheck:-1];
    _currentEdit = nil;
    return YES;
};

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
};

//自动输入框的输入源
- (NSArray *)possibleAutoCompleteSuggestionsForString:(NSString *)string{
    return _autoStrings;
};

//自动输入框被点击
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
            forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = nil;
    
    for (NSDictionary *dic1 in _addresses) {
        NSString *str = [dic1 objectForKey:@"communityName"];
        if ([str isEqualToString:selectedString]) {
            dic = dic1;
            break;
        }
    }
    
    NSNumber *communityId = [dic objectForKey:@"communityId"];
    
    BOOL isExists = NO;
    if ([communityId intValue] == [_brokerDetail.familiarCommunity1  intValue] || [communityId intValue] == [_brokerDetail.familiarCommunity2  intValue] ||[communityId intValue] == [_brokerDetail.familiarCommunity3  intValue] || [communityId intValue] == [_brokerDetail.familiarCommunity4  intValue]) {
        isExists = YES;
    }
    
    if (isExists) {
        [KGStatusBar showErrorWithStatus:@"您已经选择了该小区，请重新选择！"];
    }else{
        int index = _currentEdit.tag;
        if (index == 1) {
            _brokerDetail.familiarCommunity1 = communityId;
            _brokerDetail.familiarCommunityName1 = [dic objectForKey:@"communityName"];
        }else if(index == 2){
            _brokerDetail.familiarCommunity2 = communityId;
            _brokerDetail.familiarCommunityName2 = [dic objectForKey:@"communityName"];
        }else if(index == 3){
            _brokerDetail.familiarCommunity3 = communityId;
            _brokerDetail.familiarCommunityName3 = [dic objectForKey:@"communityName"];
        }else if(index == 4){
            _brokerDetail.familiarCommunity4 = communityId;
            _brokerDetail.familiarCommunityName4 = [dic objectForKey:@"communityName"];
        }
    }
};

@end
