//
//  OfficeView.h
//  housebank.1
//
//  Created by admin on 14/12/22.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleViewController.h"
#import "VWSelectedView.h"
#import "RTLabel.h"
#import "UIView+Addition.h"
#import "ECCustomDatePicker.h"
#import "Constants.h"
#import "UserBean.h"
#import "Address.h"
#import "SelectTypeView.h"
#import "HouseBank-Swift.h"
#import "CommunityModel.h"
#import "OfficeModel.h"
#import "ReleseBaseView.h"

@interface OfficeView : ReleseBaseView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,SelectTypeViewDelegate>{
    AddressLevel _level;
    ECCustomDatePicker *dataPicker;
    VWSelectedView *weituoView;
    VWSelectedView *dengjiView;
    VWSelectedView *kongtiaoView;
    VWSelectedView *zhuangxiuView;
    VWSelectedView *kanfangView;
    UITextView *msTextView;
    UITextView *bzTextView;
    UILabel *_label1;
    RTLabel *__label1;
    UIButton *shineibutton;
    UIButton *huxingButton;
    UIButton *fangchanButton;
    UIButton *delegateButton;
    int a;
    UIButton *_qyButton;
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    NSString *_addressInfo;
    NSString *_areaId;
    NSString *_streesId;
    NSMutableArray *_dataList;
    UIButton *_lpButton;
}
//滑动视图
@property (nonatomic,strong)id Dataresult;
@property (weak ,nonatomic) UIScrollView *bgScroV;
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)OfficeModel *omodel;
@property (nonatomic,strong)SaleViewController *saleVC;
@property (nonatomic,strong)UIImageView *imageView1;
@property (nonatomic,strong)UIImageView *imageView2;
@property (nonatomic,strong)UIImageView *imageView3;
@property (nonatomic,strong)UIImageView *yongjinView;
@property (nonatomic,strong)UIImageView *baseView;
@property (nonatomic,strong)UIButton *postButton;
@property (strong ,nonatomic) UIButton *dataBtn;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (strong,nonatomic)NSArray *data;
@property(strong,nonatomic)CommunityModel *model;
@property(strong,nonatomic)UITextField *lptextField;
@property (nonatomic,strong)NSString *currentId;

@end
