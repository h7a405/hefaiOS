//
//  RegViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-11.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//
//

#import "RegisterViewController.h"
#import "SelectTypeView.h"
#import "CustomButton.h"
#import "XSPrivacyViewController.h"
#import "LoginWsImpl.h"
#import "TextUtil.h"
#import "ResultCode.h"
#import "NSString+Helper.h"
#import "KeyboardToolView.h"
#import "Address.h"
#import "MBProgressHUD+Add.h"

@interface RegisterViewController ()<UITextFieldDelegate,KeyboardToolDelegate,SelectTypeViewDelegate>{
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    
    NSString *_cityId;
    NSString *_areaId;
    NSString *_streesId;
    
    AddressLevel _level;
    NSString *_addressInfo;
    BOOL _agree;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet CustomButton *regBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _agree=YES;
    self.view.backgroundColor=KColorFromRGB(0xf1f1f1);
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
}

-(IBAction)back:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableView data  delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 1;
}

#pragma mark - textField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_address) {
        [self.view endEditing:YES];
        [self showSelectTypeView:AddressLevelProvince];
        return NO;
    }
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    tool.delegate=self;
    textField.inputAccessoryView=tool;
    
    return YES;
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button{
    [self.view endEditing:YES];
}

#pragma mark - 选择地区 - 根据level判断拿的数据
-(void)typeView:(SelectTypeView *)view didSelect:(NSString *)str selectIndex:(NSInteger)index{
    if (_level==AddressLevelProvince) {
        _addressInfo=str;
    }else{
        _addressInfo= [_addressInfo stringByAppendingString:str];
    }
    
    _address.text=_addressInfo;
    
    if (_level==AddressLevelProvince) {
        _city=[Address citysWithProvience:_provience[index]];
        
        Address *address=_city[0];
        
        if (_city.count==1&&[str isEqualToString:address.name]) {
            _cityId=[NSString stringWithFormat:@"%@",[_city[0] tid]];
            _area=[Address areasWithCity:_city[0]];
            [self showSelectTypeView:AddressLevelArea];
        }else{
            [self showSelectTypeView:AddressLevelCity];
        }
    }else if (_level==AddressLevelCity){
        _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
        _area=[Address areasWithCity:_city[index]];
        [self showSelectTypeView:AddressLevelArea];
    }else if (_level==AddressLevelArea){
        _areaId=[NSString stringWithFormat:@"%@",[_area[index] tid]];
        
        _strees=[Address streesWithArea:_area[index]];
        [self showSelectTypeView:AddressLevelStreet];
    }else{
        _streesId=[NSString stringWithFormat:@"%@",[_strees[index] tid]];
    }
}
#pragma mark - 选择地址
-(void)showSelectTypeView:(AddressLevel)level{
    SelectTypeView *view=[[SelectTypeView alloc]init];
    [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
    view.delegate=self;
    NSMutableArray *tmp=[NSMutableArray array];
    _level=level;
    if (level==AddressLevelProvince) {
        _provience=[Address getAllProvience];
        [_provience enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择省份"];
    }else if (level==AddressLevelCity){
        [_city enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择城市"];
    }else if (level==AddressLevelArea){
        [_area enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择区域"];
    }else if (level==AddressLevelStreet){
        [_strees enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择版块"];
    }
    view.data = tmp;
}
#pragma mark - 提交注册
- (IBAction)submit:(id)sender{
    if ([self check]) {
        [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES];
        
        LoginWsImpl *ws = [LoginWsImpl new];
        [ws registerBroker:_phoneNum.text name:_name.text password:_password.text cityId:_cityId regionId:_areaId brokerId:_streesId result:^(BOOL isSuccess, id result, NSString *data) {
            [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
            
            if ([data intValue] == HadRegister)  {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号已注册过,请直接登录,或者换个手机号再重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }else if(Register([data intValue])){
                [MBProgressHUD showMessag:@"注册成功!" toView:[KAPPDelegate window]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }
        }];
    }
}

#pragma mark - 注册验证
-(BOOL)check{
    NSString *msg=nil;
    if ([_phoneNum.text isEmptyString]) {
        msg=@"账户名不能为空!";
    }else if(_phoneNum.text.length!=11){
        msg=@"请输入正确的11位手机号码！";
    }else if(![Tool validateMobile:_phoneNum.text]){
        msg=@"请输入合法的11位手机号码！";
    }else if ([_password.text isEmptyString]){
        msg=@"密码不能为空!";
    }else if ([_name.text isEmptyString]){
        msg=@"名字不能为空!";
    }else if ([_cityId isEmptyString]||_cityId==nil){
        msg=@"先请选择城市!";
    }else if ([_areaId isEmptyString]||_areaId==nil){
        msg=@"请先选择区域!";
    }else if ([_streesId isEmptyString]||_streesId==nil){
        msg=@"请先选择版块!";
    }else if(_agree==NO){
        msg=@"请先同意房银网用户协议!";
    }else{
        return YES;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return NO;
}

#pragma mark - 查看协议
- (IBAction)xieyi:(id)sender{
    XSPrivacyViewController *privacy=[[XSPrivacyViewController alloc]init];
    [self.navigationController pushViewController:privacy animated:YES];
}

#pragma mark - 点击同意协议
- (IBAction)agreeChange:(CustomButton *)sender{
    sender.selected=!sender.selected;
    _agree=sender.selected;
}
#pragma mark - 退回登录界面
- (IBAction)login:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
