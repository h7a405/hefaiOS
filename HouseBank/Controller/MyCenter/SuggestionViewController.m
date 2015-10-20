//
//  SuggestionViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SuggestionViewController.h"
#import "ViewUtil.h"
#import "WaitingView.h"
#import "URLCommon.h"
#import "Constants.h"
#import "ResultCode.h"
#import "AppDelegate.h"
#import "MyCenterWsImpl.h"
#import "TextUtil.h"
#import "KGStatusBar.h"
#import "FYUserDao.h"
#import "MBProgressHUD+Add.h"

/**
 意见反馈
 */
@interface SuggestionViewController ()<UITextViewDelegate>{
    UITextView *_editText;
}

-(void) doLoadView;
-(void) onTap;
-(void) onSaveBtnClick;

@end

@implementation SuggestionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    [self doLoadView];
    
    //点击手势，用于隐藏输入法
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.view addGestureRecognizer:tap];
}

//加载界面
-(void) doLoadView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7?70:10;
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset, rect.size.width - 10, 35)];
    hintLabel.text = @"你好，我是合发房银产品经理，欢迎您给我们提出产品的使用感受和建议！";
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:hintLabel  ];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset + 50, 100, 15)];
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.text = @"内容：";
    [self.view addSubview:contentLabel  ];
    
    UITextView *editText = [[UITextView alloc] initWithFrame:CGRectMake(10, topOffset + 70, rect.size.width - 20, 130)];
    editText.autocorrectionType = UITextAutocorrectionTypeNo;
    editText.layer.borderColor = [ViewUtil string2Color:@"ff9900"].CGColor;
    editText.layer.borderWidth = 1.0f;
    editText.font = [UIFont systemFontOfSize:15];
    editText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    editText.delegate = self;
    [self.view addSubview:editText];
    
    _editText = editText;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset +210, rect.size.width - 20, 40)];
    [saveBtn setBackgroundImage:[ViewUtil imageWithColor:[ViewUtil string2Color:@"ff9900"]] forState:UIControlStateNormal];
    [saveBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

-(void) onTap{
    [_editText resignFirstResponder];
}

//保存按钮点击，上传反馈
-(void) onSaveBtnClick{
    if ([TextUtil isEmpty:_editText.text]) {
        [KGStatusBar showErrorWithStatus:@"您输入的内容为空！"];
    }else{
        WaitingView *waitimg = [[WaitingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [waitimg showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在加载.."];
        
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        
        MyCenterWsImpl *ws = [MyCenterWsImpl new];
        [ws updateSuggestion:[URLCommon buildUrl:SUGGESTION] sid:user.sid content:_editText.text mobile:user.mobilephone result:^(BOOL isSuccess, id result, NSString *data) {
            [waitimg dismissWatingView];
            if ([data intValue]>0) {
                
                [MBProgressHUD showSuccess:@"发送成功，感谢您对我们的支持!" toView:[KAPPDelegate window]];
                //                [KGStatusBar showSuccessWithStatus:@"发送成功，感谢您对我们的支持"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //                [KGStatusBar showErrorWithStatus:@"提交建议失败！"];
                [MBProgressHUD showMessag:@"提交建议失败!" toView:[KAPPDelegate window]];
            }
        }];
        
    }
}




@end
