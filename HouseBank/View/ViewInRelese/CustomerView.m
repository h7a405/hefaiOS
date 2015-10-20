//
//  CustomerView.m
//  客需
//
//  Created by JunJun on 14/12/29.
//  Copyright (c) 2014年 JunJun. All rights reserved.
//

#import "CustomerView.h"
#import "CRMBasicFactory.h"
#import "UIViewExt.h"
#import "CRMSexView.h"
#import "CustomerModel.h"
#import "HouseSelectView.h"
//
#import "XSSubscibeViewController.h"
#import "SelectPrice.h"
#import "XSSubscibeListViewController.h"
#import "FYUserDao.h"
#import "AFNetworking.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "SubscibeWsImpl.h"
#import "MBProgressHUD+Add.h"
#import "HouseBank-Swift.h"
#import "SuiDataService.h"
#import "UIView+Addition.h"
#import "SuiDataService.h"
#include <stdio.h>
#import "FYUserDao.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface CustomerView ()<SelectViewDelegation>{
    UIView *_currentFirstView ;
    int _currentFastBtn ;
}

@end

@implementation CustomerView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.customerModel = [[CustomerModel alloc] init];
        self.streesId1 = @"";
        self.streesId2 = @"";
        self.streesId3 = @"";
        self.streesId4 = @"";
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    self.cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"];
    self.cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.delegate = self;
    bgScrollView.contentSize = CGSizeMake(kScreenWidth, 2*kScreenHeight - 40);
    [self addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor clearColor];
    self.bgScroV = bgScrollView;
    
    jiaoylabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, 15, kScreenWidth/4, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"交易类型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:jiaoylabel];
    
    __block CustomerView *blockSelf = self;
    CRMSexView *sexView = [[CRMSexView alloc] initWithFrame:CGRectMake(jiaoylabel.right, 15, kScreenWidth/1.2, kScreenWidth/4/3) withSex:0 withGenderBlock:^(int index, NSString *male) {
        blockSelf.customerModel.tradeType = [NSNumber numberWithInteger:index+1];
    }];
    sexView.backgroundColor = [UIColor clearColor];
    sexView.userInteractionEnabled = YES;
    blockSelf.customerModel.tradeType = [NSNumber numberWithInteger:1];
    
    [_bgScroV addSubview:sexView];
    UILabel *ytLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, jiaoylabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"用途" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:ytLabel];
    int width ;
    if (kScreenWidth == 414) {
        width = 250;
    }else if(kScreenWidth == 375){
        width = 220;
    }else{
        width = 180;
    }
    
    NSArray *ytArr = @[@"住宅",@"写字楼",@"商铺"];
    ytView = [[VWSelectedView alloc] initWithFrame:CGRectMake(ytLabel.right, ytLabel.top, width, jiaoylabel.height) withItems:ytArr withBlock:^(NSInteger index, NSString *title) {
        NSInteger num = index+1;
        blockSelf.customerModel.purpose = [NSNumber numberWithInteger:num];
    } withPlaceholderText:@"住宅"];
    _customerModel.purpose = [NSNumber numberWithInteger:1];
    
    UILabel *qwLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, ytLabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望版块" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:qwLabel];
    bottombtn1 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(qwLabel.right, qwLabel.top, width, jiaoylabel.height) title:@"请点击选择城市板块" titleColor:[UIColor grayColor] target:self action:nil];
    bottombtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:bottombtn1];
    
    _btn1 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, width, jiaoylabel.height) title:nil titleColor:[UIColor grayColor] target:self action:@selector(djAction1)];
    _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottombtn1 addSubview:_btn1];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(bottombtn1.left, bottombtn1.bottom, bottombtn1.width, 0.5)];
    view1.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:view1];
    
    bottombtn2 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(qwLabel.right, qwLabel.top+jiaoylabel.height+12, width, jiaoylabel.height) title:@"请点击选择城市板块2" titleColor:[UIColor grayColor] target:self action:nil];
    bottombtn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:bottombtn2];
    _btn2 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, width, jiaoylabel.height) title:nil titleColor:[UIColor grayColor] target:self action:@selector(djAction2)];
    _btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottombtn2 addSubview:_btn2];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(bottombtn2.left, bottombtn2.bottom, bottombtn2.width, 0.5)];
    view2.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:view2];
    
    bottombtn3 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(qwLabel.right, qwLabel.top+2*(jiaoylabel.height+12), width, jiaoylabel.height) title:@"请点击选择城市板块3" titleColor:[UIColor grayColor] target:self action:nil];
    bottombtn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:bottombtn3];
    _btn3 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, width, jiaoylabel.height) title:nil titleColor:[UIColor grayColor] target:self action:@selector(djAction3)];
    _btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottombtn3 addSubview:_btn3];
    _btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(bottombtn3.left, bottombtn3.bottom, bottombtn3.width, 0.5)];
    view3.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:view3];
    
    bottombtn4 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(qwLabel.right, qwLabel.top+3*(jiaoylabel.height+12), width, jiaoylabel.height) title:@"请点击选择城市板块4" titleColor:[UIColor grayColor] target:self action:nil];
    bottombtn4.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:bottombtn4];
    _btn4 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, width, jiaoylabel.height) title:nil titleColor:[UIColor grayColor] target:self action:@selector(djAction4)];
    _btn4.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottombtn4 addSubview:_btn4];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(bottombtn4.left, bottombtn4.bottom, bottombtn4.width, 0.5)];
    view4.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:view4];
    
    [_bgScroV addSubview:ytView];
    UILabel *xqLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, bottombtn4.bottom+14, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望小区" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:xqLabel];
    
    textField1 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(xqLabel.right, xqLabel.top+5, kScreenWidth/2.3, jiaoylabel.height) font:[UIFont systemFontOfSize:14] text:@"请输入关键字" textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor whiteColor]];
    textField1.delegate = self;
    [_bgScroV addSubview:textField1];
    UIView *_view1 = [[UIView alloc] initWithFrame:CGRectMake(0, xqLabel.bottom, kScreenWidth, 0.5)];
    _view1.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_view1];
    textField2 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(xqLabel.right, xqLabel.top+jiaoylabel.height+12+5, kScreenWidth/2.3, jiaoylabel.height) font:[UIFont systemFontOfSize:14] text:@"请输入关键字" textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor whiteColor]];
    textField2.delegate = self;
    [_bgScroV addSubview:textField2];
    UIView *_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, textField2.bottom, kScreenWidth, 0.5)];
    _view2.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_view2];
    textField3 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(xqLabel.right, xqLabel.top+2*(jiaoylabel.height+12)+5, kScreenWidth/2.3, jiaoylabel.height) font:[UIFont systemFontOfSize:14] text:@"请输入关键字" textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor whiteColor]];
    textField3.delegate = self;
    [_bgScroV addSubview:textField3];
    UIView *_view3 = [[UIView alloc] initWithFrame:CGRectMake(0, textField3.bottom, kScreenWidth, 0.5)];
    _view3.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_view3];
    textField4 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(xqLabel.right, xqLabel.top+3*(jiaoylabel.height+12)+5, kScreenWidth/2.3, jiaoylabel.height) font:[UIFont systemFontOfSize:14] text:@"请输入关键字" textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor whiteColor]];
    textField4.delegate = self;
    [_bgScroV addSubview:textField4];
    UIView *_view4 = [[UIView alloc] initWithFrame:CGRectMake(0, textField4.bottom, kScreenWidth, 0.5)];
    _view4.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_view4];
    
    
    //快速选择
    UIButton *button1 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(textField1.right, xqLabel.top, kScreenWidth/3.8, xqLabel.height) title:@"快速选择" titleColor:[UIColor orangeColor] target:self action:@selector(button1Action)];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgScroV addSubview:button1];
    UIButton *button2 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(textField1.right, xqLabel.top+xqLabel.height+12, kScreenWidth/3.8, xqLabel.height) title:@"快速选择" titleColor:[UIColor orangeColor] target:self action:@selector(button2Action)];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgScroV addSubview:button2];
    UIButton *button3 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(textField1.right, xqLabel.top+2*(xqLabel.height+12), kScreenWidth/3.8, xqLabel.height) title:@"快速选择" titleColor:[UIColor orangeColor] target:self action:@selector(button3Action)];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgScroV addSubview:button3];
    UIButton *button4 = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(textField1.right, xqLabel.top+3*(xqLabel.height+12), kScreenWidth/3.8, xqLabel.height) title:@"快速选择" titleColor:[UIColor orangeColor] target:self action:@selector(button4Action)];
    button4.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgScroV addSubview:button4];
    UILabel *jgLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, button4.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"价格范围" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:jgLabel];
    UITextField *jgtextfield1 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(jgLabel.right, jgLabel.top, width/3, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    jgtextfield1.tag = 10;
    jgtextfield1.delegate = self;
    jgtextfield1.placeholder = @"必填";
    jgtextfield1.keyboardType = UIKeyboardTypeNumberPad;
    [jgtextfield1 addTarget:self action:@selector(didTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgScroV addSubview:jgtextfield1];
    UIView *jgView = [[UIView alloc] initWithFrame:CGRectMake(jgtextfield1.left, jgtextfield1.bottom, jgtextfield1.width, 0.5)];
    jgView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:jgView];
    UILabel *jgLabel1 = [CRMBasicFactory createLableWithFrame:CGRectMake(jgtextfield1.right+5, jgLabel.top, jgtextfield1.width/2.5, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@" 至" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:jgLabel1];
    UITextField *jgtextfield2 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(jgLabel1.right, jgLabel1.top, width/3, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    jgtextfield2.tag = 20;
    jgtextfield2.delegate = self;
    jgtextfield2.placeholder = @"必填";
    jgtextfield2.keyboardType = UIKeyboardTypeNumberPad;
    [jgtextfield2 addTarget:self action:@selector(didTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgScroV addSubview:jgtextfield2];
    UIView *_jgView = [[UIView alloc] initWithFrame:CGRectMake(jgtextfield2.left, jgtextfield2.bottom, jgtextfield2.width, 0.5)];
    _jgView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_jgView];
    
    UILabel *jgLabel2 = [CRMBasicFactory createLableWithFrame:CGRectMake(jgtextfield2.right+5, jgtextfield2.top, jgtextfield1.width/1.5, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"万元" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:jgLabel2];
    
    UILabel *mjLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, jgtextfield1.bottom+12,jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"面积范围" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:mjLabel];
    UITextField *mjtextfield1 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(mjLabel.right, mjLabel.top+8, width/3, kScreenWidth/4/3-8) font:[UIFont systemFontOfSize:16] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mjtextfield1.tag = 30;
    mjtextfield1.delegate = self;
    mjtextfield1.placeholder = @"必填";
    mjtextfield1.keyboardType = UIKeyboardTypeNumberPad;
    [mjtextfield1 addTarget:self action:@selector(didTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgScroV addSubview:mjtextfield1];
    UIView *mjView = [[UIView alloc] initWithFrame:CGRectMake(mjtextfield1.left, mjtextfield1.bottom, mjtextfield1.width, 0.5)];
    mjView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:mjView];
    UILabel *mjLabel1 = [CRMBasicFactory createLableWithFrame:CGRectMake(mjtextfield1.right+5, mjtextfield1.top, mjtextfield1.width/2.5, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@" 至" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:mjLabel1];
    UITextField *mjtextfield2 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(mjLabel1.right, mjLabel1.top, width/3, kScreenWidth/4/3-8) font:[UIFont systemFontOfSize:16] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mjtextfield2.tag = 40;
    mjtextfield2.delegate = self;
    mjtextfield2.placeholder = @"必填";
    mjtextfield2.keyboardType = UIKeyboardTypeNumberPad;
    [mjtextfield2 addTarget:self action:@selector(didTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgScroV addSubview:mjtextfield2];
    UIView *_mjView = [[UIView alloc] initWithFrame:CGRectMake(mjtextfield2.left, mjtextfield2.bottom, mjtextfield2.width, 0.5)];
    _mjView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_mjView];
    UILabel *mjLabel2 = [CRMBasicFactory createLableWithFrame:CGRectMake(mjtextfield2.right+5, mjtextfield2.top, jgtextfield1.width/1.5, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"平米" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:mjLabel2];
    
    UILabel *zxLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, mjLabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望装修" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    zxBtn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(zxLabel.right, zxLabel.top, width, jiaoylabel.height) title:@"请点击选择期望装修" titleColor:[UIColor blackColor] target:self action:@selector(zxAction)];
    zxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:zxBtn];
    UIView *zxxView = [[UIView alloc] initWithFrame:CGRectMake(zxBtn.left, zxBtn.bottom, zxBtn.width, 0.5)];
    zxxView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:zxxView];
    UILabel *hxLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, zxLabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望户型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    hxBtn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(hxLabel.right, hxLabel.top, width, jiaoylabel.height) title:@"请点击选择期望户型" titleColor:[UIColor blackColor] target:self action:@selector(hxAction)];
    hxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:hxBtn];
    UIView *hxxView = [[UIView alloc] initWithFrame:CGRectMake(hxBtn.left, hxBtn.bottom, hxBtn.width, 0.5)];
    hxxView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:hxxView];
    UILabel *cxLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, hxLabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望朝向" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    cxBtn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(cxLabel.right, cxLabel.top, width, jiaoylabel.height) title:@"请点击选择期望朝向" titleColor:[UIColor blackColor] target:self action:@selector(cxAction)];
    cxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:cxBtn];
    UIView *cxxView = [[UIView alloc] initWithFrame:CGRectMake(cxBtn.left, cxBtn.bottom, cxBtn.width, 0.5)];
    cxxView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:cxxView];
    UILabel *lxLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, cxLabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望楼型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    lxBtn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(lxLabel.right, lxLabel.top, width, jiaoylabel.height) title:@"请点击选择期望楼型" titleColor:[UIColor blackColor] target:self action:@selector(lxAction)];
    lxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgScroV addSubview:lxBtn];
    UIView *lxxView = [[UIView alloc] initWithFrame:CGRectMake(lxBtn.left, lxBtn.bottom, lxBtn.width, 0.5)];
    lxxView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:lxxView];
    
    UILabel *lcLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, lxLabel.bottom+12, jiaoylabel.width, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"期望楼层" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:lcLabel];
    UITextField *lctextfield1 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(lcLabel.right, lcLabel.top, width/3, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    // lctextfield1.tag = 10;
    lctextfield1.delegate = self;
    lctextfield1.tag = 50;
    lctextfield1.placeholder = @"必填";
    lctextfield1.keyboardType = UIKeyboardTypeNumberPad;
    [lctextfield1 addTarget:self action:@selector(didTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgScroV addSubview:lctextfield1];
    UIView *lcView = [[UIView alloc] initWithFrame:CGRectMake(lctextfield1.left, lctextfield1.bottom, jgtextfield1.width, 0.5)];
    lcView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:lcView];
    UILabel *lcLabel1 = [CRMBasicFactory createLableWithFrame:CGRectMake(lctextfield1.right+5, lctextfield1.top, lctextfield1.width/2.5, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@" 至" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:lcLabel1];
    UITextField *lctextfield2 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(lcLabel1.right, lcLabel1.top, width/3, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    // jgtextfield2.tag = 20;
    lctextfield2.delegate = self;
    lctextfield2.tag = 60;
    lctextfield2.placeholder = @"必填";
    lctextfield2.keyboardType = UIKeyboardTypeNumberPad;
    [lctextfield2 addTarget:self action:@selector(didTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgScroV addSubview:lctextfield2];
    UIView *_lcView = [[UIView alloc] initWithFrame:CGRectMake(lctextfield2.left, lctextfield2.bottom, lctextfield2.width, 0.5)];
    _lcView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:_lcView];
    
    UILabel *lcLabel2 = [CRMBasicFactory createLableWithFrame:CGRectMake(lctextfield2.right+5, lctextfield2.top, lctextfield1.width/1.5, kScreenWidth/4/3) font:[UIFont systemFontOfSize:16] text:@"层" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:lcLabel2];
    
    UILabel *bzlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(lcLabel.left,lcLabel.bottom+12,80,lcLabel.height) font:[UIFont systemFontOfSize:15] text:@"备注" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    if (msTextView == nil) {
        msTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, bzlabel.bottom+2,kScreenWidth - 40, 140)];
        msTextView.backgroundColor = [UIColor whiteColor];
        msTextView.font = [UIFont systemFontOfSize:14];
        msTextView.layer.cornerRadius = 3.f;
        msTextView.layer.masksToBounds = YES;
        msTextView.layer.borderWidth = 0.5;
        msTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        msTextView.delegate = self;
        [_bgScroV addSubview:msTextView];
    }else{
        msTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(lxLabel.left, bzlabel.bottom+2,kScreenWidth*0.9, 140)];
    }
    
    msTextView.placeholder = @"例如：产权情况，居住环境，周边配套，交通情况。";
    
    [_bgScroV addSubview:bzlabel];
    [_bgScroV addSubview:lxLabel];
    [_bgScroV addSubview:lxView];
    [_bgScroV addSubview:cxLabel];
    [_bgScroV addSubview:cxView];
    [_bgScroV addSubview:hxLabel];
    [_bgScroV addSubview:hxView];
    [_bgScroV addSubview:zxLabel];
    [_bgScroV addSubview:zxView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(lxLabel.left, msTextView.bottom+20, kScreenWidth*0.9, 0.5)];
    view.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:view];
    
    UILabel *topLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, view.bottom+15,220, 30) font:[UIFont systemFontOfSize:16] text:@"以下信息默认自己可见  ：" textColor:[UIColor blueColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:topLabel];
    
    UILabel *nameLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, topLabel.bottom+8,85, lxLabel.height) font:[UIFont systemFontOfSize:16] text:@"业主姓名 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:nameLabel];
    UITextField *nameTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(nameLabel.right, nameLabel.top, kScreenWidth*0.65, lxLabel.height) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    nameTextfield.delegate = self;
    nameTextfield.tag = 70;
    nameTextfield.placeholder = @"必填，2-16个字符";
    [_bgScroV addSubview:nameTextfield];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(nameTextfield.left, nameTextfield.bottom, nameTextfield.width, 0.5)];
    nameView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:nameView];
    
    UILabel *bottomLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(10, nameLabel.bottom+15,85, lxLabel.height) font:[UIFont systemFontOfSize:16] text:@"业主手机 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_bgScroV addSubview:bottomLabel ];
    UITextField *mobileTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(bottomLabel.right, bottomLabel.top, kScreenWidth*0.65,lxLabel.height) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mobileTextfield.delegate = self;
    mobileTextfield.tag = 80;
    mobileTextfield.placeholder = @"必填";
    mobileTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [_bgScroV addSubview:mobileTextfield];
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(mobileTextfield.left, mobileTextfield.bottom, mobileTextfield.width, 0.5)];
    mobileView.backgroundColor = [UIColor blackColor];
    [_bgScroV addSubview:mobileView];
    UIButton *button = [CRMBasicFactory createButtonWithType:UIButtonTypeRoundedRect frame:CGRectMake(20,bottomLabel.bottom+20, kScreenWidth - 40, 40) title:@"提交" titleColor:[UIColor blackColor] target:self action:@selector(postNeedAction)];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgScroV addSubview:button];
}

