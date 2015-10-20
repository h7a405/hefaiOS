//
//  XSComplainViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSComplainViewController.h"
#import "UIView+Extension.h"
#import "XSCooperationBean.h"
#import "FYUserDao.h"
#import "NSString+Helper.h"
#import "UIImageView+WebCache.h"
#import "KeyboardToolView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "CooperationWsImpl.h"

@interface XSComplainViewController ()<UITextViewDelegate,KeyboardToolDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *houseInfo;
@property (weak, nonatomic) IBOutlet UILabel *brokerInfo;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation XSComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.layer.borderWidth=1;
    _textView.layer.borderColor=Color(249, 113, 13).CGColor;
    
    
    if ([_object isEqualToString:@"1"]) {
        _brokerInfo.text=_cooperation.brokerInfo;
        
    }else{
        _brokerInfo.text=_cooperation.brokerInfoTow;
        
    }
    _houseInfo.text=_cooperation.houseInfo;
    [_icon sd_setImageWithURL:_cooperation.brokerHeaderImg placeholderImage:[UIImage imageNamed:@"nophoto"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _status.text=[Tool cooperationStatus:_cooperation.status];
}
#pragma mark - textview delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    textView.inputAccessoryView=tool;
    tool.delegate=self;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view=obj;
            if(KHeight==480.0){
                view.y-=84;
            }else{
                view.y-=64;
            }
            
        }];
    }];
    
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view=obj;
            if(KHeight==480.0){
                view.y+=84;
            }else{
                view.y+=64;
            }
        }];
    }];
    return YES;
}
-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button
{
    [self.view endEditing:YES];
}
#pragma mark - 提交投诉
- (IBAction)submit:(id)sender{
    if([_textView.text isEmptyString]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请填写投诉内容后再按提交!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    
    [self.view endEditing:YES];
    NSString *targetBrokerId=nil;
    if([_object isEqualToString:@"1"]){
        targetBrokerId=_cooperation.acceptUserId;
    }else{
        targetBrokerId=_cooperation.applyUserId;
    }
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CooperationWsImpl *ws = [CooperationWsImpl new];
    [ws cooperationComplaint:_cooperation.cooperationId sid:user.sid content:_textView.text targetBrokerId:targetBrokerId result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSuccess) {
            if ([data isEqualToString:@"0"]) {
                [MBProgressHUD showMessag:@"投诉成功!" toView:[KAPPDelegate window]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showMessag:@"投诉失败!" toView:[KAPPDelegate window]];
            }
        }
    }];
}
@end
