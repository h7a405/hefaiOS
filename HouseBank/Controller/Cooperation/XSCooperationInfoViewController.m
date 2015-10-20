//
//  XSCooperationInfoViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-28.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSCooperationInfoViewController.h"
#import "XSCommentViewController.h"
#import "XSCooperationBean.h"
#import "XSComplainViewController.h"
#import "CustomButton.h"
#import "UIView+Extension.h"
#import "FYUserDao.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "CooperationWsImpl.h"

@interface XSCooperationInfoViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *applyTime;
@property (weak, nonatomic) IBOutlet UILabel *brokerInfoTow;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *houseId;
@property (weak, nonatomic) IBOutlet UILabel *houseInfo;
@property (weak, nonatomic) IBOutlet UILabel *commission;
@property (weak, nonatomic) IBOutlet UILabel *sellerPayment;
@property (weak, nonatomic) IBOutlet UILabel *buyerPayment;
@property (weak, nonatomic) IBOutlet CustomButton *commentButton;
@property (weak, nonatomic) IBOutlet CustomButton *complainButton;

@end

@implementation XSCooperationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    
}
#pragma mark - 初始化view
-(void)setupView{
    _scrollView.contentSize=_scrollView.frame.size;
    _scrollView.frame=self.view.bounds;
    _status.text=[Tool cooperationStatus:_cooperation.status];
    _applyTime.text= [TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[_cooperation.applyTime doubleValue]/1000] format:@"MM-dd HH:mm"];
    
    if ([_object isEqualToString:@"1"]) {
        _brokerInfoTow.text=_cooperation.brokerInfo;
        _storeName.text=_cooperation.storeNameOne;
    }else{
        _brokerInfoTow.text=_cooperation.brokerInfoTow;
        _storeName.text=_cooperation.storeNameTow;
    }
    [_icon sd_setImageWithURL:_cooperation.brokerHeaderImg placeholderImage:[UIImage imageNamed:@"nophoto"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _houseId.text=_cooperation.houseId;
    _houseInfo.text=_cooperation.houseInfo;
    [self plusHeightForAjdFrameWithLabel:_houseInfo];
    
    _sellerPayment.attributedText=[ViewUtil content:[NSString stringWithFormat:@"甲方按本次交易买卖双方佣金总额的%@%%,",_cooperation.sellerPayment] colorString:[_cooperation.sellerPayment stringByAppendingString:@"%"]];
    _buyerPayment.attributedText=[ViewUtil content:[NSString stringWithFormat:@"乙方按本次交易买卖双方佣金总额的%@%%",_cooperation.buyerPayment] colorString:[_cooperation.buyerPayment stringByAppendingString:@"%"]];
    
    _commission.attributedText=[Tool testcontent:[NSString stringWithFormat:@"(卖方支付%@%%,买方支付%@%%)",_cooperation.acceptComission,_cooperation.applyCommission] colorString:@[_cooperation.acceptComission,_cooperation.applyCommission,@"%"]];
    
    if([_cooperation.commentCounts integerValue]>=2||[_cooperation.status integerValue]==1){
        _commentButton.hidden=YES;
        _complainButton.center=CGPointMake(KWidth*0.5, _complainButton.y+_complainButton.height*0.5);
    }
}
#pragma mark - 调整高度
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

-(void)adjScrollView:(UIView *)view andPlusHeight:(CGFloat)plusHeight{
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
    _scrollView.contentSize=CGSizeMake(KWidth,_scrollView.contentSize.height+plusHeight);
}

#pragma mark - 跳转页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"complain"]) {
        XSComplainViewController *complain=segue.destinationViewController;
        complain.cooperation=_cooperation;
        complain.object=_object;
    }else if([segue.identifier isEqualToString:@"xscomment"]){
        XSCommentViewController *comment=segue.destinationViewController;
        comment.object=_object;
        comment.cooperation=_cooperation;
    }
}

#pragma mark - 状态切换
- (IBAction)statusChange:(id)sender{
    NSString *title1=nil;
    NSString *title2=nil;
    if ([_cooperation.status integerValue]==4||[_cooperation.status integerValue]==5) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"交易已经结束,不能编辑状态" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        
        return;
    }else if([_cooperation.status integerValue]==1){
        if([_object isEqualToString:@"1"]){
            return;
        }else{
            title1=@"接受";
            title2=@"拒绝";
        }
    }else if([_cooperation.status integerValue]==2){
        title1=@"已成交";
        title2=@"未成交";
    }else if([_cooperation.status integerValue]==3){
        return;
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择你要改变到的状态!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:title1,title2, nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }
    
    NSString *status=nil;
    if ([_object integerValue]==1&&buttonIndex==1) {//成交
        status=@"4";
    }else if ([_object integerValue]==1&&buttonIndex==2) {//未成交
        status=@"5";
    }else if ([_object integerValue]==2&&buttonIndex==1) {//接受
        status=@"2";
    }else if ([_object integerValue]==2&&buttonIndex==2) {//拒绝
        status=@"3";
    }
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    CooperationWsImpl *ws = [CooperationWsImpl new];
    [ws changeCooperationState:_cooperation.cooperationId sid:user.sid status:status result:^(BOOL isSuccess, id result, NSString *data) {
        if (!isSuccess) {
            if([data isEqualToString:@"0"]){
                [MBProgressHUD showMessag:@"状态修改成功!" toView:[KAPPDelegate window]];
                _cooperation.status=status;
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"状态修改失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }
        }
    }];
}

@end
