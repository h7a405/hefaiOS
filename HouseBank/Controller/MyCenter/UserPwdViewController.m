//
//  UserPwdViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "UserPwdViewController.h"
#import "ViewUtil.h"
#import "Constants.h"
#import "KGStatusBar.h"
#import "ResultCode.h"
#import "URLCommon.h"
#import "MyCenterWsImpl.h"
#import "WaitingView.h"
#import "AppDelegate.h"
#import "TextUtil.h"

/**
 修改密码
 */
@interface UserPwdViewController ()<UITextFieldDelegate>{
    UITextField *_edit1;
    UITextField *_edit2;
    UITextField *_edit3;
}
-(void) doLoadView;
-(void) onSaveBtnClick;
@end

@implementation UserPwdViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self doLoadView];
}

//加载界面
-(void) doLoadView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7?65:5;
    float itemHeight = 74;
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5, 100, 20)];
    lable1.text = @"原始密码";
    lable1.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight, 100, 20)];
    lable2.text = @"新密码";
    lable2.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable2];
    
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight*2, 100, 20)];
    lable3.text = @"确认新密码";
    lable3.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable3];
    
    
    UITextField *btn1 = [[UITextField alloc] initWithFrame:CGRectMake(10, topOffset + 30, rect.size.width - 20, 44)];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    btn1.tag = 1;
    btn1.autocorrectionType = UITextAutocorrectionTypeNo;
    btn1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    btn1.textAlignment = NSTextAlignmentCenter;
    btn1.delegate = self;
    btn1.returnKeyType = UIReturnKeyDone;
    btn1.borderStyle = UITextBorderStyleRoundedRect;
    btn1.font = [UIFont systemFontOfSize:14];
    btn1.secureTextEntry = YES;
    
    [self.view addSubview:btn1];
    
    _edit1 = btn1;
    
    UITextField *btn2 = [[UITextField alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight, rect.size.width - 20, 44)];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    btn2.textAlignment = NSTextAlignmentCenter;
    btn2.autocorrectionType = UITextAutocorrectionTypeNo;
    btn2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    btn2.tag = 2;
    btn2.delegate = self;
    btn2.returnKeyType = UIReturnKeyDone;
    btn2.borderStyle = UITextBorderStyleRoundedRect;
    btn2.font = [UIFont systemFontOfSize:14];
    btn2.secureTextEntry = YES;
    
    [self.view addSubview:btn2];
    
    _edit2 = btn2;
    
    UITextField *btn3 = [[UITextField alloc] initWithFrame:CGRectMake(10, topOffset + 30 + itemHeight*2, rect.size.width - 20, 44)];
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
    btn3.secureTextEntry = YES;
    
    _edit3 = btn3;
    
    [self.view addSubview:btn3];
    
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight*3, rect.size.width - 20, 44)];
    [saveBtn setBackgroundImage:[ViewUtil imageWithColor:[ViewUtil string2Color:@"ff9900"] ] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
}

//保存按钮点击事件
-(void) onSaveBtnClick{
    NSString *oldPwd = _edit1.text;
    NSString *newPwd = _edit2.text;
    NSString *confirmPwd = _edit3.text;
    
    BOOL isLegal = YES;
    
    if ([TextUtil isEmpty:oldPwd]) {
        //原始密码为空
        isLegal = NO;
        [KGStatusBar showErrorWithStatus:@"请填写原始密码"];
    }
    
    if ([newPwd length]<6&&isLegal) {
        //密码长度不合法
        isLegal = NO;
        [KGStatusBar showErrorWithStatus:@"密码长度不能小于6！"];
    }
    
    if (![newPwd isEqualToString:confirmPwd]&&isLegal) {
        //密码输入不一致
        isLegal = NO;
        [KGStatusBar showErrorWithStatus:@"两次密码输入不一致！"];
    }
    
    if (isLegal) {
        //确认合法，上传
        WaitingView *waitingView = [[WaitingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [waitingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在修改..."];
        
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        
        MyCenterWsImpl *ws = [MyCenterWsImpl new];
        [ws updatePwd:[URLCommon buildUrl:MODYFY_BROKER_PWD] oldPwd:oldPwd newPwd:newPwd sid:user.sid result:^(BOOL isSuccess, id result, NSString *data) {
            [waitingView dismissWatingView];
            if ([data intValue] == SUCCESS) {
                //成功
                [KGStatusBar showSuccessWithStatus:@"修改密码成功"];
                //关闭当前页
                [self.navigationController popViewControllerAnimated:YES];
            }else if([data intValue] == USER_NOT_EXISTS){
                [KGStatusBar showErrorWithStatus:@"原始密码不正确！"];
            }else{
                [KGStatusBar showErrorWithStatus:@"密码修改失败"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark text field delegation
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.5f;
};

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 0.0f;
    
    return YES;
};

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
};

@end
