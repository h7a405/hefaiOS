//
//  WriteView.m
//  housebank.1
//
//  Created by JunJun on 14/12/26.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import "WriteView.h"
#import "CRMBasicFactory.h"
#import "UIViewExt.h"
#import "SuiDataService.h"
#import "HouseBank-Swift.h"
#import "MBProgressHUD+Add.h"
#import "MorePicturesScrollView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface WriteView ()<SelectViewDelegation,UIScrollViewDelegate,MorePictureDelegation>{
    UIView *_currentFirstView ;
    __weak MorePicturesScrollView *_morePicturesView ;
}

@end

@implementation WriteView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.writeModel = [[WriteModel alloc] init];
        [self uiConfig];
        
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
    bgScrollView.contentSize = CGSizeMake(kScreenWidth, 4.13*kScreenHeight - 220);
    [self addSubview:bgScrollView];
    self.bgScroV = bgScrollView;
    [self.bgScroV addSubview:self.imageView1];
    UILabel *label = [CRMBasicFactory createLableWithFrame:CGRectMake(5, 5, 80, _imageView1.height/2) font:[UIFont systemFontOfSize:15] text:@"所在区域" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:label];
    
    _lpbutton = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(label.right, 10, _imageView1.width-label.width-20, (_imageView1.height/2)-10) title:nil titleColor:[UIColor blackColor] target:self action:@selector(ww_lpbtnAction)];
    _lpbutton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_imageView1 addSubview:_lpbutton];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(label.right, _lpbutton.bottom, _imageView1.width-label.width-20, 0.5)];
    view.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:view];
    
    UILabel *label1 = [CRMBasicFactory createLableWithFrame:CGRectMake(5, 5+_imageView1.height/2+10, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"楼盘" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView1 addSubview:label1];
    
    self.loupanTextField = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(_lpbutton.left, label1.top, kScreenWidth/2.3, label1.height-3) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    _loupanTextField.delegate = self;
    [_imageView1 addSubview:_loupanTextField];
    UIView *lpview = [[UIView alloc] initWithFrame:CGRectMake(_loupanTextField.left,_loupanTextField.bottom, _loupanTextField.width, 0.5)];
    lpview.backgroundColor = [UIColor blackColor];
    [_imageView1 addSubview:lpview];
    
    UIButton *lpbutton = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(_loupanTextField.right, _loupanTextField.top, kScreenWidth/5.5, label1.height) title:@"快速选择" titleColor:[UIColor orangeColor] target:self action:@selector(ww_btnAction)];
    lpbutton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_imageView1 addSubview:lpbutton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView1.bottom+8, kScreenWidth-16, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.bgScroV addSubview:lineView];
    [self.bgScroV addSubview:self.imageView2];
    
    int width;
    if (kScreenWidth ==414) {
        width = 280;
    }else if(kScreenWidth ==375){
        width = 260;
    }else {
        width = 200;
    }
    
    UILabel *weituoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 12, 80, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"委托类型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *weituoArr = @[@"独家委托",@"非独家委托"];
    weituoView = [[VWSelectedView alloc] initWithFrame:CGRectMake(85, weituoLabel.top, width, _imageView1.height/3) withItems:weituoArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.exclusiveDelegate = [NSNumber numberWithFloat:index];
    } withPlaceholderText:@"非独家委托"];
    
    int width1;
    if (kScreenWidth==375) {
        width1 = 290;
    }else if(kScreenWidth == 414){
        width1 = 320;
    }else{
        width1 = 220;
    }
    //栋号
    UILabel *donghaolabel = [CRMBasicFactory createLableWithFrame:CGRectMake(weituoLabel.left, weituoLabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"栋号" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *donghaoTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(donghaolabel.right, donghaolabel.top, width1, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    donghaoTextfield.delegate = self;
    donghaoTextfield.tag = 100;
    donghaoTextfield.placeholder = @"必填";
    donghaoTextfield.keyboardType = UIKeyboardTypeASCIICapable;
    [donghaoTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *dhView = [[UIView alloc] initWithFrame:CGRectMake(donghaoTextfield.left, donghaoTextfield.bottom, donghaoTextfield.width, 0.5)];
    dhView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:dhView];
    
    //房号
    UILabel *fanghaolabel = [CRMBasicFactory createLableWithFrame:CGRectMake(weituoLabel.left, donghaolabel.bottom+14, 50, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:@"房号" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *fanghaoTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(fanghaolabel.right, fanghaolabel.top, width1, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    fanghaoTextfield.delegate = self;
    fanghaoTextfield.tag = 110;
    fanghaoTextfield.left = weituoLabel.right-20;
    fanghaoTextfield.placeholder = @"必填";
    fanghaoTextfield.keyboardType = UIKeyboardTypeNumberPad;
    UIView *fhView = [[UIView alloc] initWithFrame:CGRectMake(fanghaoTextfield.left, fanghaoTextfield.bottom, fanghaoTextfield.width, 0.5)];
    fhView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:fhView];
    //fanghaoTextfield.right = textfield.right;
    [_imageView2 addSubview:donghaolabel];
    [_imageView2 addSubview:donghaoTextfield];
    [_imageView2 addSubview:fanghaolabel];
    [_imageView2 addSubview:fanghaoTextfield];
    
    UILabel *jiagelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(weituoLabel.left, fanghaolabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"租金" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *jiageTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(jiagelabel.right, jiagelabel.top+10, kScreenWidth/2.8, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    jiageTextfield.delegate = self;
    jiageTextfield.tag = 120;
    jiageTextfield.keyboardType = UIKeyboardTypeNumberPad;
    jiageTextfield.placeholder = @"1-99999";
    [jiageTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *jgView = [[UIView alloc] initWithFrame:CGRectMake(jiageTextfield.left, jiageTextfield.bottom, jiageTextfield.width, 0.5)];
    jgView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:jgView];
    UILabel *_jiagelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiageTextfield.right+3,fanghaolabel.bottom+12, 40, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"元/㎡·天" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    
    //面积
    UILabel *mianjilabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiagelabel.left, jiagelabel.bottom+14, 50, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:@"面积" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *mianjiTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(mianjilabel.right, mianjilabel.top, kScreenWidth/2.8, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mianjiTextfield.delegate = self;
    mianjiTextfield.tag = 130;
    mianjiTextfield.keyboardType = UIKeyboardTypeNumberPad;
    mianjiTextfield.placeholder = @"1-99999";
    [mianjiTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *mjView = [[UIView alloc] initWithFrame:CGRectMake(mianjiTextfield.left, mianjiTextfield.bottom, mianjiTextfield.width, 0.5)];
    mjView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:mjView];
    UILabel *_mianjilabel = [CRMBasicFactory createLableWithFrame:CGRectMake(mianjiTextfield.right+3, jiagelabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"平方米" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    [_imageView2 addSubview:jiagelabel];
    [_imageView2 addSubview:jiageTextfield];
    [_imageView2 addSubview:_jiagelabel];
    [_imageView2 addSubview:mianjilabel];
    [_imageView2 addSubview:mianjiTextfield];
    [_imageView2 addSubview:_mianjilabel];
    [_imageView2 addSubview:weituoLabel];
    [_imageView2 addSubview:weituoView];
    
    //房型
    UILabel *hxlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, mianjilabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"房型" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    NSArray *shiArr = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    shiView = [[HXView alloc] initWithFrame:CGRectMake(hxlabel.right, hxlabel.top, kScreenWidth/8, _imageView1.height/3) withItems:shiArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.bedRooms = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"1"];
    _writeModel.bedRooms = [NSNumber numberWithInteger:1];
    
    UILabel *shilabel =  [CRMBasicFactory createLableWithFrame:CGRectMake(shiView.right+2, hxlabel.top, 15, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"室" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    //厅
    NSArray *tingArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
    tingView = [[HXView alloc] initWithFrame:CGRectMake(shilabel.right, hxlabel.top, kScreenWidth/8, _imageView1.height/3) withItems:tingArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.livingRooms = [NSNumber numberWithInteger:index];
    } withPlaceholderText:@"0"];
    _writeModel.livingRooms = [NSNumber numberWithInteger:0];
    
    UILabel *tinglabel =  [CRMBasicFactory createLableWithFrame:CGRectMake(tingView.right+2, hxlabel.top, 15, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"厅" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    //卫
    NSArray *weiArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
    weiView = [[HXView alloc] initWithFrame:CGRectMake(tinglabel.right, hxlabel.top, kScreenWidth/8, _imageView1.height/3) withItems:weiArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.washRooms = [NSNumber numberWithInteger:index];
    } withPlaceholderText:@"0"];
    _writeModel.washRooms = [NSNumber numberWithInteger:0];
    
    UILabel *weilabel =  [CRMBasicFactory createLableWithFrame:CGRectMake(weiView.right+2, hxlabel.top, 15, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"卫" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    //等级
    UILabel *levellabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, weilabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"等级" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    //类别view
    NSArray *levelArr = @[@"甲级",@"乙级",@"丙级",@"丁级"];
    levelView = [[VWSelectedView alloc] initWithFrame:CGRectMake(levellabel.right, levellabel.top, fanghaoTextfield.width, _imageView1.height/3) withItems:levelArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.officeLevel = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"甲级"];
    _writeModel.officeLevel = [NSNumber numberWithInteger:1];
    
    //楼层
    UILabel *cenglabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, levellabel.bottom+14,65,_imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"楼层   第" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView2 addSubview:cenglabel];
    
    UITextField *cengTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(cenglabel.right,cenglabel.top,kScreenWidth/6,_imageView1.height/4) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment: UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    cengTextfield.delegate = self;
    cengTextfield.tag = 140;
    cengTextfield.placeholder = @"必填";
    [cengTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cengTextfield.keyboardType = UIKeyboardTypeNumberPad;
    UIView *cengView = [[UIView alloc] initWithFrame:CGRectMake(cengTextfield.left, cengTextfield.bottom, cengTextfield.width, 0.5)];
    cengView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:cengView];
    //
    UILabel *_label = [CRMBasicFactory createLableWithFrame:CGRectMake(cengTextfield.right+2, cengTextfield.top, kScreenWidth/7, _imageView1.height/3) font:[UIFont  systemFontOfSize:15] text:@"层  共" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    
    UITextField *_textfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(_label.right, cengTextfield.top, kScreenWidth/6,  _imageView1.height/4) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    _textfield.delegate = self;
    _textfield.tag = 150;
    _textfield.placeholder = @"必填";
    [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textfield.keyboardType = UIKeyboardTypeNumberPad;
    UIView *_cengView = [[UIView alloc] initWithFrame:CGRectMake(_textfield.left, _textfield.bottom, _textfield.width, 0.5)];
    _cengView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:_cengView];
    
    UILabel *__label = [CRMBasicFactory createLableWithFrame:CGRectMake(_textfield.right+3, cengTextfield.top, 20, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"层" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    [_imageView2 addSubview:cenglabel];
    [_imageView2 addSubview:cengTextfield];
    [_imageView2 addSubview:_label];
    [_imageView2 addSubview:_textfield];
    [_imageView2 addSubview:__label];
    
    //层高
    UILabel *cenggaolabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,_label.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"层高" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *cenggaoTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(cenggaolabel.right, cenggaolabel.top, 50, _imageView1.height/4) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    cenggaoTextfield.delegate = self;
    cenggaoTextfield.tag = 160;
    cenggaoTextfield.left = weituoLabel.right-20;
    cenggaoTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [cenggaoTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *cgView = [[UIView alloc] initWithFrame:CGRectMake(cenggaoTextfield.left, cenggaoTextfield.bottom, cenggaoTextfield.width, 0.5)];
    cgView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:cgView];
    UILabel *___label = [CRMBasicFactory createLableWithFrame:CGRectMake(cenggaoTextfield.right+5,cenglabel.bottom+14, 15, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"米" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView2 addSubview:cenggaolabel];
    [_imageView2 addSubview:cenggaoTextfield];
    [_imageView2 addSubview:___label];
    //看房
    UILabel *kflabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8,cenggaolabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"看房" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *kfArr = @[@"提前预约",@"有钥匙",@"借钥匙",@"预约租客"];
    kfView = [[VWSelectedView alloc] initWithFrame:CGRectMake(kflabel.right, kflabel.top, width1-30, kflabel.height) withItems:kfArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.lookHouse = [NSNumber  numberWithInteger:index+1];
    } withPlaceholderText:@"提前预约"];
    
    //装修
    UILabel *zhuangxlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, kflabel.bottom+14, 50, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"装修" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *zhuangxArr = @[@"毛坯",@"简装",@"精装",@"豪装",@"中装"];
    zhuangxView = [[VWSelectedView alloc] initWithFrame:CGRectMake(zhuangxlabel.right, zhuangxlabel.top, width+30, _imageView1.height/3) withItems:zhuangxArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.decorationState = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"请选择（必须）"];
    
    //物业费
    UILabel *wuyelabel= [CRMBasicFactory createLableWithFrame:CGRectMake(zhuangxlabel.left,zhuangxlabel.bottom+14,80,_imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"物业费" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    
    UITextField *wuyeTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(wuyelabel.right, zhuangxlabel.bottom+14, kScreenWidth/4, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    wuyeTextfield.delegate = self;
    wuyeTextfield.tag = 170;
    wuyeTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    wuyeTextfield.placeholder = @"1-999";
    [wuyeTextfield addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    UIView *wyView = [[UIView alloc] initWithFrame:CGRectMake(wuyeTextfield.left, wuyeTextfield.bottom, wuyeTextfield.width,0.5)];
    wyView.backgroundColor = [UIColor blackColor];
    [_imageView2 addSubview:wyView];
    
    UILabel *_wuyelabel = [CRMBasicFactory createLableWithFrame:CGRectMake(wuyeTextfield.right+2, zhuangxlabel.bottom+14,kScreenWidth/3, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"元/平方米.月" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView2 addSubview:wuyelabel];
    [_imageView2 addSubview:wuyeTextfield];
    [_imageView2 addSubview:_wuyelabel];
    
    //支付
    UILabel *zhifuLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(5, wuyeTextfield.bottom+14, 80, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"支付方式" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    NSArray *zhifuArr = @[@"付一押一",@"付二押一",@"付三押一",@"付六押一"];
    zhifuView = [[VWSelectedView alloc] initWithFrame:CGRectMake(zhifuLabel.right, zhifuLabel.top, width, _imageView1.height/3) withItems:zhifuArr withBlock:^(NSInteger index, NSString *title) {
        _writeModel.paymentType = [NSNumber numberWithInteger:index+1];
    } withPlaceholderText:@"付三押一"];
    _writeModel.paymentType = [NSNumber numberWithInteger:3];
    
    //标题
    UILabel *btlabel = [CRMBasicFactory createLableWithFrame:CGRectMake(jiagelabel.left, zhifuLabel.bottom+14, 80, _imageView1.height/3) font:[UIFont systemFontOfSize:15] text:@"广告标题" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UITextField *btTextfield = [CRMBasicFactory createTextFieldWithFrame:CGRectMake(btlabel.right, btlabel.top, width1, _imageView1.height/4) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    btTextfield.delegate = self;
    btTextfield.tag = 180;
    btTextfield.placeholder = @"必填,13-50个字符";
    UIView *btView = [[UIView alloc] initWithFrame:CGRectMake(btTextfield.left, btTextfield.bottom, btTextfield.width, 0.5)];
    btView.backgroundColor = [UIColor blackColor];
    
    UILabel *miaoslabel = [CRMBasicFactory createLableWithFrame:CGRectMake(btlabel.left,btlabel.bottom+14,80,_imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:@"广告内容" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_imageView2 addSubview:miaoslabel];
    if (msTextView == nil) {
        msTextView = [[UITextView alloc] initWithFrame:CGRectMake(miaoslabel.left, miaoslabel.bottom,kScreenWidth*0.9, 140)];
        msTextView.backgroundColor = [UIColor whiteColor];
        msTextView.font = [UIFont systemFontOfSize:14];
        msTextView.layer.cornerRadius = 3.f;
        msTextView.layer.masksToBounds = YES;
        msTextView.delegate = self;
        msTextView.tag = 101;
        [_imageView2 addSubview:msTextView];
        [_imageView2 addSubview:btView];
        [_imageView2 addSubview:btlabel];
        [_imageView2 addSubview:btTextfield];
        [_imageView2 addSubview:zhifuLabel];
        [_imageView2 addSubview:zhifuView];
        [_imageView2 addSubview:zhuangxlabel];
        [_imageView2 addSubview:zhuangxView];
        [_imageView2 addSubview:kflabel];
        [_imageView2 addSubview:kfView];
        [_imageView2 addSubview:levellabel];
        [_imageView2 addSubview:levelView];
        [_imageView2 addSubview:hxlabel];
        [_imageView2 addSubview:shiView];
        [_imageView2 addSubview:shilabel];
        [_imageView2 addSubview:tinglabel];
        [_imageView2 addSubview:tingView];
        [_imageView2 addSubview:weiView];
        [_imageView2 addSubview:weilabel];
    }else{
        msTextView = [[UITextView alloc] initWithFrame:CGRectMake(miaoslabel.left, miaoslabel.bottom,kScreenWidth*0.9, 140)];
    }
    UIView *_lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView2.left, _imageView2.bottom+8, kScreenWidth-16, 0.5)];
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
    
    UIView *___lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView2.left, _imageView2.bottom+8, kScreenWidth-16, 0.5)];
    ___lineView.backgroundColor = [UIColor blackColor];
    [self.bgScroV addSubview:___lineView];
    [self.bgScroV addSubview:self.baseView];
    
    UILabel *topLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 8,220, 30) font:[UIFont systemFontOfSize:16] text:@"以下信息默认自己可见  ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_baseView addSubview:topLabel];
    
    UILabel *nameLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, topLabel.bottom+18,85, _imageView1.height/4.5) font:[UIFont systemFontOfSize:16] text:@"业主姓名" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_baseView addSubview:nameLabel];
    UITextField *nameTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(nameLabel.right, nameLabel.top, kScreenWidth*0.65, _imageView1.height/4.7) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    nameTextfield.delegate = self;
    nameTextfield.tag = 190;
    nameTextfield.placeholder = @"必填，2-16位";
    [_baseView addSubview:nameTextfield];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(nameTextfield.left, nameTextfield.bottom, nameTextfield.width, 0.5)];
    nameView.backgroundColor = [UIColor blackColor];
    [_baseView addSubview:nameView];
    
    UILabel *bottomLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, nameLabel.bottom+15,85, _imageView1.height/4.5) font:[UIFont systemFontOfSize:16] text:@"业主手机" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_baseView addSubview:bottomLabel ];
    UITextField *mobileTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(bottomLabel .right, bottomLabel .top, kScreenWidth*0.65,_imageView1.height/4.7) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    mobileTextfield.delegate = self;
    mobileTextfield.tag = 200;
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
    UILabel *hezuoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, 12,85, _imageView1.height/3) font:[UIFont systemFontOfSize:16] text:@"合作佣金" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:hezuoLabel];
    
    UILabel *shangjiaLabel= [CRMBasicFactory createLableWithFrame:CGRectMake(8,hezuoLabel.bottom+14,53, _imageView1.height/3.5) font:[UIFont systemFontOfSize:16] text:@"上家 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:shangjiaLabel];
    
    UITextField *shangjiaTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(shangjiaLabel.right, shangjiaLabel.top, kScreenWidth*0.22, _imageView1.height/4) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    shangjiaTextfield.delegate = self;
    shangjiaTextfield.tag = 210;
    shangjiaTextfield.placeholder = @"必填";
    [shangjiaTextfield addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    shangjiaTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_yongjinView addSubview:shangjiaTextfield];
    UIView *sjView = [[UIView alloc] initWithFrame:CGRectMake(shangjiaTextfield.left, shangjiaTextfield.bottom, shangjiaTextfield.width, 0.5)];
    sjView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:sjView];
    UILabel *fenhaoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(shangjiaTextfield.right+2, hezuoLabel.bottom+14,14, _imageView1.height/3.5) font:[UIFont systemFontOfSize:16] text:@"%" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:fenhaoLabel];
    
    UILabel *xiajiaLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(fenhaoLabel.right+5, hezuoLabel.bottom+14,53, _imageView1.height/3.5) font:[UIFont systemFontOfSize:16] text:@"下家 ：" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:xiajiaLabel];
    
    UITextField *xiajiaTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(xiajiaLabel.right, xiajiaLabel.top, kScreenWidth*0.22, _imageView1.height/4) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    xiajiaTextfield.delegate = self;
    xiajiaTextfield.tag = 220;
    xiajiaTextfield.placeholder = @"必填";
    xiajiaTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [xiajiaTextfield addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    [_yongjinView addSubview:xiajiaTextfield];
    UIView *xjView = [[UIView alloc] initWithFrame:CGRectMake(xiajiaTextfield.left, xiajiaTextfield.bottom, xiajiaTextfield.width, 0.5)];
    xjView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:xjView];
    //yongjinTextfield.right = xiajiaTextfield.right;
    UILabel *fenhao1Label = [CRMBasicFactory createLableWithFrame:CGRectMake(xiajiaTextfield.right+2, hezuoLabel.bottom+14,14, _imageView1.height/3.5) font:[UIFont systemFontOfSize:16] text:@"%" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:fenhao1Label];
    
    UILabel *maifangLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, shangjiaLabel.bottom+14,100, _imageView1.height/3.5) font:[UIFont systemFontOfSize:16] text:@"卖方经纪人" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:maifangLabel];
    UITextField *jingjiTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(maifangLabel.right, maifangLabel.top, kScreenWidth*0.5, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    jingjiTextfield.delegate = self;
    jingjiTextfield.tag = 230;
    jingjiTextfield.placeholder = @"必填";
    jingjiTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [jingjiTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_yongjinView addSubview:jingjiTextfield];
    jingjiTextfield.right = xiajiaTextfield.right;
    UIView *jjView = [[UIView alloc] initWithFrame:CGRectMake(jingjiTextfield.left, jingjiTextfield.bottom, 110, 0.5)];
    jjView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:jjView];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:rect(130, 0, 20, kScreenHeight/3.8/4.5-10)];
    rightLabel.text = @"%";
    [jingjiTextfield addSubview:rightLabel];
    
    //买房经纪人
    UILabel *maifang1Label = [CRMBasicFactory createLableWithFrame:CGRectMake(8, maifangLabel.bottom+14,100, _imageView1.height/4.5) font:[UIFont systemFontOfSize:16] text:@"买方经纪人" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:maifang1Label];
    UITextField *maifangTextfield =  [CRMBasicFactory createTextFieldWithFrame:CGRectMake(maifang1Label.right, maifang1Label.top, kScreenWidth*0.5, _imageView1.height/4.5) font:[UIFont systemFontOfSize:15] text:nil textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft contentAlignment:UIControlContentVerticalAlignmentFill borderStyle:UITextBorderStyleNone bgColor:[UIColor clearColor]];
    maifangTextfield.delegate = self;
    maifangTextfield.tag = 240;
    maifangTextfield.placeholder = @"必填";
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
    UILabel *youxiaoLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, maifang1Label.bottom+14,80, _imageView1.height/4.5) font:[UIFont systemFontOfSize:16] text:@"有效期" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:youxiaoLabel ];
    
    self.dataBtn  = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(youxiaoLabel.right, youxiaoLabel.top, kScreenWidth*0.6, _imageView1.height/4.5) title:nil titleColor:[UIColor blackColor] target:self action:@selector(w_selectedData)];
    self.dataBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dataBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.dataBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.dataBtn.backgroundColor = [UIColor clearColor];
    self.dataBtn.layer.cornerRadius = 3.f;
    self.dataBtn.layer.masksToBounds = YES;
    [_yongjinView addSubview:_dataBtn];
    UIView *yxView = [[UIView alloc] initWithFrame:CGRectMake(_dataBtn.left, _dataBtn.bottom, _dataBtn.width, 0.5)];
    yxView.backgroundColor = [UIColor blackColor];
    [_yongjinView addSubview:yxView];
    
    //备注
    UILabel *beizhuLabel = [CRMBasicFactory createLableWithFrame:CGRectMake(8, youxiaoLabel.bottom+14,55, _imageView1.height/4.5) font:[UIFont systemFontOfSize:16] text:@"备注" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    [_yongjinView addSubview:beizhuLabel ];
    
    if (bzTextView == nil) {
        bzTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, beizhuLabel.bottom+14,kScreenWidth*0.9, 140)];
        bzTextView.backgroundColor = [UIColor whiteColor];
        bzTextView.font = [UIFont systemFontOfSize:14];
        bzTextView.layer.cornerRadius = 3.f;
        bzTextView.layer.masksToBounds = YES;
        bzTextView.delegate = self;
        bzTextView.tag = 102;
        [_yongjinView addSubview:bzTextView];
    }else{
        bzTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, beizhuLabel.bottom+14,kScreenWidth*0.9, 140)];
    }
    [self.bgScroV addSubview:self.postButton];
    
    [self.dataBtn setTitle:[TimeUtil timeOfterWithMonth:3] forState:UIControlStateNormal];
    self.writeModel.delegateEndDate = [TimeUtil timeOfterWithMonth:3];
}

- (UIImageView *)imageView1
{
    if (_imageView1 == nil) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, kScreenWidth-16, kScreenHeight/6)];
        _imageView1.backgroundColor = [UIColor clearColor];
        _imageView1.userInteractionEnabled = YES;
        
    }
    return _imageView1;
}

