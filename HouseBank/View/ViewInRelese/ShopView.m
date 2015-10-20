//
//  ShopView.m
//  housebank.1
//
//  Created by JunJun on 14/12/26.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import "ShopView.h"
#import "CRMBasicFactory.h"
#import "UIViewExt.h"
#import "CRTableViewController.h"
#import "UIView+Addition.h"
#import "HouseSelectView.h"
#include <stdio.h>
#include <math.h>
#include <string.h>
#import "SuiDataService.h"
#import "MBProgressHUD+Add.h"
#import "MorePicturesScrollView.h"

#define kCUREENT_WINDOW [[UIApplication sharedApplication] keyWindow]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface ShopView ()<UIScrollViewDelegate,MorePictureDelegation>{
    UIView *_currentFirstView ;
    __weak MorePicturesScrollView *_morePicturesView ;
}

@end

@implementation ShopView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.shopModel = [[ShopModel alloc] init];
        [self uiConfig];
        _str = @"";
        
    }
    return self;
}
- (void)uiConfig{
    self.data = [NSMutableArray array];
    self.cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"];
    self.cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.delegate = self;
    bgScrollView.contentSize = CGSizeMake(kScreenWidth, 4.63*kScreenHeight - 210);
    [self addSubview:bgScrollView];
    self.bgScroV = bgScrollView;
    [self.bgScroV addSubview:self.imageView1];
    UILabel *label = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 5, 80, kScreenHeight/3.6/3) font:[UIFont systemFontOfSize:15] text:@"所在区域" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:label];
    
    _lpbutton = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(label.right, 5, _imageView1.width-label.width-20, kScreenHeight/3.6/3-10) title:nil titleColor:[UIColor blackColor] target:self action:@selector(www_lpbtnAction)];
    _lpbutton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_imageView1 addSubview:_lpbutton];
    
    UIView *t = [[UIView alloc] initWithFrame:CGRectMake(_lpbutton.left, _lpbutton.bottom, _lpbutton.width, 0.5)];
    t.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:t];
    
    UILabel *label1 = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 5+kScreenHeight/3.6/3, 80, kScreenHeight/3.6/3) font:[UIFont systemFontOfSize:15] text:@"商铺地址" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:label1];
    
    UITextField *textfield1 = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(label1.right, label1.top+5, kScreenWidth-16-label1.width-20, kScreenHeight/3.6/4.5-5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentCenter borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    textfield1.delegate = self;
    textfield1.tag = 100;
    textfield1.placeholder = @"必填";
    [_imageView1 addSubview:textfield1];
    UIView *tt = [[UIView alloc] initWithFrame:CGRectMake(textfield1.left, textfield1.bottom, textfield1.width, 0.5)];
    tt.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:tt];
    UILabel *label2 = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 5+kScreenHeight/3.6/3+kScreenHeight/3.6/3, 80, kScreenHeight/3.6/3) font:[UIFont systemFontOfSize:15] text:@"商铺类型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    NSArray *shangpuArr = @[@"住宅底商",@"商业街商铺",@"写字楼配套底商",@"购物中心/百货",@"其他"];
    VWSelectedView *shangpuView = [[VWSelectedView alloc] initWithFrame:CGRectMake(label2.right, 5+kScreenHeight/3.6/3+kScreenHeight/3.6/3+5+5, kScreenWidth-16-label1.width-20, kScreenHeight/3.6/4.5) withItems:shangpuArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.shopType = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"请选择商铺类型(必须)"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, label2.bottom, kScreenWidth-16, 16.5)];
    view.backgroundColor = [UIColor whiteColor];
    [_imageView1 addSubview:view];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth-16, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    [view addSubview:lineView];
    
    int width;
    if (kScreenWidth ==414) {
        width = 280;
    }else if(kScreenWidth ==375){
        width = 260;
    }else {
        width = 200;
    }
    UILabel *weituoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, view.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"委托类型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *weituoArr = @[@"独家委托",@"非独家委托"];
    weituoView = [[VWSelectedView alloc] initWithFrame:CGRectMake(85, weituoLabel.top, width, kScreenHeight/18) withItems:weituoArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.exclusiveDelegate = [NSNumber numberWithInteger:index];
    } withPlaceholderText:@"请选择"];
    
    UILabel *shouLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, weituoLabel.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"一手二手" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *shouArr = @[@"一手",@"二手"];
    shouView = [[VWSelectedView alloc] initWithFrame:CGRectMake(85, shouLabel.top, width, kScreenHeight/18) withItems:shouArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.shouState = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"请选择"];
    shouView.right = weituoView.right;
    
    
    //售价
    int width1;
    if (kScreenWidth==375) {
        width1 = 290;
    }else if(kScreenWidth == 414){
        width1 = 320;
    }else
    {
        width1 = 220;
    }
    //配套设施
    UILabel *ptlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(weituoLabel.left, shouLabel.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"配套设施" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:ptlabel];
    ptButton  = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(ptlabel.right, ptlabel.top, kScreenWidth*2.2/3, kScreenHeight/18) title:@"请点击选择配套类型" titleColor:[UIColor blackColor] target:self action:@selector(btnAction1:)];
    
    ptButton.titleLabel.font = [UIFont systemFontOfSize:13];
    ptButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_imageView1 addSubview:ptButton];
    UIView *ptView = [[UIView alloc] initWithFrame:CGRectMake(ptButton.left, ptButton.bottom, ptButton.width, 0.5)];
    ptView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:ptView];
    //目标业态
    UILabel *mblabel = [CRMBasicFactory createLableWithFrame:CGRectMake(weituoLabel.left, ptlabel.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"目标业态" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:mblabel];
    
    mbButton = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(mblabel.right, mblabel.top, kScreenWidth*2.2/3, kScreenHeight/18) title:@"请点击选择目标业态" titleColor:[UIColor blackColor] target:self action:@selector(btnAction2:)];
    mbButton.titleLabel.font = [UIFont systemFontOfSize:13];
    mbButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_imageView1 addSubview:mbButton];
    UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(mbButton.left,mbButton.bottom, mbButton.width, 0.5)];
    mbView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:mbView];
    [_imageView1 addSubview:shouLabel];
    [_imageView1 addSubview:shouView];
    [_imageView1 addSubview:weituoLabel];
    [_imageView1 addSubview:weituoView];
    //现状
    UILabel *xzlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(weituoLabel.left, mblabel.bottom+14, 50, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"现状" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    NSArray *xzArr = @[@"营业中",@"空铺",@"新铺"];
    xzView = [[VWSelectedView alloc] initWithFrame:CGRectMake(xzlabel.right, xzlabel.top, width1, kScreenHeight/18) withItems:xzArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.currentStatus = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"营业中"];
    
    //看房
    UILabel *kflabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,xzlabel.bottom+14, 50, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"看房" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *kfArr = @[@"提前预约",@"有钥匙",@"借钥匙",@"预约租客"];
    kfView = [[VWSelectedView alloc] initWithFrame:CGRectMake(kflabel.right, kflabel.top, width1-30, kflabel.height) withItems:kfArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.lookHouse  = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"提前预约"];
    
    //房龄
    UILabel *fllabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,kflabel.bottom+14, 50, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"房龄" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:fllabel];
    UITextField *flTextField = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(fllabel.right, fllabel.top+8, kScreenWidth/2.8, kScreenHeight/18-8) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    flTextField.delegate = self;
    flTextField.tag = 110;
    flTextField.keyboardType = UIKeyboardTypeNumberPad;
    [flTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_imageView1 addSubview:flTextField];
    UIView *flView = [[UIView alloc] initWithFrame:CGRectMake(flTextField.left, flTextField.bottom, flTextField.width, 0.5)];
    flView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:flView];
    UILabel *yearlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(flTextField.right,kflabel.bottom+14, 15, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"年" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:yearlabel];
    UILabel *jflabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,yearlabel.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"交房时间 :" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:jflabel];
    self.dataBtn  = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(jflabel.right, jflabel.top, kScreenWidth*0.4, kScreenHeight/6/4) title:nil titleColor:[UIColor blackColor] target:self action:@selector(ss_selectedData)];
    self.dataBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dataBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.dataBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.dataBtn.backgroundColor = [UIColor clearColor];
    self.dataBtn.layer.cornerRadius = 3.f;
    self.dataBtn.layer.masksToBounds = YES;
    [_imageView1 addSubview:_dataBtn];
    UIView *yxView = [[UIView alloc] initWithFrame:CGRectMake(_dataBtn.left, _dataBtn.bottom, _dataBtn.width, 0.5)];
    yxView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:yxView];
    UILabel *kaifalabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,_dataBtn.bottom+14, 70, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"开发商" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:kaifalabel];
    UITextField *kfTextField = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(kaifalabel.right, kaifalabel.top+7, kScreenWidth/2.8, kScreenHeight/22-5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    kfTextField.delegate = self;
    kfTextField.tag = 120;
    [_imageView1 addSubview:kfTextField];
    UIView *s = [[UIView alloc] initWithFrame:CGRectMake(kfTextField.left, kfTextField.bottom, kfTextField.width, 0.5)];
    s.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:s];
    UILabel *cqlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,kaifalabel.bottom+14, 40, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"产权" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    NSArray *cqArr = @[@"40",@"50",@"70"];
    cqView  = [[VWSelectedView alloc] initWithFrame:CGRectMake(cqlabel.right, cqlabel.top, kScreenWidth*2.2/3, kScreenHeight/18) withItems:cqArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.propertyYear = [NSNumber numberWithInteger:[cqArr[index] integerValue]];
    } withPlaceholderText:@"40"];
    _shopModel.propertyYear = [NSNumber numberWithInteger:[cqArr[0] integerValue]];
    
    UILabel *jiagelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(cqlabel.left, cqlabel.bottom+14, 50, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"租金" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *jiageTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(jiagelabel.right, jiagelabel.top+5, width1-40, kScreenHeight/22) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    jiageTextfield.delegate = self;
    jiageTextfield.tag = 130;
    jiageTextfield.placeholder = @"必填";
    jiageTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [jiageTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *T = [[UIView alloc] initWithFrame:CGRectMake(jiageTextfield.left, jiageTextfield.bottom, jiageTextfield.width, 0.5)];
    T.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:T];
    UILabel *_jiagelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiageTextfield.right+3, jiageTextfield.top, 40, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"元/月" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:jiagelabel];
    [_imageView1 addSubview:jiageTextfield];
    [_imageView1 addSubview:_jiagelabel];
    
    //面积
    UILabel *mianjilabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiagelabel.left, jiagelabel.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"建筑面积" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *mianjiTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(mianjilabel.right, mianjilabel.top+5, width1-60, kScreenHeight/22) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mianjiTextfield.delegate = self;
    mianjiTextfield.tag = 140;
    mianjiTextfield.placeholder = @"必填";
    mianjiTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [mianjiTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *mjView = [[UIView alloc] initWithFrame:CGRectMake(mianjiTextfield.left, mianjiTextfield.bottom, mianjiTextfield.width, 0.5)];
    mjView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:mjView];
    UILabel *_mianjilabel = [CRMBasicFactory createLableWithFrame:CGRectMake(mianjiTextfield.right+3, mianjilabel.top, 50, kScreenHeight/3.6/4.5) font:[UIFont systemFontOfSize:15] text:@"平方米" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:mianjilabel];
    [_imageView1 addSubview:mianjiTextfield];
    [_imageView1 addSubview:_mianjilabel];
    
    //分割
    UILabel *fengelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiagelabel.left, mianjilabel.bottom+14, 50, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"分割" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *fengeArr = @[@"不可分割",@"可分割"];
    fengeView = [[VWSelectedView alloc] initWithFrame:CGRectMake(fengelabel.right, fengelabel.top, width1, kScreenHeight/18) withItems:fengeArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.seperate = [NSNumber numberWithInteger:index];
    } withPlaceholderText:@"不可分割"];
    
    
    //
    //
    //楼层
    UILabel *cenglabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiagelabel.left, fengelabel.bottom+14,65,kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"楼层    第" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:cenglabel];
    
    UITextField *cengTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(cenglabel.right,cenglabel.top+4,kScreenWidth/6,kScreenHeight/22-2) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment: UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    cengTextfield.delegate = self;
    cengTextfield.tag =150;
    cengTextfield.placeholder = @"必填";
    cengTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [cengTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_imageView1 addSubview:cengTextfield];
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(cengTextfield.left, cengTextfield.bottom, cengTextfield.width, 0.5)];
    c.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:c];
    //
    UILabel *_label = [CRMBasicFactory createLableWithFrame:CGRectMake(cengTextfield.right+2, cenglabel.top, kScreenWidth/7, kScreenHeight/18) font:[UIFont  systemFontOfSize:15] text:@"层  共" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:_label];
    UITextField *_textfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(_label.right, cenglabel.top+4, kScreenWidth/6,  kScreenHeight/22-2) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    _textfield.delegate = self;
    _textfield.tag = 160;
    _textfield.placeholder = @"必填";
    _textfield.keyboardType = UIKeyboardTypeNumberPad;
    [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_imageView1 addSubview:_textfield];
    UIView *cc = [[UIView alloc] initWithFrame:CGRectMake(_textfield.left, _textfield.bottom, _textfield.width, 0.5)];
    cc.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:cc];
    
    UILabel *__label = [CRMBasicFactory createLableWithFrame:CGRectMake(_textfield.right+3, cenglabel.top, 20, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"层" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    //装修
    UILabel *zhuangxlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, _label.bottom+14, 50, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"装修" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *zhuangxArr = @[@"毛胚",@"简装",@"精装",@"豪装",@"中装"];
    zhuangxView = [[VWSelectedView alloc] initWithFrame:CGRectMake(zhuangxlabel.right, zhuangxlabel.top, width+30, kScreenHeight/18) withItems:zhuangxArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.decorationState = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"请选择（必须）"];
    
    
    //物业费
    UILabel *wuyelabel= [CRMBasicFactory createLableWithFrame:CGRectMake(zhuangxlabel.left,zhuangxlabel.bottom+14,80,kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"物业费" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:wuyelabel];
    UITextField *wuyeTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(wuyelabel.right, zhuangxlabel.bottom+14+5, kScreenWidth/4, kScreenHeight/18-10) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    wuyeTextfield.delegate = self;
    wuyeTextfield.tag = 170;
    wuyeTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    wuyeTextfield.placeholder = @"1-999";
    [wuyeTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_imageView1 addSubview:wuyeTextfield];
    UIView *wyView = [[UIView alloc] initWithFrame:CGRectMake(wuyeTextfield.left, wuyeTextfield.bottom, wuyeTextfield.width, 0.5)];
    wyView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:wyView];
    
    UILabel *_wuyelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(wuyeTextfield.right+2, zhuangxlabel.bottom+14,kScreenWidth/3, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"元/平方米.月" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    [_imageView1 addSubview:_wuyelabel];
    
    
    UILabel *zhifuLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, wuyeTextfield.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"支付方式" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *zhifuArr = @[@"付一押一",@"付二押一",@"付三押一",@"付一押二",@"付二押二",@"付三押二",@"付一押三",@"付二押三",@"付三押三",@"付三押三",@"半年付",@"年付"];
    zhifuView = [[VWSelectedView alloc] initWithFrame:CGRectMake(85, zhifuLabel.top, width, kScreenHeight/18) withItems:zhifuArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.paymentType = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"请选择"];
    zhifuView.right = weituoView.right;
    
    UILabel *zhuanrLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, zhifuLabel.bottom+5, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"是否转让" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *zhuanrArr = @[@"是",@"否"];
    zhuanrView = [[VWSelectedView alloc] initWithFrame:CGRectMake(85, zhuanrLabel.top, width, kScreenHeight/18) withItems:zhuanrArr withBlock:^(NSInteger index, NSString *title) {
        _shopModel.transfer = [NSNumber numberWithInteger:index];
    } withPlaceholderText:@"是"];
    zhifuView.right = weituoView.right;
    
    
    //标题
    UILabel *mclabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, zhuanrLabel.bottom+14, 80, kScreenHeight/18) font:[UIFont systemFontOfSize:15] text:@"商铺名称" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *mcTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(mclabel.right, mclabel.top+8, width1-30, kScreenHeight/18-10) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mcTextfield.delegate = self;
    mcTextfield.tag = 180;
    mcTextfield.placeholder = @"必填，1-12字符";
    UIView *mcView = [[UIView alloc] initWithFrame:CGRectMake(mcTextfield.left, mcTextfield.bottom, mcTextfield.width, 0.5)];
    mcView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:mcView];
    [_imageView1 addSubview:mclabel];
    [_imageView1 addSubview:mcTextfield];
    [_imageView1 addSubview:label2];
    [_imageView1 addSubview:shangpuView];
    
    //标题
    UILabel *btlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiagelabel.left, mclabel.bottom+14+10,80,kScreenHeight/18-10) font:[UIFont systemFontOfSize:15] text:@"广告标题" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *btTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(btlabel.right, btlabel.top, width1-30, kScreenHeight/18-10) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    btTextfield.delegate = self;
    btTextfield.tag = 190;
    btTextfield.placeholder = @"必填,13-50个字符";
    UIView *btView = [[UIView alloc] initWithFrame:CGRectMake(btTextfield.left, btTextfield.bottom, btTextfield.width, 0.5)];
    btView.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:btView];
    [_imageView1 addSubview:btlabel];
    [_imageView1 addSubview:btTextfield];
    
    
    [_imageView1 addSubview:fengelabel];
    [_imageView1 addSubview:fengeView];
    [_imageView1 addSubview:__label];
    [_imageView1 addSubview:cqlabel];
    [_imageView1 addSubview:cqView];
    [_imageView1 addSubview:kflabel];
    [_imageView1 addSubview:kfView];
    [_imageView1 addSubview:xzlabel];
    [_imageView1 addSubview:xzView];
    [_imageView1 addSubview:zhuanrLabel];
    [_imageView1 addSubview:zhuanrView];
    [_imageView1 addSubview:zhifuLabel];
    [_imageView1 addSubview:zhifuView];
    UILabel *miaoslabel = [CRMBasicFactory createLableWithFrame:CGRectMake(btlabel.left,btlabel.bottom+14,80,kScreenHeight/3.6/4.5) font:[UIFont systemFontOfSize:15] text:@"房源描述" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:miaoslabel];
    if (msTextView == nil) {
        msTextView = [[UITextView alloc] initWithFrame:CGRectMake(miaoslabel.left, miaoslabel.bottom,kScreenWidth*0.9, 140)];
        msTextView.backgroundColor = [UIColor whiteColor];
        msTextView.font = [UIFont systemFontOfSize:14];
        msTextView.layer.cornerRadius = 3.f;
        msTextView.layer.masksToBounds = YES;
        msTextView.delegate = self;
        msTextView.tag = 101;
        [_imageView1 addSubview:msTextView];
        [_imageView1 addSubview:zhuangxlabel];
        [_imageView1 addSubview:zhuangxView];
    }else{
        msTextView = [[UITextView alloc] initWithFrame:CGRectMake(miaoslabel.left, miaoslabel.bottom,kScreenWidth*0.9, 140)];
    }
    
    UIView *_lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView1.bottom+8, kScreenWidth-16, 0.5)];
    _lineView.backgroundColor = [UIColor blackColor];
    [self.bgScroV addSubview:_lineView];
    [self.bgScroV addSubview:self.imageView3];
    // 照片
    UILabel *shineiLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 10,70, 30) font:[UIFont systemFontOfSize:16] text:@"室内图 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView3 addSubview:shineiLabel];
    UILabel *_shineiLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(shineiLabel.right+3, 15,210, 25) font:[UIFont systemFontOfSize:13] text:@"(上传详细图片将获得靠前推荐位置)" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView3 addSubview:_shineiLabel];
    
    shineibutton = [[UIButton alloc] initWithFrame:CGRectMake(shineiLabel.left, shineiLabel.bottom, (kScreenHeight*0.7)/4 -30-5, (kScreenHeight*0.7)/4 -30-5)];
    MorePicturesScrollView *mpsv = [[MorePicturesScrollView alloc] initWithFrame:rect(0, shineiLabel.bottom, 300, 100)];
    _morePicturesView = mpsv;
    _morePicturesView.delegation = self;
    [_imageView3 addSubview:mpsv];
    
    
    //户型图
    UILabel *huxingLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, shineibutton.bottom+2,50, 30) font:[UIFont systemFontOfSize:16] text:@"户型图" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView3 addSubview:huxingLabel];
    
    huxingButton = [[UIButton alloc] initWithFrame:CGRectMake(huxingLabel.left, huxingLabel.bottom, (kScreenHeight*0.7)/4 -30-5, (kScreenHeight*0.7)/4 -30-5)];
    [huxingButton setImage:[UIImage imageNamed:@"btn_image_add.png"] forState:UIControlStateNormal];
    [huxingButton addTarget:self action:@selector(__buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageView3 addSubview:huxingButton];
    
    //房产证
    UILabel *fangchanLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, huxingButton.bottom+2,160, 30) font:[UIFont systemFontOfSize:16] text:@"房产证与业主身份证" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView3 addSubview:fangchanLabel];
    
    fangchanButton = [[UIButton alloc] initWithFrame:CGRectMake(fangchanLabel.left, fangchanLabel.bottom, (kScreenHeight*0.7)/4 -30-5, (kScreenHeight*0.7)/4 -30-5)];
    [fangchanButton setImage:[UIImage imageNamed:@"btn_image_add.png"] forState:UIControlStateNormal];
    [fangchanButton addTarget:self action:@selector(__buttonAction3) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageView3 addSubview:fangchanButton];
    //代理委托书
    
    UILabel *dailiLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, fangchanButton.bottom+2,80, 30) font:[UIFont systemFontOfSize:16] text:@"代理委托书" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView3 addSubview:dailiLabel];
    
    delegateButton = [[UIButton alloc] initWithFrame:CGRectMake(dailiLabel.left,dailiLabel.bottom, (kScreenHeight*0.7)/4 -30-5, (kScreenHeight*0.7)/4 -30-5)];
    [delegateButton setImage:[UIImage imageNamed:@"btn_image_add.png"] forState:UIControlStateNormal];
    [delegateButton addTarget:self action:@selector(__buttonAction4) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageView3 addSubview:delegateButton];
    
    UIView *___lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView3.bottom+8, kScreenWidth-16, 0.5)];
    ___lineView.backgroundColor = [UIColor blackColor];
    [self.bgScroV addSubview:___lineView];
    [self.bgScroV addSubview:self.baseView];
    
    UILabel *topLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 8,220, 30) font:[UIFont systemFontOfSize:16] text:@"以下信息默认自己可见  ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_baseView addSubview:topLabel];
    
    UILabel *nameLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, topLabel.bottom+20,85, kScreenHeight/24) font:[UIFont systemFontOfSize:16] text:@"业主姓名" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_baseView addSubview:nameLabel];
    UITextField *nameTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(nameLabel.right, nameLabel.top, kScreenWidth*0.65, kScreenHeight/24) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    nameTextfield.delegate = self;
    nameTextfield.tag = 200;
    nameTextfield.placeholder = @"必填，2-16位";
    [_baseView addSubview:nameTextfield];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(nameTextfield.left, nameTextfield.bottom, nameTextfield.width, 0.5)];
    nameView.backgroundColor = [UIColor blackColor];
    [_baseView addSubview:nameView];
    UILabel *bottomLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, nameLabel.bottom+15,85, kScreenHeight/24) font:[UIFont systemFontOfSize:16] text:@"业主手机" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_baseView addSubview:bottomLabel ];
    UITextField *mobileTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(bottomLabel .right, bottomLabel .top, kScreenWidth*0.65,kScreenHeight/24) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mobileTextfield.delegate = self;
    mobileTextfield.tag = 210;
    mobileTextfield.placeholder = @"必填";
    mobileTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [_baseView addSubview:mobileTextfield];
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(mobileTextfield.left, mobileTextfield.bottom, mobileTextfield.width, 0.5)];
    mobileView.backgroundColor = [UIColor blackColor];
    [_baseView addSubview:mobileView];
    UIView *__lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView2.left, _baseView.bottom+8, kScreenWidth-16, 0.5)];
    __lineView.backgroundColor = [UIColor blackColor];
    [self.bgScroV addSubview:__lineView];
    [self.bgScroV addSubview:self.yongjinView];
    UILabel *hezuoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 12,85, kScreenHeight/18) font:[UIFont systemFontOfSize:16] text:@"合作佣金" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:hezuoLabel];
    
    UILabel *shangjiaLabel= [CRMBasicFactory createLableWithFrame:CGRectMake(8,hezuoLabel.bottom+14,53, kScreenHeight/18) font:[UIFont systemFontOfSize:16] text:@"上家 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:shangjiaLabel];
    
    UITextField *shangjiaTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(shangjiaLabel.right, shangjiaLabel.top, kScreenWidth*0.22, kScreenHeight/24) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    shangjiaTextfield.delegate = self;
    shangjiaTextfield.tag = 220;
    shangjiaTextfield.placeholder = @"必填";
    [shangjiaTextfield addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    shangjiaTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_yongjinView addSubview:shangjiaTextfield];
    UIView *sjView = [[UIView alloc] initWithFrame:CGRectMake(shangjiaTextfield.left, shangjiaTextfield.bottom, shangjiaTextfield.width, 0.5)];
    sjView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:sjView];
    UILabel *fenhaoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(shangjiaTextfield.right+2, hezuoLabel.bottom+14,14, kScreenHeight/18) font:[UIFont systemFontOfSize:16] text:@"%" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:fenhaoLabel];
    
    
    UILabel *xiajiaLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(fenhaoLabel.right+5, hezuoLabel.bottom+14,53, kScreenHeight/18) font:[UIFont systemFontOfSize:16] text:@"下家 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:xiajiaLabel];
    
    UITextField *xiajiaTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(xiajiaLabel.right, xiajiaLabel.top, kScreenWidth*0.22, kScreenHeight/24) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    xiajiaTextfield.delegate = self;
    xiajiaTextfield.tag = 230;
    xiajiaTextfield.placeholder = @"必填";
    [xiajiaTextfield addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    xiajiaTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_yongjinView addSubview:xiajiaTextfield];
    UIView *xjView = [[UIView alloc] initWithFrame:CGRectMake(xiajiaTextfield.left, xiajiaTextfield.bottom, xiajiaTextfield.width, 0.5)];
    xjView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:xjView];
    //yongjinTextfield.right = xiajiaTextfield.right;
    UILabel *fenhao1Label = [CRMBasicFactory createLableWithFrame:CGRectMake(xiajiaTextfield.right+2, hezuoLabel.bottom+14,14, kScreenHeight/18) font:[UIFont systemFontOfSize:16] text:@"%" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:fenhao1Label];
    
    
    UILabel *maifangLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, shangjiaLabel.bottom+14,100, kScreenHeight/18) font:[UIFont systemFontOfSize:16] text:@"卖房经纪人" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:maifangLabel];
    UITextField *jingjiTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(maifangLabel.right, maifangLabel.top, kScreenWidth*0.5, kScreenHeight/24) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    jingjiTextfield.delegate = self;
    jingjiTextfield.tag = 240;
    jingjiTextfield.placeholder = @"必填,1-99";
    jingjiTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [jingjiTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_yongjinView addSubview:jingjiTextfield];
    jingjiTextfield.right = xiajiaTextfield.right;
    UIView *jjView = [[UIView alloc] initWithFrame:CGRectMake(jingjiTextfield.left, jingjiTextfield.bottom, 110 , 0.5)];
    jjView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:jjView];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:rect(130, 0, 20, kScreenHeight/3.8/4.5-10)];
    rightLabel.text = @"%";
    [jingjiTextfield addSubview:rightLabel];
    
    //买房经纪人
    UILabel *maifang1Label = [CRMBasicFactory createLableWithFrame:CGRectMake(8, maifangLabel.bottom+14,100, kScreenHeight/24) font:[UIFont systemFontOfSize:16] text:@"买方经纪人" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:maifang1Label];
    UITextField *maifangTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(maifang1Label.right, maifang1Label.top, kScreenWidth*0.5, kScreenHeight/24) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    maifangTextfield.delegate = self;
    maifangTextfield.tag = 250;
    maifangTextfield.placeholder = @"必填,1-99";
    maifangTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [maifangTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_yongjinView addSubview:maifangTextfield];
    maifangTextfield.right = xiajiaTextfield.right;
    UIView *mfView = [[UIView alloc] initWithFrame:CGRectMake(maifangTextfield.left, maifangTextfield.bottom, 110, 0.5)];
    mfView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:mfView];
    
    UILabel *rightLabel1 = [[UILabel alloc] initWithFrame:rect(130, 0, 20, kScreenHeight/3.8/4.5-10)];
    rightLabel1.text = @"%";
    [maifangTextfield addSubview:rightLabel1];
    
    //有效期
    UILabel *youxiaoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, maifang1Label.bottom+14,80,kScreenHeight/24) font:[UIFont systemFontOfSize:16] text:@"有效期" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:youxiaoLabel ];
    
    self.dateBtn  = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(youxiaoLabel.right, youxiaoLabel.top, kScreenWidth*0.6, kScreenHeight/24) title:nil titleColor:[UIColor blackColor] target:self action:@selector(www_selectedData)];
    self.dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.dateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.dateBtn.backgroundColor = [UIColor clearColor];
    self.dateBtn.layer.cornerRadius = 3.f;
    self.dateBtn.layer.masksToBounds = YES;
    [_yongjinView addSubview:_dateBtn];
    UIView *_yxView = [[UIView alloc] initWithFrame:CGRectMake(_dateBtn.left, _dateBtn.bottom, _dateBtn.width, 0.5)];
    _yxView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:_yxView];
    
    //备注
    UILabel *beizhuLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, _dateBtn.bottom+14,55, kScreenHeight/24) font:[UIFont systemFontOfSize:16] text:@"备注" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:beizhuLabel ];
    
    if (bzTextView == nil) {
        bzTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, beizhuLabel.bottom,kScreenWidth*0.9, 140)];
        bzTextView.backgroundColor = [UIColor whiteColor];
        bzTextView.font = [UIFont systemFontOfSize:14];
        bzTextView.layer.cornerRadius = 3.f;
        bzTextView.layer.masksToBounds = YES;
        bzTextView.delegate = self;
        bzTextView.tag = 102;
        [_yongjinView addSubview:bzTextView];
    }else{
        bzTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, beizhuLabel.bottom,kScreenWidth*0.9, 140)];
    }
    [self.bgScroV addSubview:self.postButton];
    
    [self.dateBtn setTitle:[TimeUtil timeOfterWithMonth:3] forState:UIControlStateNormal];
    self.shopModel.delegateEndDate = [TimeUtil timeOfterWithMonth:3];
}