//textView占位字符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        _label1.hidden = YES;
        
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _label1.hidden = NO;
        
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)buttonAction
{
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 20 || textField.tag == 10|| textField.tag == 30|| textField.tag == 40|| textField.tag == 50|| textField.tag == 60|| textField.tag == 80) {
        NSRange range = [textField.text rangeOfString:@"."];
        NSRange replaceRange = [string rangeOfString:@"."];
        if (range.location != NSNotFound && replaceRange.location!=NSNotFound) {
            return NO;
        }
        
        return [TextUtil isNumbel:string];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 10://面积范围从
        {
            _customerModel.areaFrom = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 20://面积范围到
        {
            _customerModel.area_to = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 30://售价/租金范围从
        {
            _customerModel.priceFrom = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
        case 40://售价/租金范围到
        {
            _customerModel.priceTo = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 50://
        {
            _customerModel.houseFloorFrom = [NSNumber numberWithInteger:[textField.text integerValue]];
        }
            break;
        case 60://
        {
            _customerModel.houseFloorTo = [NSNumber numberWithInteger:[textField.text integerValue]];
        }
            break;
        case 70://业主姓名
        {
            _customerModel.customerName = textField.text;
        }
            break;
        case 80://业主电话
        {
            _customerModel.customerMobilephone = textField.text;
        }
            break;
            
        default:
            break;
    }
    
    
    return YES;
}

-(void) didTextFieldTextChange : (UITextField *) textField{
    switch (textField.tag) {
        case 10:
        case 20:
        case 30:
        case 40:
            if (textField.text.integerValue > 99999) {
                textField.text = @"99999";
            }
            break;
        case 50:
        case 60:
            if (textField.text.integerValue > MaxFloor) {
                textField.text = [NSString stringWithFormat:@"%d",MaxFloor];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - tableview data source and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font=[UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14.f];
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        cell.selectedBackgroundView=view;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text=@" ";
    }
    cell.detailTextLabel.text = @"请点击选择城市板块";
    if (_data.count>0) {
        cell.detailTextLabel.text = @"";
        cell.detailTextLabel.text=_data[indexPath.row];
    }
    
    return cell;
}

- (void)djAction1{
    bottombtn1.titleLabel.text = nil;
    _currentButton = 1;
    [self showSelectTypeView:AddressLevelArea];
}

- (void)djAction2{
    bottombtn2.titleLabel.text = nil;
    _currentButton = 2;
    [self showSelectTypeView:AddressLevelArea];
}

- (void)djAction3{
    bottombtn3.titleLabel.text = nil;
    _currentButton = 3;
    [self showSelectTypeView:AddressLevelArea];
}

- (void)djAction4{
    bottombtn4.titleLabel.text = nil;
    _currentButton = 4;
    [self showSelectTypeView:AddressLevelArea];
}
#pragma mark - 显示选择地理位置
-(void)showSelectTypeView:(AddressLevel)level
{
    if (_currentButton == 1) {
        SelectTypeView *view=[[SelectTypeView alloc]init];
        
        [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
        view.delegate=self;
        NSMutableArray *tmp = [NSMutableArray array];
        _level=level;
        if (level==AddressLevelProvince) {
            _provience1 =[Address getAllProvience];
            
            [_provience1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择省份"];
        }else if (level==AddressLevelCity){
            
            view.data = _area1;
            [_city1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择城市"];
        }else if (level==AddressLevelArea){
            _area1 =[Address addressDataWithPid:_cityId];
            [_area1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择区域"];
        }else if (level==AddressLevelStreet){
            //_strees =[Address _areasWithCity:_cityId];
            
            [_strees1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择版块"];
        }
        view.data=tmp;
    }else if(_currentButton ==2){
        SelectTypeView *view=[[SelectTypeView alloc]init];
        
        [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
        view.delegate=self;
        NSMutableArray *tmp = [NSMutableArray array];
        _level=level;
        if (level==AddressLevelProvince) {
            _provience2 =[Address getAllProvience];
            
            [_provience2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择省份"];
        }else if (level==AddressLevelCity){
            
            view.data = _area2;
            [_city2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择城市"];
        }else if (level==AddressLevelArea){
            _area2 =[Address addressDataWithPid:_cityId];
            [_area2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择区域"];
        }else if (level==AddressLevelStreet){
            //_strees =[Address _areasWithCity:_cityId];
            
            [_strees2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择版块"];
        }
        view.data=tmp;
    }else if(_currentButton == 3){
        SelectTypeView *view=[[SelectTypeView alloc]init];
        
        [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
        view.delegate=self;
        NSMutableArray *tmp = [NSMutableArray array];
        _level=level;
        if (level==AddressLevelProvince) {
            _provience3 =[Address getAllProvience];
            
            [_provience3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择省份"];
        }else if (level==AddressLevelCity){
            
            view.data = _area3;
            [_city3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择城市"];
        }else if (level==AddressLevelArea){
            _area3 =[Address addressDataWithPid:_cityId];
            [_area3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择区域"];
        }else if (level==AddressLevelStreet){
            //_strees =[Address _areasWithCity:_cityId];
            
            [_strees3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择版块"];
        }
        view.data=tmp;
    }else if(_currentButton == 4){
        SelectTypeView *view=[[SelectTypeView alloc]init];
        
        [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
        view.delegate=self;
        NSMutableArray *tmp = [NSMutableArray array];
        _level=level;
        if (level==AddressLevelProvince) {
            _provience4 =[Address getAllProvience];
            
            [_provience4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择省份"];
        }else if (level==AddressLevelCity){
            
            view.data = _area4;
            [_city4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                [tmp addObject:address.name];
                
            }];
            [view showWithTitle:@"请选择城市"];
        }else if (level==AddressLevelArea){
            _area4 =[Address addressDataWithPid:_cityId];
            [_area4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择区域"];
        }else if (level==AddressLevelStreet){
            //_strees =[Address _areasWithCity:_cityId];
            
            [_strees4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Address *address=obj;
                
                [tmp addObject:address.name];
            }];
            [view showWithTitle:@"请选择版块"];
        }
        view.data=tmp;
    }
}
#pragma mark - 选择地区
-(void)typeView:(SelectTypeView *)view didSelect:(NSString *)str selectIndex:(NSInteger)index
{
    if(_currentButton == 1){
        if (_level==AddressLevelArea) {
            _addressInfo=str;
        }else{
            _addressInfo= [_addressInfo stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
        }
        _btn1.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_btn1 setTitle:[[_cityName stringByAppendingString:@"  "] stringByAppendingString:_addressInfo] forState:UIControlStateNormal];
        
        if (_level==AddressLevelProvince) {
            _city1=[Address citysWithProvience:_provience1[index]];
            Address *address=_city1[0];
            
            if (_city1.count==1&&[str isEqualToString:address.name]) {
                _cityId1=[NSString stringWithFormat:@"%@",[_city1[0] tid]];
                _area1=[Address areasWithCity:_city1[0]];
                [self showSelectTypeView:AddressLevelArea];
            }else{
                [self showSelectTypeView:AddressLevelCity];
            }
        }else if (_level==AddressLevelCity){
            // _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
            _area1 =[Address addressDataWithPid:_cityId];
            [self showSelectTypeView:AddressLevelArea];
        }else if (_level==AddressLevelArea){
            self.areaId1 =[NSString stringWithFormat:@"%@",[_area1[index] tid]];
            _strees1 =[Address streesWithArea:_area1[index]];
            [self showSelectTypeView:AddressLevelStreet];
        }else{
            self.streesId1 =[NSString stringWithFormat:@"%@",[_strees1[index] tid]];
        }
    }else if(_currentButton ==2){
        if (_level==AddressLevelArea) {
            _addressInfo=str;
        }else{
            _addressInfo= [_addressInfo stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
        }
        _btn2.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_btn2 setTitle:[[_cityName stringByAppendingString:@"  "] stringByAppendingString:_addressInfo] forState:UIControlStateNormal];
        
        if (_level==AddressLevelProvince) {
            _city2 =[Address citysWithProvience:_provience2[index]];
            Address *address=_city2[0];
            
            if (_city2.count==1&&[str isEqualToString:address.name]) {
                self.cityId2 =[NSString stringWithFormat:@"%@",[_city2[0] tid]];
                _area2 =[Address areasWithCity:_city2[0]];
                [self showSelectTypeView:AddressLevelArea];
            }else{
                [self showSelectTypeView:AddressLevelCity];
            }
        }else if (_level==AddressLevelCity){
            // _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
            _area2 =[Address addressDataWithPid:_cityId];
            [self showSelectTypeView:AddressLevelArea];
        }else if (_level==AddressLevelArea){
            self.areaId2 =[NSString stringWithFormat:@"%@",[_area2[index] tid]];
            _strees2 =[Address streesWithArea:_area2[index]];
            [self showSelectTypeView:AddressLevelStreet];
        }else{
            self.streesId2 =[NSString stringWithFormat:@"%@",[_strees2[index] tid]];
        }
    }else if(_currentButton == 3){
        if (_level==AddressLevelArea) {
            _addressInfo=str;
        }else{
            _addressInfo= [_addressInfo stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
        }
        _btn3.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_btn3 setTitle:[[_cityName stringByAppendingString:@"  "] stringByAppendingString:_addressInfo] forState:UIControlStateNormal];
        
        if (_level==AddressLevelProvince) {
            _city3 =[Address citysWithProvience:_provience3[index]];
            Address *address=_city3[0];
            
            if (_city3.count==1&&[str isEqualToString:address.name]) {
                self.cityId3 =[NSString stringWithFormat:@"%@",[_city3[0] tid]];
                _area3 =[Address areasWithCity:_city3[0]];
                [self showSelectTypeView:AddressLevelArea];
            }else{
                [self showSelectTypeView:AddressLevelCity];
            }
        }else if (_level==AddressLevelCity){
            // _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
            _area3 =[Address addressDataWithPid:_cityId];
            [self showSelectTypeView:AddressLevelArea];
        }else if (_level==AddressLevelArea){
            self.areaId3 =[NSString stringWithFormat:@"%@",[_area3[index] tid]];
            _strees3 =[Address streesWithArea:_area3[index]];
            [self showSelectTypeView:AddressLevelStreet];
        }else{
            self.streesId3 =[NSString stringWithFormat:@"%@",[_strees3[index] tid]];
        }
    }else if(_currentButton == 4){
        if (_level==AddressLevelArea) {
            _addressInfo=str;
        }else{
            _addressInfo= [_addressInfo stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
        }
        _btn4.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_btn4 setTitle:[[_cityName stringByAppendingString:@"  "] stringByAppendingString:_addressInfo] forState:UIControlStateNormal];
        
        if (_level==AddressLevelProvince) {
            _city4 =[Address citysWithProvience:_provience4[index]];
            Address *address=_city4[0];
            
            if (_city4.count==1&&[str isEqualToString:address.name]) {
                self.cityId4 =[NSString stringWithFormat:@"%@",[_city4[0] tid]];
                _area4=[Address areasWithCity:_city4[0]];
                [self showSelectTypeView:AddressLevelArea];
            }else{
                [self showSelectTypeView:AddressLevelCity];
            }
        }else if (_level==AddressLevelCity){
            // _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
            _area4 =[Address addressDataWithPid:_cityId];
            [self showSelectTypeView:AddressLevelArea];
        }else if (_level==AddressLevelArea){
            self.areaId4 =[NSString stringWithFormat:@"%@",[_area4[index] tid]];
            _strees4 =[Address streesWithArea:_area4[index]];
            [self showSelectTypeView:AddressLevelStreet];
        }else{
            self.streesId4 =[NSString stringWithFormat:@"%@",[_strees4[index] tid]];
        }
    }
    
}

- (void)requestDateFinished:(id)result
{
    if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]&&[[result objectForKey:@"data"] count]!=0) {
        
        NSArray *arr = [result objectForKey:@"data"];
        _dataList1 = [[NSMutableArray alloc] initWithCapacity:arr.count];
        //  NSMutableArray *communityArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            self.model1 = [[CommunityModel alloc] initWithDataDic:dic];
            //[self.dataList addObject:clueModel];
            [_dataList1 addObject:_model1.communityName];
        }
    }
    
}

- (void)button1Action{
    if (_btn1.titleLabel.text == nil||[_btn1.titleLabel.text length]==0) {
        [MBProgressHUD showError:@"请先选择板块1‘城市区域’" toView:self];
    }else{
        SelectViewController *vc = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectViewController"];
        vc.areaId = _streesId1;
        vc.keyWord = textField1.text;
        vc._delegation = self;
        [self.vc.navigationController pushViewController:vc animated:YES];
        _currentFastBtn = 1;
    }
}


- (void)button2Action{
    if (_btn2.titleLabel.text == nil||[_btn2.titleLabel.text length]==0) {
        [MBProgressHUD showError:@"请先选择板块2‘城市区域’" toView:self];
    }else{
        SelectViewController *vc = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectViewController"];
        vc._delegation = self;
        vc.areaId = _streesId2;
        vc.keyWord = textField2.text;
        [self.vc.navigationController pushViewController:vc animated:YES];
        _currentFastBtn = 2;
    }
}

- (void)button3Action{
    if (_btn3.titleLabel.text == nil||[_btn3.titleLabel.text length]==0) {
        [MBProgressHUD showError:@"请先选择板块2‘城市区域’" toView:self];
    }else{
        SelectViewController *vc = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectViewController"];
        vc._delegation = self;
        vc.areaId = _streesId3;
        vc.keyWord = textField3.text;
        [self.vc.navigationController pushViewController:vc animated:YES];
        _currentFastBtn = 3;
    }
}

- (void)button4Action{
    if (_btn4.titleLabel.text == nil||[_btn4.titleLabel.text length]==0) {
        [MBProgressHUD showError:@"请先选择板块4‘城市区域’" toView:self];
    }else{
        SelectViewController *vc = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectViewController"];
        vc._delegation = self;
        vc.areaId = _streesId4;
        vc.keyWord = textField4.text;
        [self.vc.navigationController pushViewController:vc animated:YES];
        _currentFastBtn = 4;
    }
}

- (void)requestDateFinishing:(id)result{
    if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]&&[[result objectForKey:@"data"] count]!=0) {
        
        NSArray *arr = [result objectForKey:@"data"];
        _dataList2 = [[NSMutableArray alloc] initWithCapacity:arr.count];
        //  NSMutableArray *communityArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            self.model2 = [[CommunityModel alloc] initWithDataDic:dic];
            // [self.dataList addObject:clueModel];
            [_dataList2 addObject:_model2.communityName];
        }
    }
    
}

- (void)requestDateFinishOver:(id)result
{
    if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]&&[[result objectForKey:@"data"] count]!=0) {
        
        NSArray *arr = [result objectForKey:@"data"];
        _dataList3 = [[NSMutableArray alloc] initWithCapacity:arr.count];
        //  NSMutableArray *communityArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            self.model3 = [[CommunityModel alloc] initWithDataDic:dic];
            // [self.dataList addObject:clueModel];
            [_dataList3 addObject:_model3.communityName];
        }
    }
    
}

- (void)requestxqFinish:(id)result
{
    if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]&&[[result objectForKey:@"data"] count]!=0) {
        
        NSArray *arr = [result objectForKey:@"data"];
        _dataList4 = [[NSMutableArray alloc] initWithCapacity:arr.count];
        //  NSMutableArray *communityArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            self.model4 = [[CommunityModel alloc] initWithDataDic:dic];
            //[self.dataList addObject:clueModel];
            [_dataList4 addObject:_model4.communityName];
        }
    }
    
}

- (void)zxAction{
    _str = @"";
    [zxBtn setTitle:@"" forState:UIControlStateNormal];
    NSArray *arr = @[@"毛坯",@"简装",@"中装",@"精装",@"豪装"];
    
    HouseSelectView *view = [[HouseSelectView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-30, kScreenHeight-100) withItems:arr withTitle:@"期望装修" withBlock:^(NSArray *titleArr, NSString *btnTitle) {
        [zxBtn setTitle:btnTitle forState:UIControlStateNormal];
        zxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([titleArr containsObject:arr[0]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[1]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[2]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[3]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[4]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        _customerModel.decorationState = [NSNumber numberWithInt:[self NSStringToChar:_str]];
    } withPlaceHolderText:@"请点击选择期望装修"];
    [kCUREENT_WINDOW addSubview:view];
    
}
- (void)hxAction
{
    _str1 =@"";
    [hxBtn setTitle:@"" forState:UIControlStateNormal];
    NSArray *arr = @[@"一室",@"二室",@"三室",@"四室",@"五室",@"六室"];
    HouseSelectView *view = [[HouseSelectView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-30, kScreenHeight-100) withItems:arr withTitle:@"期望户型" withBlock:^(NSArray *titleArr, NSString *btnTitle) {
        [hxBtn setTitle:btnTitle forState:UIControlStateNormal];
        hxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([titleArr containsObject:arr[0]]) {
            _str1 = [_str1 stringByAppendingString:@"1"];
        }else{
            _str1 = [_str1 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[1]]) {
            _str1 = [_str1 stringByAppendingString:@"1"];
        }else{
            _str1 = [_str1 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[2]]) {
            _str1 = [_str1 stringByAppendingString:@"1"];
        }else{
            _str1 = [_str1 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[3]]) {
            _str1 = [_str1 stringByAppendingString:@"1"];
        }else{
            _str1 = [_str1 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[4]]) {
            _str1 = [_str1 stringByAppendingString:@"1"];
        }else{
            _str1 = [_str1 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[5]]) {
            _str1 = [_str1 stringByAppendingString:@"1"];
        }else{
            _str1 = [_str1 stringByAppendingString:@"0"];
        }
        _customerModel.bedRooms = [NSNumber numberWithInt:[self NSStringToChar:_str1]];
    } withPlaceHolderText:@"请点击选择期望户型"];
    [kCUREENT_WINDOW addSubview:view];
}
- (void)cxAction
{
    _str2 = @"";
    [cxBtn setTitle:@"" forState:UIControlStateNormal];
    NSArray *arr = @[@"东",@"南",@"西",@"北",@"南北",@"东西",@"东南",@"西南",@"东北",@"西北",@"其他"];
    HouseSelectView *view = [[HouseSelectView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-30, kScreenHeight-100) withItems:arr withTitle:@"期望朝向" withBlock:^(NSArray *titleArr, NSString *btnTitle) {
        [cxBtn setTitle:btnTitle forState:UIControlStateNormal];
        cxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([titleArr containsObject:arr[0]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[1]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[2]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[3]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[4]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[5]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[6]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[7]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[8]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[9]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[10]]) {
            _str2 = [_str2 stringByAppendingString:@"1"];
        }else{
            _str2 = [_str2 stringByAppendingString:@"0"];
        }
        _customerModel.toward = [NSNumber numberWithInt:[self NSStringToChar:_str2]];
        
    } withPlaceHolderText:@"请点击选择期望朝向"];
    [kCUREENT_WINDOW addSubview:view];
}
- (void)lxAction
{
    _str3 = @"";
    [lxBtn setTitle:@"" forState:UIControlStateNormal];
    NSArray *arr = @[@"多层",@"小高层",@"高层",@"复式",@"商住",@"酒店式公寓",@"叠加别墅",@"联排别墅",@"双拼别墅",@"独栋别墅",@"新式里弄",@"洋房",@"四合院"];
    HouseSelectView *view = [[HouseSelectView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-30, kScreenHeight-100) withItems:arr withTitle:@"期望楼型" withBlock:^(NSArray *titleArr, NSString *btnTitle) {
        [lxBtn setTitle:btnTitle forState:UIControlStateNormal];
        lxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([titleArr containsObject:arr[0]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[1]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[2]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[3]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[4]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[5]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[6]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[7]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[8]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[9]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[10]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[11]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[12]]) {
            _str3 = [_str3 stringByAppendingString:@"1"];
        }else{
            _str3 = [_str3 stringByAppendingString:@"0"];
        }
        _customerModel.houseType = [NSNumber numberWithInt:[self NSStringToChar:_str3]];
    } withPlaceHolderText:@"请点击选择期望楼型"];
    [kCUREENT_WINDOW addSubview:view];
}
- (NSString *)getCommunityIdWithCommunityTitle1:(NSString *)title1
{
    NSArray *arr = [_Dataresult1 objectForKey:@"data"];
    for (NSDictionary *dict in arr) {
        NSString *curTitle = [dict objectForKey:@"communityName"];
        NSString *curValue = [dict objectForKey:@"communityId"];
        if ([curTitle isEqualToString:title1]) {
            return curValue;
        }
    }
    return nil;
}
- (NSString *)getCommunityIdWithCommunityTitle2:(NSString *)title1
{
    NSArray *arr = [_Dataresult2 objectForKey:@"data"];
    for (NSDictionary *dict in arr) {
        NSString *curTitle = [dict objectForKey:@"communityName"];
        NSString *curValue = [dict objectForKey:@"communityId"];
        if ([curTitle isEqualToString:title1]) {
            return curValue;
        }
    }
    return nil;
}
- (NSString *)getCommunityIdWithCommunityTitle3:(NSString *)title1
{
    NSArray *arr = [_Dataresult3 objectForKey:@"data"];
    for (NSDictionary *dict in arr) {
        NSString *curTitle = [dict objectForKey:@"communityName"];
        NSString *curValue = [dict objectForKey:@"communityId"];
        if ([curTitle isEqualToString:title1]) {
            return curValue;
        }
    }
    return nil;
}
- (NSString *)getCommunityIdWithCommunityTitle4:(NSString *)title1
{
    NSArray *arr = [_Dataresult4 objectForKey:@"data"];
    for (NSDictionary *dict in arr) {
        NSString *curTitle = [dict objectForKey:@"communityName"];
        NSString *curValue = [dict objectForKey:@"communityId"];
        if ([curTitle isEqualToString:title1]) {
            return curValue;
        }
    }
    return nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _customerModel.memo = textView.text;
}

- (void)postNeedAction{
    if(!_customerModel.priceFrom || !_customerModel.priceTo){
        [MBProgressHUD showMessag:@"请输入价格范围" toView:self.vc.view];
        return ;
    }
    
    if(!_customerModel.areaFrom || !_customerModel.area_to){
        [MBProgressHUD showMessag:@"请输入面积范围" toView:self.vc.view];
        return ;
    }
    
    if(!_customerModel.houseFloorFrom || !_customerModel.houseFloorTo){
        [MBProgressHUD showMessag:@"请输入期望楼层" toView:self.vc.view];
        return ;
    }
    
    if(_customerModel.priceTo.integerValue < _customerModel.priceFrom.integerValue){
        [MBProgressHUD showMessag:@"最低价格不得高于最高价格" toView:self.vc.view];
        return ;
    }
    
    if(_customerModel.area_to.integerValue < _customerModel.areaFrom.integerValue){
        [MBProgressHUD showMessag:@"最小面积不得大于最大面积" toView:self.vc.view];
        return ;
    }
    
    if(_customerModel.houseFloorTo.integerValue < _customerModel.houseFloorFrom.integerValue){
        [MBProgressHUD showMessag:@"最低楼层不得高于最高楼层" toView:self.vc.view];
        return ;
    }
    
    if(_customerModel.customerMobilephone.length != 11){
        [MBProgressHUD showError:@"手机号码应该是11位" toView:_vc.view];
        return ;
    }
    
    if(![_customerModel.customerMobilephone hasPrefix:@"1"]){
        [MBProgressHUD showError:@"手机号码必须以1开头" toView:_vc.view];
        return ;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [ObjectUtil replaceNil: _customerModel.purpose],@"purpose",
                                 [ObjectUtil replaceNil: _customerModel.tradeType],@"tradeType",
                                 [ObjectUtil replaceNil: _streesId1],@"blockId1",
                                 [ObjectUtil replaceNil: _streesId2],@"blockId2",
                                 [ObjectUtil replaceNil: _streesId3],@"blockId3",
                                 [ObjectUtil replaceNil: _streesId4],@"blockId4",
                                 [ObjectUtil replaceNil: _currentId1],@"communityid1",
                                 [ObjectUtil replaceNil:  _currentId2],@"communityid2",
                                 [ObjectUtil replaceNil:  _currentId3],@"communityid3",
                                 [ObjectUtil replaceNil:  _currentId4],@"communityid4",
                                 [ObjectUtil replaceNil: _customerModel.priceFrom],@"priceFrom",
                                 [ObjectUtil replaceNil: _customerModel.priceTo],@"priceTo",
                                 [ObjectUtil replaceNil: _customerModel.areaFrom],@"areaFrom",
                                 [ObjectUtil replaceNil:  _customerModel.area_to],@"areaTo",
                                 [ObjectUtil replaceNil: _customerModel.houseFloorFrom],@"houseFloorFrom",
                                 [ObjectUtil replaceNil:  _customerModel.houseFloorTo],@"houseFloorTo",
                                 [ObjectUtil replaceNil: _customerModel.decorationState],@"decorationState",
                                 [ObjectUtil replaceNil: _customerModel.toward],@"toward",
                                 [ObjectUtil replaceNil:  _customerModel.houseType],@"houseType",
                                 [ObjectUtil replaceNil: _customerModel.bedRooms],@"bedRooms",
                                 [ObjectUtil replaceNil: _customerModel.memo],@"memo",
                                 [ObjectUtil replaceNil: _cityId],@"cityId",
                                 [ObjectUtil replaceNil:  _customerModel.customerName],@"customerName",
                                 [ObjectUtil replaceNil: _customerModel.customerMobilephone],@"customerMobilephone",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"],@"sid",
                                 nil];
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.vc.view animated:YES];
    [SuiDataService  requestWithURL:[KUrlConfig stringByAppendingString:@"requirement"] params:dict httpMethod:@"POST" block:^(id result) {
        [mbp hide:YES];
        NSString *responseStr = [NSString stringWithFormat:@"%@",result];
        
        if ([@"0" isEqualToString:responseStr]) {
            [MBProgressHUD showMessag:@"提交客需成功！" toView:KAPPDelegate.window];
            [self.vc.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"提交客需失败！" toView:self.vc.view];
        }
    }withTitle:@"提交住宅信息成功！"];
}

- (int)NSStringToChar:(NSString *)selectString{
    const char *ptr = [selectString cStringUsingEncoding:NSASCIIStringEncoding];
    
    long int rt=0;
    int i,n=0;
    
    while (ptr[n]) n++;
    
    for (--n,i=n; i>=0; i--)
        rt|=(ptr[i]-48)<<(n-i);
    
    return rt;
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_currentFirstView resignFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    _currentFirstView = textField ;
}

-(void) textViewDidBeginEditing:(UITextView *)textView{
    _currentFirstView = textView ;
}

-(void) didSelectAddress:(NSDictionary *)param{
    switch (_currentFastBtn) {
        case 1:
            textField1.text = [NSString stringWithFormat:@"%@",param[@"address"]];
            _currentId1 = [NSString stringWithFormat:@"%@",param[@"communityId"]];
            break;
        case 2:
            textField2.text = [NSString stringWithFormat:@"%@",param[@"address"]];
            _currentId2 = [NSString stringWithFormat:@"%@",param[@"communityId"]];
            break;
        case 3:
            textField3.text = [NSString stringWithFormat:@"%@",param[@"address"]];
            _currentId3 = [NSString stringWithFormat:@"%@",param[@"communityId"]];
            break;
        case 4:
            textField4.text = [NSString stringWithFormat:@"%@",param[@"address"]];
            _currentId4 = [NSString stringWithFormat:@"%@",param[@"communityId"]];
            break;
            
        default:
            break;
    }
}

@end
