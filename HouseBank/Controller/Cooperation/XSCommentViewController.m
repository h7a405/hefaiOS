//
//  XSCommentViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSCommentViewController.h"
#import "XSCooperationBean.h"
#import "XSStarView.h"
#import "FYUserDao.h"
#import "NSString+Helper.h"
#import "UIImageView+WebCache.h"
#import "KeyboardToolView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "CooperationWsImpl.h"

@interface XSCommentViewController ()<UITextViewDelegate,KeyboardToolDelegate,XSStarViewDelegate>{
    XSStarView *_consistentStar;
    XSStarView *_serviceStar;
    
    NSInteger _consistentLevel;
    NSInteger _serviceLevel;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *applyTime;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *houseInfo;
@property (weak, nonatomic) IBOutlet UILabel *brokerInfo;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet  UIView *consistentLevelView;
@property (weak, nonatomic) IBOutlet UIView *serviceLevelView;
@property (weak, nonatomic) IBOutlet UILabel *tishi;

@end

@implementation XSCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
#pragma mark - 初始化
-(void)setupView
{
    _textView.layer.borderWidth=1;
    _textView.layer.borderColor=Color(249, 113, 13).CGColor;
    _textView.backgroundColor=[UIColor whiteColor];
    
    _houseInfo.text=_cooperation.houseInfo;
    if ([_object isEqualToString:@"1"]) {
        _brokerInfo.text=_cooperation.brokerInfo;
    }else{
        _brokerInfo.text=_cooperation.brokerInfoTow;
    }
    [_icon sd_setImageWithURL:_cooperation.brokerHeaderImg placeholderImage:[UIImage imageNamed:@"nophoto"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _status.text=[Tool cooperationStatus:_cooperation.status];
    
    _consistentStar=[[XSStarView alloc]init];
    _consistentStar.delegate=self;
    [_consistentLevelView addSubview:_consistentStar];
    _serviceStar=[[XSStarView alloc]init];
    _serviceStar.delegate=self;
    [_serviceLevelView addSubview:_serviceStar];
}

#pragma mark - textview delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    textView.inputAccessoryView=tool;
    tool.delegate=self;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEmptyString]) {
        _tishi.hidden=NO;
    }else{
        _tishi.hidden=YES;
    }
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button
{
    [self.view endEditing:YES];
}

-(void)starView:(XSStarView *)view DidChangeLevel:(NSInteger)level
{
    if (view==_serviceStar) {
        _serviceLevel=level;
    }else{
        _consistentLevel=level;
    }
}

#pragma mark - 提交评分
- (IBAction)submit:(id)sender{
    if ([self check]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        
        CooperationWsImpl *ws = [CooperationWsImpl new];
        [ws submitCooperationScore:_cooperation.cooperationId sid:user.sid content:_textView.text consistentLevel:_consistentLevel serviceLevel:_serviceLevel result:^(BOOL isSuccess, id result, NSString *data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!isSuccess) {
                if ([data isEqualToString:@"0"]) {
                    [MBProgressHUD showMessag:@"评论成功!" toView:[KAPPDelegate window]];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"评论失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                }
            }
        }];
    }
}

-(BOOL)check
{
    if(_consistentLevel==0){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择房源与描述相符评分后再提交!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return NO;
    }else if (_serviceLevel==0){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择合作经纪人态度评分后再提交!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return NO;
    }else if ([_textView.text isEmptyString]){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写评论后再提交!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return NO;
    }
    
    
    return YES;
}

@end
