//
//  StoreView.h
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
#import "Constants.h"
#import "ECCustomDatePicker.h"
#import "SelectTypeView.h"
#import "Address.h"
#import "StoreModel.h"
#import "ReleseBaseView.h"

@interface StoreView : ReleseBaseView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,SelectTypeViewDelegate>{
    AddressLevel _level;
    ECCustomDatePicker *dataPicker;
    VWSelectedView *shangpuView;
    VWSelectedView *weituoView;
    VWSelectedView *shouView;
   VWSelectedView *fengeView;
    VWSelectedView *chanquanView;
    VWSelectedView *zhuangxiuView;
    VWSelectedView *peitaoView;
     VWSelectedView *mubiaoView;
     VWSelectedView *xzView;
    VWSelectedView *mcView;
    VWSelectedView *kfView;
    UITextView *msTextView;
    UITextView  *bzTextView;
    UILabel *_label1;
    RTLabel *__label1;
    UIButton *shineibutton;
    UIButton *huxingButton;
    UIButton *fangchanButton;
    UIButton *delegateButton;
    UIButton *_qyButton;
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    NSString *_addressInfo;
    NSString *_areaId;
    NSString *_streesId;
    UIButton *ptButton;
    UIButton *mbButton;
    NSString *_str;
    NSString *_str1;
 
    int a;
}
@property (strong,nonatomic) StoreModel *storeModel;
@property (nonatomic,strong)id Dataresult;
@property (weak ,nonatomic) UIScrollView *bgScroV;
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)SaleViewController *saleVC;
@property (nonatomic,strong)UIImageView *imageView1;
@property (nonatomic,strong)UIImageView *imageView2;
@property (nonatomic,strong)UIImageView *imageView3;
@property (nonatomic,strong)UIImageView *baseView;
@property (nonatomic,strong)UIImageView *yongjinView;
@property (nonatomic,strong)UIButton *postButton;
@property (strong ,nonatomic) UIButton *dataBtn;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (strong,nonatomic)NSArray *data;
@property (strong ,nonatomic) UIButton *timeBtn;
@property (nonatomic,strong)NSString *currentId;
@end
