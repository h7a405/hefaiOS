//
//  XSCommissionViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSCommissionViewController.h"
#import "XSOrderApplyViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "FYCallHistoryDao.h"
#import "NewHouseWsImpl.h"

@interface XSCommissionViewController ()
{
    NSString *_phoneNum;
}
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *commissionPaynode;
@property (weak, nonatomic) IBOutlet UILabel *commissionRate;
@property (weak, nonatomic) IBOutlet UILabel *commissionRule;
@property (weak, nonatomic) IBOutlet UILabel *auditProcess;
@property (weak, nonatomic) IBOutlet UILabel *remind;
@property (weak, nonatomic) IBOutlet UILabel *brokerLinkman;
@property (weak, nonatomic) IBOutlet UILabel *brokerPhone;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation XSCommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectName.text=_projectNameString;
    [self getDataFormServer];
}

#pragma mark - 请求数据
-(void)getDataFormServer{
    NewHouseWsImpl *ws = [NewHouseWsImpl new];
    [ws requestAward:_projectId result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            _brokerLinkman.text=[result objectForKey:@"brokerLinkman"];
            _brokerPhone.text=[result objectForKey:@"brokerPhone"];
            _phoneNum=_brokerPhone.text;
            _commissionPaynode.text=[result objectForKey:@"commissionPaynode"];
            _commissionRate.text=[result objectForKey:@"commissionRate"];
            _commissionRule.text=[result objectForKey:@"commissionRule"];
            [self plusHeightForAjdFrameWithLabel:_commissionRule];
            _auditProcess.text=[result objectForKey:@"auditProcess"];
            [self plusHeightForAjdFrameWithLabel:_auditProcess];
            _remind.text=[result objectForKey:@"remind"];
            [self plusHeightForAjdFrameWithLabel:_remind];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

#pragma mark - 点击申请
- (IBAction)applyClick:(id)sender
{
    [self performSegueWithIdentifier:@"applyFor2" sender:_projectId];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"applyFor2"]) {
        XSOrderApplyViewController *order=segue.destinationViewController;
        order.projectId=sender;
        
    }
}
#pragma mark - 调整UI
-(void)plusHeightForAjdFrameWithLabel:(UILabel *)label{
    NSDictionary *dict=@{NSFontAttributeName: label.font};
    CGSize size=[label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    if (size.height<label.frame.size.height) {
        return;
    }
    CGFloat plusHeight=size.height-label.frame.size.height;
    NSInteger index=[label.superview.subviews indexOfObject:label];
    
    for (int i =index; i<label.superview.subviews.count; i++) {
        UIView *view=label.superview.subviews[i];
        CGRect frame=view.frame;
        if (i==index) {
            frame.size.height=size.height;
        }else{
            frame.origin.y+=plusHeight;
            
        }
        view.frame=frame;
    }
    [self adjScrollView:label.superview andPlusHeight:plusHeight];
    
}
-(void)adjScrollView:(UIView *)view andPlusHeight:(CGFloat)plusHeight
{
    NSInteger index=[_scrollView.subviews indexOfObject:view];
    for (int i=index; i<_scrollView.subviews.count; i++) {
        UIView *view=_scrollView.subviews[i];
        CGRect frame=view.frame;
        if (i==index) {
            frame.size.height+=plusHeight;
        }else{
            frame.origin.y+=plusHeight;
        }
        view.frame=frame;
    }
    _scrollView.contentSize=CGSizeMake(KWidth,CGRectGetMaxY([[_scrollView.subviews lastObject] frame]));
}
#pragma mark - 打电话
- (IBAction)call:(id)sender{
    FYCallHistoryDao  *dao = [FYCallHistoryDao new];
    [dao saveCallHistoryWithHouseId:_projectId andHouseType:@"3"];
    
    [Tool callPhone:_phoneNum];
}

@end