- (UIImageView *)imageView1{
    if (_imageView1 == nil) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, kScreenWidth-16, 5+3*(kScreenHeight/3.6/4.5)+21*14+21*(kScreenHeight/18)+140+5+kScreenHeight/18+kScreenHeight/18)];
        _imageView1.backgroundColor = [UIColor clearColor];
        _imageView1.userInteractionEnabled = YES;
        
    }
    return _imageView1;
}

-(void) setRentVC:(RentViewController *)rentVC{
    _vc = rentVC;
}

- (UIImageView *)imageView3
{
    if (_imageView3 == nil) {
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView1.bottom+16.5, kScreenWidth - 16,0.7*kScreenHeight)];
        _imageView3.backgroundColor = [UIColor clearColor];
        _imageView3.userInteractionEnabled = YES;
        _imageView3.backgroundColor = [UIColor clearColor];
        
        
    }
    return _imageView3;
}
- (UIImageView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIImageView alloc] initWithFrame:CGRectMake(8, _imageView3.bottom+17, kScreenWidth - 16, 73+kScreenHeight/12+10)];
        _baseView.userInteractionEnabled = YES;
        _baseView.backgroundColor = [UIColor clearColor];
        
    }
    return _baseView;
}
- (UIImageView *)yongjinView
{
    if (_yongjinView == nil) {
        _yongjinView = [[UIImageView alloc] initWithFrame:CGRectMake(8, _baseView.bottom+17, kScreenWidth - 16, 6*kScreenHeight/18+6*14+140)];
        _yongjinView.userInteractionEnabled = YES;
        _yongjinView.backgroundColor = [UIColor clearColor];
        
    }
    return _yongjinView;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 220 || textField.tag == 230|| textField.tag == 170|| textField.tag == 110|| textField.tag == 130|| textField.tag == 140|| textField.tag == 150|| textField.tag == 160|| textField.tag == 210|| textField.tag == 240|| textField.tag == 250) {
        NSRange range = [textField.text rangeOfString:@"."];
        NSRange replaceRange = [string rangeOfString:@"."];
        if (range.location != NSNotFound && replaceRange.location!=NSNotFound) {
            return NO;
        }
        
        return  [TextUtil isNumbel:string];
    }
    return YES;
}

