//
//  ChangePersonntroduction ViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "ChangePersonIntroductionViewController.h"
#import "ViewUtil.h"
#import "CustomStatueBar.h"
#import "TextUtil.h"
#import "WaitingView.h"
#import "MyCenterWsImpl.h"
#import "URLCommon.h"
#import "Constants.h"
#import "UserBean.h"
#import "ResultCode.h"
#import "KGStatusBar.h"
#import "FYUserDao.h"

@interface ChangePersonIntroductionViewController ()<UITextViewDelegate>{
    __weak BrokerInfoBean *_broker;
    __weak UILabel *_countLabel ;
    __weak UITextView *_editText;
    __weak WaitingView *_waitingView;
}

-(void) doLoadView ;
-(void) setCountLabelText : (NSInteger) count;
-(void) initGesture ;
-(void) onTap ;
-(void) onSaveBtnClick ;
-(void) saveResume : (NSString *) resume;
-(void) onUploaded : (BOOL) isSuccess ;
@end

@implementation ChangePersonIntroductionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"编辑自我介绍";
    [self doLoadView];
    [self initGesture];
}

-(void) doLoadView{
    CGRect rect = self.view.bounds;
    
    float topOffset = iOS7? 70 : 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset, rect.size.width - 10, 20 )];
    label.text = @"最多可输入200个字符";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, topOffset+20, rect.size.width - 10, 160)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    view.layer.borderWidth = 1.0f;
    [self.view addSubview:view];
    
    UITextView *editText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, rect.size.width - 20, 130)];
    editText.autocorrectionType = UITextAutocorrectionTypeNo;
    editText.font = [UIFont systemFontOfSize:15];
    editText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    editText.delegate = self;
    [view addSubview:editText];
    
    _editText = editText;
    
    [editText becomeFirstResponder ];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 20, view.frame.size.width - 10, 20)];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    countLabel.text = @"200 / 200";
    [view addSubview:countLabel];
    
    _countLabel = countLabel;
    
    if (![_broker.resume isKindOfClass:[NSNull class]]) {
        [self setCountLabelText:200 - _broker.resume.length];
        [editText setText:_broker.resume];
    }
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, topOffset +190, rect.size.width - 10, 44)];
    [saveBtn setBackgroundImage:[ViewUtil imageWithColor:[ViewUtil string2Color:@"ff9900"]] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) onTap{
    [_editText endEditing:YES];
}

-(void) onSaveBtnClick{
    if (_editText.text.length >200) {
        CustomStatueBar *bar = [[CustomStatueBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [bar showStatusMessage:@"字数超过限制"];
        [bar performSelector:@selector(hide) withObject:nil afterDelay:2.5];
    }else if ([_editText.text isEqualToString:_broker.resume]){
        CustomStatueBar *bar = [[CustomStatueBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [bar showStatusMessage:@"内容没有改变"];
        [bar performSelector:@selector(hide) withObject:nil afterDelay:2.5];
    } else {
        WaitingView *waitingView = [[WaitingView alloc] initWithFrame:self.view.bounds];
        [waitingView showWaitingViewWithHintTextInView:self.view hintText:@"正在连接..."];
        [self.view addSubview:waitingView];
        _waitingView = waitingView;
        
        [self saveResume:_editText.text];
    }
}

-(void) saveResume:(NSString *)resume{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws updateBrokerResume : [URLCommon buildUrl : UPDATE_BROKER_INFO] resume:resume sid : user.sid result:^(BOOL isSuccess , id result,NSString *data){
        [self onUploaded:[data intValue] == SUCCESS];
    }];
}

-(void) onUploaded:(BOOL)isSuccess{
    [_waitingView removeFromSuperview];
    
    NSString *hintText = nil;
    if (isSuccess) {
        hintText = @"修改成功";
        [KGStatusBar showSuccessWithStatus:hintText];
        _broker.resume = _editText.text;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        hintText = @"修改失败";
        [KGStatusBar showErrorWithStatus:hintText];
    }
    
}

-(void) initGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.view addGestureRecognizer:tap];
}

-(void) setCountLabelText:(NSInteger)count{
    _countLabel.text = [NSString stringWithFormat:@"%d / 200",count];
}

-(void) setBroker : (BrokerInfoBean *) broker{
    _broker = broker;
};

#pragma mark textview delegation
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int count = 200 - textView.text.length;
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }else if ([@"" isEqualToString:text] && ![@"" isEqualToString:textView.text]) {
        count += 1;
    }else{
        count -= text.length;
    }
    [self setCountLabelText: count];
    return YES;
};



@end