- (UIImageView *)imageView2
{
    if (_imageView2 == nil) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView1.bottom+16.5, kScreenWidth - 16,1.5*kScreenHeight)];
        _imageView2.backgroundColor = [UIColor clearColor];
        _imageView2.userInteractionEnabled = YES;
        _imageView2.backgroundColor = [UIColor clearColor];
        
        
    }
    return _imageView2;
}
- (UIImageView *)imageView3
{
    if (_imageView3 == nil) {
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView2.bottom+16.5, kScreenWidth - 16,0.7*kScreenHeight)];
        _imageView3.backgroundColor = [UIColor clearColor];
        _imageView3.userInteractionEnabled = YES;
        _imageView3.backgroundColor = [UIColor clearColor];
        
        
    }
    return _imageView3;
}
- (UIImageView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIImageView alloc] initWithFrame:CGRectMake(8, _imageView3.bottom+17, kScreenWidth - 16, 0.25*kScreenHeight)];
        _baseView.userInteractionEnabled = YES;
        _baseView.backgroundColor = [UIColor clearColor];
        
    }
    return _baseView;
}
- (UIImageView *)yongjinView
{
    if (_yongjinView == nil) {
        _yongjinView = [[UIImageView alloc] initWithFrame:CGRectMake(8, _baseView.bottom+17, kScreenWidth - 16, 0.76*kScreenHeight)];
        _yongjinView.userInteractionEnabled = YES;
        _yongjinView.backgroundColor = [UIColor clearColor];
        
    }
    return _yongjinView;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

-(void) setRentVC:(RentViewController *)rentVC{
    _vc = rentVC;
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
        _postButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _yongjinView.bottom - 30, kScreenWidth-20, 40)];
        _postButton.backgroundColor = [UIColor orangeColor];
        [_postButton setTitle:@"提交" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _postButton;
}

