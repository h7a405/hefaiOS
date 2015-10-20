//
//  RoomView.h
//  housebank.1
//
//  Created by JunJun on 14/12/26.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentViewController.h"
#import "VWSelectedView.h"
#import "RTLabel.h"
#import "UIView+Addition.h"
#import "ZYQAssetPickerController.h"
#import "HXView.h"
#import "ECCustomDatePicker.h"
#import "Address.h"
#import "SelectTypeView.h"
#import "CommunityModel.h"
#import "RoomModel.h"
#import "ReleseBaseView.h"

@interface RoomView : ReleseBaseView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,SelectTypeViewDelegate>{
    ECCustomDatePicker *dataPicker;
    VWSelectedView *weituoView;
    AddressLevel _level;
    //  VWSelectedView *shouView;
    VWSelectedView *leibieView;
    VWSelectedView *chaoxView;
    VWSelectedView *zhuangxView;
    VWSelectedView *zhifuView;
    VWSelectedView *jiadianView;
    VWSelectedView *kfView;
    UITextView *msTextView;
    UITextView  *bzTextView;
    UILabel *_label1;
    RTLabel *__label1;
    HXView *shiView;
    HXView*tingView;
    HXView *weiView;
    UIButton *shineibutton;
    UIButton *huxingButton;
    UIButton *fangchanButton;
    UIButton *delegateButton;
    int a;
    UIButton *_lpbutton;
    
    UIScrollView *src;
    
    UIPageControl *pageControl;
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    NSString *_addressInfo;
    NSString *_areaId;
    NSString *_streesId;
    UIButton *ptButton;
    NSMutableArray *_dataList;
    NSString *_str;
    
}
@property (nonatomic,strong)RoomModel *roomModel;
@property (nonatomic,strong)id Dataresult;
@property (nonatomic,strong)NSString *currentId;
@property (strong ,nonatomic) UIButton *dataBtn;
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
@property(strong,nonatomic)CommunityModel *model;
@property(strong,nonatomic) UILabel *loupanLabel;
@property(strong,nonatomic) UITextField *loupanTextField;
@end
