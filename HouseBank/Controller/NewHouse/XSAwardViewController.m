//
//  XSAwardViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSAwardViewController.h"
#import "HouseInfoBGView.h"
#import "UIView+Extension.h"
#import "XSOrderApplyViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "FYCallHistoryDao.h"
#import "NewHouseWsImpl.h"

@interface XSAwardViewController ()
{
    NSString *_phoneNum;
}
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *brokerAward;
@property (weak, nonatomic) IBOutlet UILabel *brokerLinkman;
@property (weak, nonatomic) IBOutlet UILabel *brokerPhone;
@property (weak, nonatomic) IBOutlet HouseInfoBGView *userInfoView;

@end

@implementation XSAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectName.text=_projectNameString;
    [self getDataFormServer];
}
#pragma mark - 请求数据
-(void)getDataFormServer{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NewHouseWsImpl  *ws = [NewHouseWsImpl new];
    [ws requestAward:_projectId result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            _brokerLinkman.text=[result objectForKey:@"brokerLinkman"];
            _brokerPhone.text=[result objectForKey:@"brokerPhone"];
            _phoneNum=_brokerPhone.text;
            _brokerAward.text=[result objectForKey:@"brokerAward"];
            CGSize size=[TextUtil sizeWithContent:_brokerAward];
            if (size.height>_brokerAward.height) {
                _brokerAward.superview.height+=size.height-_brokerAward.height;
                _userInfoView.y+=size.height-_brokerAward.height;
                _brokerAward.size=size;
            }
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

#pragma mark - 打电话
- (IBAction)call:(id)sender{
    FYCallHistoryDao  *dao = [FYCallHistoryDao new];
    
    [dao saveCallHistoryWithHouseId:_projectId andHouseType:@"3"];
    [Tool callPhone:_phoneNum];
}

#pragma mark - 申请
- (IBAction)appleFor:(id)sender
{
    [self performSegueWithIdentifier:@"applyFor1" sender:_projectId];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"applyFor1"]) {
        XSOrderApplyViewController *order=segue.destinationViewController;
        order.projectId=sender;
    }
}
@end