- (void)w_selectedData
{
    if (dataPicker == nil) {
        dataPicker = [[ECCustomDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        dataPicker.datePickerMode = UIDatePickerModeDate;
        dataPicker.dateFormat = @"yyyy-MM-dd";
    }
    __weak WriteView *blockSelf = self;
    dataPicker.sendSelectedDate = ^(NSString *curData){
        NSLog(@"data:%@",curData);
        [blockSelf.dataBtn setTitle:curData forState:UIControlStateNormal];
        blockSelf.writeModel.delegateEndDate = curData;
    };
    [dataPicker showPicker];
    [kCUREENT_WINDOW addSubview:dataPicker];
}

- (void)ww_lpbtnAction
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
        self.areaId=[NSString stringWithFormat:@"%@",[_area[index] tid]];
        _strees=[Address streesWithArea:_area[index]];
        [self showSelectTypeView:AddressLevelStreet];
    }else{
        _streesId=[NSString stringWithFormat:@"%@",[_strees[index] tid]];
    }
}
- (void)ww_btnAction
{
    if (_lpbutton.titleLabel.text == nil||[_lpbutton.titleLabel.text length]==0) {
        [MBProgressHUD showError:@"请先选择‘城市区域’" toView:self];
    }else{
        SelectViewController *selectVC = [[UIStoryboard storyboardWithName:@"Community" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectViewController"];
        selectVC.keyWord = _loupanTextField.text;
        selectVC.areaId = _streesId;
        selectVC._delegation = self;
        
        [_vc.navigationController pushViewController:selectVC animated:YES];
    }
}

- (NSString *)getCommunityIdWithCommunityTitle:(NSString *)title
{
    NSArray *arr = [_Dataresult objectForKey:@"data"];
    for (NSDictionary *dict in arr) {
        NSString *curTitle = [dict objectForKey:@"communityName"];
        NSString *curValue = [dict objectForKey:@"communityId"];
        if ([curTitle isEqualToString:title]) {
            return curValue;
        }
    }
    return nil;
}

- (void)requestDataFinished:(id)result
{
    if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]&&[[result objectForKey:@"data"] count]!=0) {
        NSArray *arr = [result objectForKey:@"data"];
        _dataList = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            self.model = [[CommunityModel alloc] initWithDataDic:dic];
            [_dataList addObject:_model.communityName];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentFirstView = textField;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 210 || textField.tag == 220|| textField.tag == 170|| textField.tag == 110|| textField.tag == 120|| textField.tag == 130|| textField.tag == 140|| textField.tag == 150|| textField.tag == 160|| textField.tag == 200|| textField.tag == 230|| textField.tag == 240) {
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
        case 100:
            if (textField.text.length > 4) {
                textField.text = [textField.text substringToIndex:4];
            }
            break;
        case 120:
        case 130:// 售价
            if([textField.text integerValue]>99999){
                textField.text = @"99999";
            }
            break;
        case 150:
        case 140:
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
        case 210:
            if ([textField.text floatValue] > 35.0) {
                textField.text = @"35";
            }
            break;
        case 160:
            if([textField.text integerValue]>10){
                textField.text = @"10";
            }
            break;
        case 230:
        case 240:
            if([textField.text integerValue]>99){
                textField.text = @"99";
            }
            break;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 100:// 栋号
        {
            _writeModel.buildingNum = textField.text;
        }
            break;
            
        case 110:// 房号
        {
            _writeModel.houseNum = [NSNumber numberWithInteger:[textField.text integerValue]];
        }
            break;
        case 120://租金
        {
            _writeModel.monthPrice = [NSNumber numberWithFloat:[textField.text floatValue]];
            
        }
            break;
        case 130://面积
        {
            _writeModel.buildArea  = [NSNumber numberWithFloat:[textField.text floatValue]];
            
        }
            break;
        case 140://第几层
        {
            _writeModel.houseFloor = [NSNumber numberWithInteger:[textField.text integerValue]];
            
        }
            break;
        case 150://共几层
        {
            _writeModel.totalFloor = [NSNumber numberWithInteger:[textField.text integerValue]];
            
        }
            break;
        case 160://层高
        {
            _writeModel.floorHeight = [NSNumber numberWithInteger:[textField.text integerValue]];
            
        }
            break;
        case 170://物业费
        {
            _writeModel.propertyPrice = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 180://标题
        {
            _writeModel.title = textField.text;
        }
            break;
        case 190://业主姓名
        {
            _writeModel.ownerName = textField.text;
        }
            break;
        case 200://业主电话
        {
            _writeModel.mobilephone1 = textField.text;
        }
            break;
        case 210://上家
        {
            _writeModel.leftCommission = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 220://下家
        {
            _writeModel.rightCommission = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 230://卖方
        {
            _writeModel.sellerDivided = [NSNumber numberWithFloat:[textField.text floatValue]];
        }
            break;
        case 240://买方
        {
            _writeModel.buyerDivided = [NSNumber numberWithFloat:[textField.text floatValue]];
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
        _writeModel.description1 = textView.text;
    }else if(textView.tag == 102){
        _writeModel.memo = textView.text;
    }
}

- (void)post{
    if ([TextUtil isEmpty:_currentId]) {
        [MBProgressHUD showError:@"请选择小区" toView:_vc.view];
        return;
    }
    
    if ([TextUtil isEmpty:_writeModel.title]||!_writeModel.buildingNum || !_writeModel.houseNum||!_writeModel.houseFloor||[TextUtil isEmpty:_writeModel.ownerName]||[TextUtil isEmpty:_writeModel.mobilephone1]) {
        [MBProgressHUD showError:@"请输入必填项" toView:_vc.view];
        return;
    }
    
    if(!_writeModel.decorationState){
        [MBProgressHUD showError:@"请选择装修" toView:_vc.view];
        return;
    }
    
    if (!_writeModel.leftCommission || !_writeModel.rightCommission) {
        [MBProgressHUD showError:@"请输入上下家佣金" toView:_vc.view];
        return ;
    }
    
    if (!_writeModel.sellerDivided || !_writeModel.buyerDivided) {
        [MBProgressHUD showError:@"请输入经纪人，1-99" toView:_vc.view];
        return ;
    }
    
    if (_writeModel.totalFloor.integerValue < _writeModel.houseFloor.integerValue) {
        [MBProgressHUD showError:@"楼层不能高于总楼层" toView:_vc.view];
        return ;
    }
    
    if(_writeModel.title.length < 13 ){
        [MBProgressHUD showError:@"广告标题不能少于13个字符" toView:_vc.view];
        return ;
    }
    
    if(_writeModel.title.length > 50){
        [MBProgressHUD showError:@"广告标题不能多于50个字符" toView:_vc.view];
        return ;
    }
    
    if(_writeModel.mobilephone1.length != 11){
        [MBProgressHUD showError:@"手机号码应该是11位" toView:_vc.view];
        return ;
    }
    
    if(![_writeModel.mobilephone1 hasPrefix:@"1"]){
        [MBProgressHUD showError:@"手机号码必须以1开头" toView:_vc.view];
        return ;
    }
    
    if (_writeModel.floorHeight.integerValue < 3) {
        [MBProgressHUD showError:@"层高必须不小于3米" toView:_vc.view];
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
                                 @2,@"purpose",//
                                 _streesId,@"blockId",    //街道编号//
                                 _cityId,@"cityId",       // 城市编号
                                 _areaId,@"regionId",     // 区域编号
                                 _currentId,@"communityId", //所属小区Id
                                 [NSString stringWithFormat:@"%@",_writeModel.propertyPrice],@"propertyPrice",
                                 [ObjectUtil replaceNil: _writeModel.exclusiveDelegate],@"exclusiveDelegate",
                                 [ObjectUtil replaceNil:   _writeModel.monthPrice],@"dayM2Price",
                                 [ObjectUtil replaceNil:  _writeModel.buildArea],@"buildArea",        //面积
                                 [ObjectUtil replaceNil: _writeModel.buildingNum],@"buildingNum", //栋号
                                 [ObjectUtil replaceNil: _writeModel.houseNum],@"houseNum",//房号
                                 [ObjectUtil replaceNil:  _writeModel.bedRooms],@"bedRooms",
                                 [ObjectUtil replaceNil: _writeModel.livingRooms],@"livingRooms",
                                 [ObjectUtil replaceNil: _writeModel.washRooms],@"washRooms",
                                 [ObjectUtil replaceNil:_writeModel.houseFloor],@"houseFloor",
                                 [ObjectUtil replaceNil:_writeModel.paymentType],@"paymentType",
                                 [ObjectUtil replaceNil:_writeModel.totalFloor],@"totalFloor",
                                 [ObjectUtil replaceNil: _writeModel.floorHeight],@"floorHeight",
                                 [ObjectUtil replaceNil: _writeModel.lookHouse],@"lookHouse",
                                 [ObjectUtil replaceNil: _writeModel.decorationState],@"decorationState",   //装修程度//
                                 [ObjectUtil replaceNil: _writeModel.title],@"title",
                                 [ObjectUtil replaceNil: _writeModel.description1],@"description",
                                 [ObjectUtil replaceNil: _writeModel.memo],@"memo",
                                 [ObjectUtil replaceNil: _writeModel.leftCommission],@"leftCommission",
                                 [ObjectUtil replaceNil:  _writeModel.rightCommission],@"rightCommission",
                                 [ObjectUtil replaceNil: _writeModel.sellerDivided],@"sellerDivided",
                                 [ObjectUtil replaceNil:  _writeModel.buyerDivided],@"buyerDivided",
                                 [ObjectUtil replaceNil: _writeModel.delegateEndDate],@"delegateEndDate", //有效期
                                 [ObjectUtil replaceNil: _writeModel.ownerName],@"ownerName",  //业主姓名
                                 [ObjectUtil replaceNil: _writeModel.mobilephone1],@"mobilephone1",
                                 [ObjectUtil replaceNil:_writeModel.officeLevel],@"officeLevel",
                                 result , @"houseImage",
                                 nil]; //业主手机
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:_vc.view animated:YES];
    [SuiDataService  requestWithURL:[KUrlConfig stringByAppendingString:@"house/add"] params:dict httpMethod:@"POST" block:^(id result) {
        [mbp hide:YES];
        NSString *responseStr = [NSString stringWithFormat:@"%@",result];
        if ([@"0" isEqualToString:responseStr]) {
            [MBProgressHUD showMessag:@"发布写字楼成功！" toView:KAPPDelegate.window];
            [_vc.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"发布写字楼失败！" toView:_vc.view];
        }
    }withTitle:@""];
}

#pragma mark scrollview delegation
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_currentFirstView resignFirstResponder];
};

#pragma mark selectView delegation
-(void) didSelectAddress:(NSDictionary *)param{
    _loupanTextField.text = [NSString stringWithFormat:@"%@",param[@"address"]];
    _currentId = [NSString stringWithFormat:@"%@",param[@"communityId"]];
}

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
