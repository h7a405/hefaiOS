//
//  XSApplyLookHouseViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSApplyLookHouseViewController.h"
#import "HouseInfoBean.h"
#import "BrokerInfoBean.h"
#import "CommunityBean.h"
#import "CustomButton.h"
#import "XSAgreementViewController.h"
#import "FYUserDao.h"
#import "UIImage+Helper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "HouseWsImpl.h"
#import "ResultCode.h"

@interface XSApplyLookHouseViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sellerPayment;
@property (weak, nonatomic) IBOutlet UILabel *buyerPayment;
@property (weak, nonatomic) IBOutlet UILabel *commission;
@property (weak, nonatomic) IBOutlet UILabel *seller;
@property (weak, nonatomic) IBOutlet UILabel *buyer;
@property (weak, nonatomic) IBOutlet UILabel *houseId;
@property (weak, nonatomic) IBOutlet UILabel *community;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet CustomButton *submitButton;

@end

@implementation XSApplyLookHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
#pragma mark - 初始化view
-(void)setupView
{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [_submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    _seller.text=[NSString stringWithFormat:@"%@  %@",_broker.name,_broker.mobilephone];
    _buyer.text=[NSString stringWithFormat:@"%@  %@",user.name,user.mobilephone];
    _houseId.text=_houseInfo.houseId;
    
    
    if (_type==HouseTypeSell) {
        _community.text=[NSString stringWithFormat:@"%@ %@㎡ %@室%@厅 朝%@ %@ 售%@万",_communityString,_houseInfo.buildArea,_houseInfo.bedRooms,_houseInfo.livingRooms, [Tool towartWithTypeString:_houseInfo.toward], [Tool decorationStateWithType:_houseInfo.decorationState],_houseInfo.totalPrice];
    }else{
        _community.text=[NSString stringWithFormat:@"%@ %@㎡ %@室%@厅 朝%@ %@ 租%@元/月",_communityString,_houseInfo.buildArea,_houseInfo.bedRooms,_houseInfo.livingRooms, [Tool towartWithTypeString:_houseInfo.toward], [Tool decorationStateWithType:_houseInfo.decorationState],_houseInfo.totalPrice];
    }
    
    _sellerPayment.attributedText=[ViewUtil content:[NSString stringWithFormat:@"甲方按本次交易买卖双方佣金总额的%@%%,",_houseInfo.sellerDivided] colorString:[_houseInfo.sellerDivided stringByAppendingString:@"%"]];
    
    _buyerPayment.attributedText=[ViewUtil content:[NSString stringWithFormat:@"乙方按本次交易买卖双方佣金总额的%@%%",_houseInfo.buyerDivided] colorString:[_houseInfo.buyerDivided stringByAppendingString:@"%"]];
    
    _commission.attributedText=[Tool testcontent:[NSString stringWithFormat:@"(卖方支付%@%%,买方支付%@%%)",_houseInfo.leftCommission,_houseInfo.rightCommission] colorString:@[_houseInfo.leftCommission,_houseInfo.rightCommission,@"%"]];
}
#pragma mark - 点击同意协议事件
- (IBAction)agreeChange:(UIButton *)sender
{
    sender.selected=!sender.selected;
    _submitButton.enabled=sender.selected;
}
#pragma mark - 查看协议
- (IBAction)agreementClick:(UIButton *)sender{
    [self performSegueWithIdentifier:@"agreementController" sender:nil];
}

#pragma mark - 跳转页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"agreementController"]) {
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        
        XSAgreementViewController *agree=segue.destinationViewController;
        agree.sellerString=[NSString stringWithFormat:@"%@  %@(%@)",_broker.name,_broker.mobilephone,_broker.store];
        agree.buyerString=[NSString stringWithFormat:@"%@  %@",user.name,user.mobilephone];
    }
}
#pragma mark - 提交看房申请
- (IBAction)submit:(id)sender{
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws applyForCheckHouse:_houseInfo.houseId brokerId:user.brokerId sid:user.sid result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL success = YES;
        if (!isSuccess) {
            if ([data intValue] == SUCCESS) {
                [MBProgressHUD showMessag:@"提交成功!" toView:[KAPPDelegate window]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                success = NO;
            }
        }else{
            success = NO;
        }
        if (!success) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        }
    }];
}



@end
