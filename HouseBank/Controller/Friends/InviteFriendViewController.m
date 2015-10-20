//
//  InviteFriendViewController.m
//  HouseBank
//
//  Created by Gram on 14-9-29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "InviteHistoryViewController.h"
#import "FYUserDao.h"
#import "NSString+Helper.h"
#import "KeyboardToolView.h"
#import "AFNetworking.h"
#import "UIView+Extension.h"
@interface InviteFriendViewController ()<UIAlertViewDelegate,UITextFieldDelegate,KeyboardToolDelegate,UITextViewDelegate>{
    BOOL _email;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak,nonatomic) IBOutlet UIButton *btnInviteByMail;
@property (weak,nonatomic) IBOutlet UIButton *btnInviteByMsg;
@property (weak,nonatomic) IBOutlet UIView *viewMsg;
@property (weak,nonatomic) IBOutlet UIView *viewMail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtMail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UIView *viewInviteMsg;
@property (weak, nonatomic) IBOutlet UIView *viewInviteMail;
@property (weak, nonatomic) IBOutlet UITextView *txtInviteMail;
@property (weak, nonatomic) IBOutlet UITextView *txtInviteMsg;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UITextField *txtNameByMsg;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneByMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnSendInviteByMail;
@property (weak, nonatomic) IBOutlet UIButton *btnSendInviteByMsg;
@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _email=YES;
    // Do any additional setup after loading the view.
    _viewInviteMsg.layer.borderWidth = 1;
    _viewInviteMsg.layer.borderColor = Color(0,0,0).CGColor;
    _viewInviteMail.layer.borderWidth = 1;
    _viewInviteMail.layer.borderColor = Color(0,0,0).CGColor;
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+150);
    _scrollView.frame=self.view.bounds;
    //  [_txtName becomeFirstResponder];
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    self.txtInviteMsg.text = [NSString  stringWithFormat:@"我是%@，正在合发房银构建房源合作人脉。登录fybanks.com添加我为人脉，我们就可以合作啦！", user.name];
}

#pragma mark - 切换到邮件邀请
- (IBAction)btnByMailClick:(id)sender {
    CGRect frame=_line.frame;
    frame.origin.x=0;
    [UIView animateWithDuration:0.2 animations:^{
        _line.frame=frame;
    }];
    _viewMail.hidden = NO;
    _viewMsg.hidden = YES;
    [_txtName becomeFirstResponder];
}
#pragma mark - 短信邀请
- (IBAction)btnByMsgClick:(id)sender {
    CGRect frame=_line.frame;
    frame.origin.x=160;
    [UIView animateWithDuration:0.2 animations:^{
        _line.frame=frame;
    }];
    _txtName.highlighted = YES;
    _viewMail.hidden = YES;
    _viewMsg.hidden = NO;
    [_txtNameByMsg becomeFirstResponder];
    _email=!_email;
}
#pragma mark - 检查安全性
-(BOOL) check:(NSInteger) sendType
{
    NSString *msg=nil;
    if(sendType==1)
    {
        if ([_txtName.text isEmptyString]) {
            msg=@"姓名不能为空!";
            [_txtName becomeFirstResponder];
        }else if ([_txtMail.text isEmptyString]){
            msg=@"电子邮件不能为空!";
            [_txtMail becomeFirstResponder];
        }else if ([_txtPhone.text isEmptyString]){
            msg=@"手机号码不能为空!";
            [_txtPhone becomeFirstResponder];
        }else if ([_txtInviteMail.text isEmptyString]){
            msg=@"邀请留言!";
            [_txtInviteMail becomeFirstResponder];
        }else{
            return YES;
        }
    }
    else
    {
        if ([_txtNameByMsg.text isEmptyString]) {
            msg=@"姓名不能为空!";
            [_txtNameByMsg becomeFirstResponder];
        }else if ([_txtPhoneByMsg.text isEmptyString]){
            msg=@"手机号码不能为空!";
            [_txtPhoneByMsg becomeFirstResponder];
        }else if ([_txtInviteMsg.text isEmptyString]){
            msg=@"邀请留言!";
            [_txtInviteMsg becomeFirstResponder];
        }else{
            return YES;
        }
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return NO;
}
#pragma mark - 发送邀请
- (IBAction)btnSendInviteClick:(UIButton *)sender {
    if([self check:sender.tag] != YES)
        return;
    
    NSString* sName;
    NSString* sMail;
    NSString* sPhone;
    NSString* sInviteText;
    
    NSString* requestMethod;
    NSDictionary *data;
    if(sender.tag == 1)
    {
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        
        sName = _txtName.text;
        sMail = _txtName.text;
        sPhone = _txtPhone.text;
        sInviteText = _txtInviteMail.text;
        
        requestMethod = @"linkinvite/email";
        data=@{
               @"sid": user.sid,
               @"receiverName":sName,
               @"receiverEmail":sMail,
               @"receiverMobilephone":sPhone,
               @"content":sInviteText
               };
    }
    else
    {
        sName = _txtNameByMsg.text;
        sPhone = _txtPhoneByMsg.text;
        sInviteText = _txtInviteMsg.text;
        
        requestMethod = @"linkinvite/sms";
        
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        data=@{
               @"sid": user.sid,
               @"receiverName":sName,
               @"receiverMobilephone":sPhone,
               @"content":sInviteText
               };
    };
    
    AFHTTPRequestOperationManager *request=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:KBaseUrl];
    [request POST:requestMethod parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation.responseString  isEqual: @"true"])
        {
            //请求成功
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邀请发送成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"邀请发送失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        }
        
    }];
    
}
#pragma mark - 跳转页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    InviteHistoryViewController *his = segue.destinationViewController;
    his.isPushFromFriendInvite = YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //跳转到发出的邀请页
    [self performSegueWithIdentifier:@"history" sender:nil];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    tool.delegate=self;
    textField.inputAccessoryView=tool;
    if (IPhone4) {
        
        if (textField.y>80) {
            [_scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (IPhone4) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    tool.delegate=self;
    textView.inputAccessoryView=tool;
    if (IPhone4) {
        if (_email) {
            [_scrollView setContentOffset:CGPointMake(0, 250) animated:YES];
        }else{
            [_scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
        }
    }else{
        if (_email) {
            [_scrollView setContentOffset:CGPointMake(0, 250) animated:YES];
        }else{
            [_scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
        }
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