-(void) textFieldDidChange : (UITextField *) textField{
    switch (textField.tag) {
        case 130:
        case 140:
            if([textField.text integerValue]>99999){
                textField.text = @"99999";
            }
            break;
        case 110:
            if([textField.text integerValue]>100){
                textField.text = @"100";
            }
            break;
        case 160:
        case 150:
            if([textField.text integerValue]>MaxFloor){
                textField.text = [NSString stringWithFormat:@"%d",MaxFloor];
            }
            break;
        case 170:
            if([textField.text floatValue]>999.0){
                textField.text = @"999";
            }
            break;
        case 220:
        case 230:
            if ([textField.text floatValue] > 35.0) {
                textField.text = @"35";
            }
            break;
        case 240:
        case 250:
            if([textField.text integerValue]>99){
                textField.text = @"99";
            }
            break;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    _currentFirstView = textField;
}

//textView占位字符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag ==101) {
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
        
    }else if(textView.tag == 102){
        if (![text isEqualToString:@""]) {
            
            __label1.hidden = YES;
        }
        
        if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
            
            __label1.hidden = NO;
        }
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        
    }
    return YES;
}
- (void)__buttonAction1
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    a = 0;
    [sheet showInView:self];
}
- (void)__buttonAction2
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    a = 1;
    [sheet showInView:self];
}
- (void)__buttonAction3
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    a = 2;
    [sheet showInView:self];
}
- (void)__buttonAction4
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    a = 3;
    [sheet showInView:self];
}

