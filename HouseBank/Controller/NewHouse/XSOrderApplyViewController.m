//
//  XSOrderApplyViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSOrderApplyViewController.h"
#import "FYUserDao.h"
#import "NSString+Helper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "NewHouseWsImpl.h"

@interface XSOrderApplyViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    BOOL _pop;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@end

@implementation XSOrderApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark  - 提交申请
- (IBAction)submit:(id)sender{
    if ([_name.text isEmptyString]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"客户姓名不能为空!请填写后再提交!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }else if ([_phone.text isEmptyString]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"手机号码不能为空!请填写后再提交!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }else if(![Tool validateMobile:_phone.text]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入合法的11位手机号码！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NewHouseWsImpl   *ws = [NewHouseWsImpl new];
    [ws submitOrder:user.sid projectId:_projectId name:_name.text phone:_phone.text result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!isSuccess) {
            NSString *msg=nil;
            if ([data isEqualToString:@"1"]) {
                _pop=YES;
                msg=@"预约成功,等待审核中...";
            }else if ([data isEqualToString:@"2"]) {
                msg=@"预约成功!";
                _pop=YES;
            }else if ([data isEqualToString:@"-2"]) {
                msg=@"重复预约!";
                _pop=YES;
            }else if ([data isEqualToString:@"-1"]) {
                msg=@"重复预约!";
                _pop=YES;
            }else if ([data isEqualToString:@"-3"]) {
                msg=@"预约失败,请重试!";
                _pop=NO;
            }
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_pop) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
