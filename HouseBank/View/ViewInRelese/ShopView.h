//
//  ShopView.h
//  housebank.1
//
//  Created by JunJun on 14/12/26.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import "RentViewController.h"
#import "VWSelectedView.h"
#import "RTLabel.h"
#import "UIView+Addition.h"
#import "ECCustomDatePicker.h"
#import "Address.h"
#import "SelectTypeView.h"
#import "ShopModel.h"
#import "ReleseBaseView.h"

@interface ShopView : ReleseBaseView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,SelectTypeViewDelegate>
{
    
    
    AddressLevel _level;
    ECCustomDatePicker *dataPicker;
    
    VWSelectedView *shouView;
    VWSelectedView *fengeView;
    VWSelectedView *weituoView;
    VWSelectedView *zhuangxView;
    VWSelectedView *peitView;
    VWSelectedView *mubiaoView;
    VWSelectedView *zhifuView;
    VWSelectedView *zhuanrView;
    VWSelectedView *xzView;
    VWSelectedView *kfView;
    VWSelectedView *cqView;
    UITextView *msTextView;
    UITextView  *bzTextView;
    UILabel *_label1;
    RTLabel *__label1;
    UIButton *shineibutton;
    UIButton *huxingButton;
    UIButton *fangchanButton;
    UIButton *delegateButton;
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    NSString *_addressInfo;
    NSString *_areaId;
    NSString *_streesId;
    UIButton *_lpbutton;
    UIButton *ptButton;
    UIButton *mbButton;
    int a;
    NSString *_str;
    NSString *_str1;
    
    
}
@property (nonatomic,strong)ShopModel *shopModel;
@property (strong ,nonatomic) UIButton *dataBtn;
@property (strong ,nonatomic) UIButton *dateBtn;
@property (nonatomic,strong)RentViewController *rentVC;
@property (weak ,nonatomic) UIScrollView *bgScroV;
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)UIImageView *imageView1;
@property (nonatomic,strong)UIImageView *imageView2;
@property (nonatomic,strong)UIImageView *imageView3;
@property (nonatomic,strong)UIImageView *baseView;
@property (nonatomic,strong)UIImageView *yongjinView;
@property (nonatomic,strong)UIButton *postButton;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (strong,nonatomic)NSArray *data;
@end
