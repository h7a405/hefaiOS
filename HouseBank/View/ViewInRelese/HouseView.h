//
//  HouseView.h
//  HouseBank1
//
//  Created by admin on 14/12/22.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleViewController.h"
#import "VWSelectedView.h"
#import "HXView.h"
#import "RTLabel.h"
#import "UserBean.h"
#import "Address.h"
#import "SelectTypeView.h"
#import "ECCustomDatePicker.h"
#import "Constants.h"
#import "HouseModel.h"
#import "CommunityModel.h"
#import "HouseBank-Swift.h"
#import "ReleseBaseView.h"

@interface HouseView : ReleseBaseView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,SelectTypeViewDelegate>{
    ECCustomDatePicker *dataPicker;
    VWSelectedView *delegateView;
    VWSelectedView *fingerView;
    
    VWSelectedView *leibieView;
    
    VWSelectedView *kanfangView;
    
    HXView *shiView;
    HXView*tingView;
    HXView *weiView;
    VWSelectedView *zhuangxiuView;
    VWSelectedView *tihuView;
    VWSelectedView *chaoxView;
    UITextView *msTextView;
    AddressLevel _level;
    UIPlaceHolderTextView *bzTextView;
    RTLabel *__label;
    
    UILabel *_label;
    UIButton *button;
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
    int a;
    UIButton *_lpbutton;
    NSMutableArray *_dataList;
}
@property (nonatomic,strong)id Dataresult;
@property (nonatomic,strong)HouseModel *houseModel;
@property (strong ,nonatomic) UIButton *dataBtn;
@property (nonatomic,strong)UserBean *model;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *imageView2;
@property (nonatomic,strong)UIImageView *photoView;
@property (nonatomic,strong)UIImageView *baseView;
@property (nonatomic,strong)UIImageView *yongjinView;
@property (nonatomic,strong)UIButton *postButton;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (strong,nonatomic)NSArray *data;
@property (nonatomic,strong)NSString *currentId;
//滑动视图
@property (weak ,nonatomic) UIScrollView *bgScroV;
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)SaleViewController *saleVC;
@property(strong,nonatomic)CommunityModel *Cmodel;
@property(strong,nonatomic)UILabel *lpLabel;
@property(strong,nonatomic)UITextField *lpTextField;

@end