#pragma mark-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //资源类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (buttonIndex == 0) { //拍照
        //判断是否有摄像头
        BOOL hasCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (hasCamera) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            return;
        }
    }else if (buttonIndex == 1){    //相册
    }else if (buttonIndex == 2){    //取消
        return;
    }
    
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    [imgPicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    imgPicker.sourceType = sourceType;
    imgPicker.delegate = self;
    
    //弹出相册
    [[self viewController] presentViewController:imgPicker animated:YES completion:NULL];
    
}

//当选择相片过后,通过代理方法拿到相片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(img, 1);
    UIImage *image = [ViewUtil imageCompressForSize:[UIImage imageWithData:data] targetSize:CGSizeMake(800, 800)];
    
    if(a == 0){
        [_morePicturesView addImage:image];
    }else if (a ==1){
        [huxingButton setImage:image forState:UIControlStateNormal];
        _doorModelFigure = image;
    }else if (a == 2){
        [fangchanButton setImage:image forState:UIControlStateNormal];
        _housePropertyCardFigure = image;
    }else if (a == 3){
        [delegateButton setImage:image forState:UIControlStateNormal];
        _delegateFigure = image;
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIButton *)postButton{
    if (_postButton == nil) {
        _postButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _yongjinView.bottom - 15, kScreenWidth-20, 40)];
        _postButton.backgroundColor = [UIColor orangeColor];
        [_postButton setTitle:@"提交" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(shopPost) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _postButton;
}

