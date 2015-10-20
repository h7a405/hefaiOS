//
//  LoginViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-11.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "FYUserDao.h"
#import "LoginWsImpl.h"
#import "TextUtil.h"
#import "AppDelegate.h"
#import "NSString+Helper.h"
#import "KeyboardToolView.h"
#import "MBProgressHUD+Add.h"
#import "UpYun.h"

@interface LoginViewController ()<UITextFieldDelegate,KeyboardToolDelegate,UINavigationControllerDelegate>{
    UIView *_firstView;
}
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;


- (IBAction)cancelTapped:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=KColorFromRGB(0xf1f1f1);
    _username.delegate = self;
    _password.delegate = self;
    
    [self.navigationController.navigationBar setBackgroundImage:[ViewUtil imageWithColor:KColorFromRGB(0xf3f3f3)] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: KColorFromRGB(0x333333), NSForegroundColorAttributeName,nil]];
    
    self.navigationController.delegate=self;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
}

#pragma mark - 登录
- (IBAction)loginSubmit:(id)sender{
    [self.view endEditing:YES];
    
    if ([self check]) {
        [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES].labelText=@"正在登录";
        
        LoginWsImpl *ws = [LoginWsImpl new];
        [ws login:_username.text password:_password.text result:^(BOOL isSuccess, id result, NSString *data) {
            [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
            NSLog(@"%s || data:%@ and isSuccess:%i", __FUNCTION__, data, isSuccess);
            if (isSuccess) {
                UserBean *user = [UserBean userWithDict:result];
                
                [[NSUserDefaults standardUserDefaults] setObject:user.cityId forKey:@"cityId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:user.cityName forKey:@"cityName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:user.sid forKey:@"sid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                FYUserDao *userDao = [FYUserDao new];
                [userDao saveUser:user];
                [userDao setLogin:YES];
                
                [TextUtil logObject:user];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:KLoginSuccess object:nil];
                
                [self dismissViewControllerAnimated:YES completion:^{}];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"用户名不存在或密码错误 !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 检查登录
-(BOOL)check{
    NSString *msg=nil;
    if ([_username.text isEmptyString]) {
        msg=@"账户名不能为空 ！";
    }else if(![Tool validateMobile:_username.text]){
        msg=@"请输入合法的11位手机号码 ！";
    }else if ([_password.text isEmptyString]){
        msg=@"密码不能为空 ！";
    }else{
        return YES;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return NO;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_firstView resignFirstResponder];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginSubmit:nil];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _firstView = textField;
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    tool.delegate=self;
    
    if (textField==_username) {
        textField.returnKeyType=UIReturnKeyNext;
    }else{
        textField.returnKeyType=UIReturnKeySend;
    }
    return YES;
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button{
    [self.view endEditing:YES];
}

#pragma mark - navgation delegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //隐藏状态栏
    //    if ([viewController isKindOfClass:[LoginViewController class]]||[viewController isKindOfClass:[RegisterViewController class]]) {
    //        [navigationController setNavigationBarHidden:YES animated:YES];
    //    }else{
    //        [navigationController setNavigationBarHidden:NO animated:YES];
    //    }
}
- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