- (void)ss_selectedData
{
    if (dataPicker == nil) {
        dataPicker = [[ECCustomDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        dataPicker.datePickerMode = UIDatePickerModeDate;
        dataPicker.dateFormat = @"yyyy-MM-dd";
    }
    __weak ShopView *blockSelf = self;
    dataPicker.sendSelectedDate = ^(NSString *curData){
        NSLog(@"data:%@",curData);
        [blockSelf.dataBtn setTitle:curData forState:UIControlStateNormal];
        blockSelf.shopModel.giveHouseDate = curData;
    };
    [dataPicker showPicker];
    [kCUREENT_WINDOW addSubview:dataPicker];
}

- (void)www_selectedData
{
    if (dataPicker == nil) {
        dataPicker = [[ECCustomDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        dataPicker.datePickerMode = UIDatePickerModeDate;
        dataPicker.dateFormat = @"yyyy-MM-dd";
    }
    __weak ShopView *blockSelf = self;
    dataPicker.sendSelectedDate = ^(NSString *curData){
        NSLog(@"data:%@",curData);
        [blockSelf.dateBtn setTitle:curData forState:UIControlStateNormal];
        blockSelf.shopModel.delegateEndDate = curData;
    };
    [dataPicker showPicker];
    [kCUREENT_WINDOW addSubview:dataPicker];
}

- (void)www_lpbtnAction
{
    [self showSelectTypeView:AddressLevelArea];
}

#pragma mark - 显示选择地理位置
-(void)showSelectTypeView:(AddressLevel)level
{
    SelectTypeView *view=[[SelectTypeView alloc]init];
    
    [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
    view.delegate=self;
    NSMutableArray *tmp = [NSMutableArray array];
    _level=level;
    if (level==AddressLevelProvince) {
        _provience=[Address getAllProvience];
        
        [_provience enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
            
        }];
        [view showWithTitle:@"请选择省份"];
    }else if (level==AddressLevelCity){
        
        view.data = _area;
        [_city enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
            
        }];
        [view showWithTitle:@"请选择城市"];
    }else if (level==AddressLevelArea){
        _area =[Address addressDataWithPid:_cityId];
        [_area enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择区域"];
    }else if (level==AddressLevelStreet){
        //_strees =[Address _areasWithCity:_cityId];
        
        [_strees enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择版块"];
    }
    view.data=tmp;
}
#pragma mark - 选择地区
-(void)typeView:(SelectTypeView *)view didSelect:(NSString *)str selectIndex:(NSInteger)index
{
    if (_level==AddressLevelArea) {
        _addressInfo=str;
    }else{
        _addressInfo= [_addressInfo stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
    }
    _lpbutton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_lpbutton setTitle:[[_cityName stringByAppendingString:@"  "] stringByAppendingString:_addressInfo] forState:UIControlStateNormal];
    
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
        // _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
        _area =[Address addressDataWithPid:_cityId];
        [self showSelectTypeView:AddressLevelArea];
    }else if (_level==AddressLevelArea){
        _areaId=[NSString stringWithFormat:@"%@",[_area[index] tid]];
        _strees=[Address streesWithArea:_area[index]];
        [self showSelectTypeView:AddressLevelStreet];
    }else{
        _streesId=[NSString stringWithFormat:@"%@",[_strees[index] tid]];
    }
}
- (void)btnAction1:(UIButton *)sender
{
    _str = @"";
    [ptButton setTitle:@"" forState:UIControlStateNormal];
    NSArray *arr = @[@"客梯",@"扶梯",@"货梯",@"暖气",@"空调",@"停车位",@"水",@"燃气",@"网络"];
    //CRTableViewController *tableView = [[CRTableViewController alloc] initWithStyle:UITableViewStylePlain withdataSource:arr];
    HouseSelectView *view = [[HouseSelectView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-30, kScreenHeight-100) withItems:arr withTitle:@"配套设施" withBlock:^(NSArray *titleArr, NSString *btnTitle) {
        [ptButton setTitle:btnTitle forState:UIControlStateNormal];
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
        if ([titleArr containsObject:arr[5]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[6]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[7]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        if ([titleArr containsObject:arr[8]]) {
            _str = [_str stringByAppendingString:@"1"];
        }else{
            _str = [_str stringByAppendingString:@"0"];
        }
        
        NSLog(@"_str = %@",_str);
        _shopModel.facilities = [NSNumber numberWithInt:[self NSStringToChar:_str]];
        
        NSLog(@"[self NSStringToChar:_str] = %d",[self NSStringToChar:_str]);
        NSLog(@"_shopModel.facilities = %@",_shopModel.facilities);
        
    } withPlaceHolderText:@"请点击选择配套类型"];
    
    [kCUREENT_WINDOW addSubview:view];
}



- (void)btnAction2:(UIButton *)sender
{
    _str1 = @"";
    [mbButton setTitle:@"" forState:UIControlStateNormal];
    NSArray *arr = @[@"餐饮美食",@"百货超市",@"酒店宾馆",@"家具建材",@"服饰鞋包",@"生活服务",@"美容美发",@"休闲娱乐",@"其他"];
    HouseSelectView *view = [[HouseSelectView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-30, kScreenHeight-100) withItems:arr withTitle:@"目标业态" withBlock:^(NSArray *titleArr, NSString *btnTitle) {
        [mbButton setTitle:btnTitle forState:UIControlStateNormal];
        if ([titleArr containsObject:arr[0]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"餐饮美食"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",餐饮美食"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[1]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"百货超市"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",百货超市"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[2]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"酒店宾馆"];
            }else {
                _str1 = [_str1 stringByAppendingString:@"酒店宾馆"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[3]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"家具建材"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",家具建材"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[4]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"服饰鞋包"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",服饰鞋包"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[5]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"生活服务"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",生活服务"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[6]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"美容美发"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",美容美发"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[7]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"休闲娱乐"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",休闲娱乐"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        if ([titleArr containsObject:arr[8]]) {
            if ([_str1 isEqualToString:@""]) {
                _str1 = [_str1 stringByAppendingString:@"其他"];
            }else {
                _str1 = [_str1 stringByAppendingString:@",其他"];
                
            }
            
        }else{
            _str1 = [_str1 stringByAppendingString:@""];
        }
        _shopModel.targetFormat = _str1;
        NSLog(@"_str1 =%@",_str1);
        
    } withPlaceHolderText:@"请点击选择目标业态"];
    [kCUREENT_WINDOW addSubview:view];
    
}
- (int)NSStringToChar:(NSString *)selectString
{
    //NSString 转换为char *
    
    const char *ptr = [selectString cStringUsingEncoding:NSASCIIStringEncoding];
    
    //  printf("ptr:%s/n", ptr);
    
    long int rt=0;
    int i,n=0;
    
    while (ptr[n]) n++;
    
    for (--n,i=n; i>=0; i--)
        rt|=(ptr[i]-48)<<(n-i);
    
    return rt;
    
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 100:// 地址
        {
            _shopModel.address = textField.text;
        }
            break;
        case 110:// 房龄
        {
            _shopModel.shopYear = [NSNumber numberWithInteger:[textField.text integerValue]];
        }
            break;
            
        case 120:// 开发商
        {
            _shopModel.developers = textField.text;
        }
            break;
        case 130://租金
        {
            _shopModel.monthPrice = [NSNumber numberWithFloat:[textField.text floatValue]];
            
        }
            break;
        case 140://面积
        {
            _shopModel.buildArea  = [NSNumber numberWithFloat:[textField.text floatValue]];
            
        }
            break;
        case 150://第几层
        {
            _shopModel.houseFloor = [NSNumber numberWithInteger:[textField.text integerValue]];
            
        }
            break;
        case 160://共几层
        {
            _shopModel.totalFloor = [NSNumber numberWithInteger:[textField.text integerValue]];
            
        }
            break;
        case 170://物业费
        {
            _shopModel.propertyPrice = [NSNumber numberWithFloat:[textField.text floatValue]];
            
        }
            break;
        case 180://商铺名称
        {
            _shopModel.shopName = textField.text;
        }
            break;
        case 190://标题
        {
            _shopModel.title = textField.text;
        }
            break;
        case 200://业主姓名
        {
            _shopModel.ownerName = textField.text;
        }
            break;
        case 210://业主电话
        {
            _shopModel.mobilephone1 = textField.text;
        }
            break;
        case 220://上家
        {
            _shopModel.leftCommission = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 230://下家
        {
            _shopModel.rightCommission = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 240://卖方
        {
            _shopModel.sellerDivided = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 250://买方
        {
            _shopModel.buyerDivided = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        default:
            break;
    }
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 101){
        _shopModel.description1 = textView.text;
    }else if(textView.tag == 102){
        _shopModel.memo = textView.text;
    }
}

- (void)shopPost{
    if([TextUtil isEmpty:_streesId]){
        [MBProgressHUD showError:@"请选择区域" toView:_vc.view];
        return;
    }
    
    if ([TextUtil isEmpty:_shopModel.address]) {
        [MBProgressHUD showError:@"请输入地址" toView:_vc.view];
        return;
    }
    
    if ([TextUtil isEmpty:_shopModel.title]||!_shopModel.houseFloor||[TextUtil isEmpty:_shopModel.ownerName]||[TextUtil isEmpty:_shopModel.mobilephone1]) {
        [MBProgressHUD showError:@"请输入必填项" toView:_vc.view];
        return;
    }
    
    if ([TextUtil isEmpty:_shopModel.shopName]) {
        [MBProgressHUD showError:@"请输入商铺名称" toView:_vc.view];
        return;
    }
    
    if (!_shopModel.leftCommission || !_shopModel.rightCommission) {
        [MBProgressHUD showError:@"请输入上下家佣金" toView:_vc.view];
        return ;
    }
    
    if (!_shopModel.sellerDivided || !_shopModel.buyerDivided) {
        [MBProgressHUD showError:@"请输入经纪人，1-99" toView:_vc.view];
        return ;
    }
    
    if (_shopModel.totalFloor.integerValue < _shopModel.houseFloor.integerValue) {
        [MBProgressHUD showError:@"楼层不能高于总楼层" toView:_vc.view];
        return ;
    }
    
    if(_shopModel.title.length < 13 ){
        [MBProgressHUD showError:@"广告标题不能少于13个字符" toView:_vc.view];
        return ;
    }
    
    if(_shopModel.title.length > 50){
        [MBProgressHUD showError:@"广告标题不能多于50个字符" toView:_vc.view];
        return ;
    }
    
    if(_shopModel.mobilephone1.length != 11){
        [MBProgressHUD showError:@"手机号码应该是11位" toView:_vc.view];
        return ;
    }
    
    if(![_shopModel.mobilephone1 hasPrefix:@"1"]){
        [MBProgressHUD showError:@"手机号码必须以1开头" toView:_vc.view];
        return ;
    }
    
    [self upImage];
}

-(void) upImage{
    NSMutableArray *array = [NSMutableArray new];
    if (_doorModelFigure) {
        UpImgBean *bean = [UpImgBean new];
        bean.mainMark = 1;
        bean.type = 2;
        bean.img = _doorModelFigure;
        [array addObject:bean];
    }
    if (_housePropertyCardFigure) {
        UpImgBean *bean = [UpImgBean new];
        bean.mainMark = 1;
        bean.type = 3;
        bean.img = _housePropertyCardFigure;
        [array addObject:bean];
    }
    if (_delegateFigure) {
        UpImgBean *bean = [UpImgBean new];
        bean.mainMark = 1;
        bean.type = 4;
        bean.img = _delegateFigure;
        [array addObject:bean];
    }
    for (int i = 0; i<_morePicturesView.images.count; i++) {
        UpImgBean *bean = [UpImgBean new];
        bean.mainMark = (i == 0 ? 1 : 0);
        bean.type = 1;
        bean.img = _morePicturesView.images[i];
        [array addObject:bean];
    }
    
    [super startUpImage:array];
}

-(void) onUpImageComplete:(NSString *)result{
    [super onUpImageComplete:result];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"],@"sid",
                                 @2,@"tradeType",//
                                 @3,@"purpose",//
                                 _streesId,@"blockId",    //街道编号//
                                 _cityId,@"cityId",       // 城市编号
                                 _areaId,@"regionId",     // 区域编号
                                 [ObjectUtil replaceNil: _shopModel.address],@"address",
                                 [ObjectUtil replaceNil: _shopModel.shopType],@"shopType",
                                 [ObjectUtil replaceNil:_shopModel.exclusiveDelegate],@"exclusiveDelegate",
                                 [ObjectUtil replaceNil:_shopModel.shouState],@"newOldState",
                                 [ObjectUtil replaceNil:_shopModel.currentStatus],@"currentStatus",
                                 [ObjectUtil replaceNil: _shopModel.lookHouse],@"lookHouse", //看房
                                 [ObjectUtil replaceNil:_shopModel.shopYear],@"shopYear",
                                 [ObjectUtil replaceNil:_shopModel.giveHouseDate],@"giveHouseDate",
                                 [ObjectUtil replaceNil:_shopModel.developers],@"developers",
                                 [ObjectUtil replaceNil:_shopModel.propertyYear],@"propertyYear",
                                 [ObjectUtil replaceNil:_shopModel.facilities],@"facilities",
                                 [ObjectUtil replaceNil:_shopModel.targetFormat],@"targetFormat",
                                 [ObjectUtil replaceNil:_shopModel.monthPrice],@"monthPrice",
                                 [ObjectUtil replaceNil:_shopModel.buildArea],@"buildArea",//面积
                                 [ObjectUtil replaceNil:_shopModel.seperate],@"seperate",
                                 [ObjectUtil replaceNil:_shopModel.houseFloor],@"houseFloor",
                                 [ObjectUtil replaceNil:_shopModel.totalFloor],@"totalFloor",
                                 [ObjectUtil replaceNil:_shopModel.decorationState],@"decorationState",
                                 [ObjectUtil replaceNil:_shopModel.propertyPrice],@"propertyPrice",
                                 [ObjectUtil replaceNil:_shopModel.paymentType],@"paymentType",
                                 [ObjectUtil replaceNil:_shopModel.transfer],@"transfer",
                                 [ObjectUtil replaceNil: _shopModel.shopName],@"shopName",
                                 [ObjectUtil replaceNil:_shopModel.title],@"title",
                                 [ObjectUtil replaceNil:_shopModel.description1],@"description",
                                 [ObjectUtil replaceNil:_shopModel.memo],@"memo",
                                 [ObjectUtil replaceNil:_shopModel.leftCommission],@"leftCommission",
                                 [ObjectUtil replaceNil:_shopModel.rightCommission],@"rightCommission",
                                 [ObjectUtil replaceNil:_shopModel.sellerDivided],@"sellerDivided",
                                 [ObjectUtil replaceNil:_shopModel.buyerDivided],@"buyerDivided",
                                 [ObjectUtil replaceNil:_shopModel.delegateEndDate],@"delegateEndDate", //有效期
                                 [ObjectUtil replaceNil:_shopModel.ownerName],@"ownerName",  //业主姓名
                                 [ObjectUtil replaceNil:_shopModel.mobilephone1],@"mobilephone1"
                                 ,result , @"houseImage"
                                 ,nil]; //业主手机
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:_vc.view animated:YES];
    [SuiDataService  requestWithURL:[KUrlConfig stringByAppendingString:@"house/add"] params:dict httpMethod:@"POST" block:^(id result) {
        [mbp hide:YES];
        //具体逻辑注释，默认成功
        NSString *responseStr = [NSString stringWithFormat:@"%@",result];
        if ([@"0" isEqualToString:responseStr]) {
            [MBProgressHUD showMessag:@"提交住宅信息成功！" toView:KAPPDelegate.window];
            [_vc.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"提交住宅信息失败！" toView:_vc.view];
        }
    }withTitle:@"提交住宅信息成功！"];
}

#pragma mark scrollview delegation
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_currentFirstView resignFirstResponder];
};

#pragma mark more picture delegation
-(void) onAddBtnTapped:(MorePicturesScrollView *)moreView{
    if (_morePicturesView.images.count >= 8) {
        [MBProgressHUD showMessag:@"当前室内已经大于8张" toView:_vc.view];
    }else{
        a = 0;
        
        [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil] showInView:self];
    }
}


@end
