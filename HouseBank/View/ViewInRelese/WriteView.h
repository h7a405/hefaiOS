//
//  WriteView.h
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
#import "HXView.h"
#import "Address.h"
#import "SelectTypeView.h"
#import "ECCustomDatePicker.h"
#import "CommunityModel.h"
#import "WriteModel.h"
#import "ReleseBaseView.h"

@interface WriteView : ReleseBaseView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,SelectTypeViewDelegate>{
    ECCustomDatePicker *dataPicker;
    VWSelectedView *weituoView;
    VWSelectedView *levelView;
    VWSelectedView *zhuangxView;
    VWSelectedView *zhifuView;
    VWSelectedView *kfView;
    UITextView *msTextView;
    UITextView  *bzTextView;
    UILabel *_label1;
    RTLabel *__label1;
    UIButton *shineibutton;
    UIButton *huxingButton;
    UIButton *fangchanButton;
    UIButton *delegateButton;
    UIButton *_lpbutton;
    HXView *shiView;
    HXView*tingView;
    HXView *weiView;
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    NSString *_addressInfo;
    
    NSString *_streesId;
    AddressLevel _level;
    int a;
    NSMutableArray *_dataList;
    
}
@property(nonatomic,strong)WriteModel *writeModel;
//-(void)showHUD:(NSString *)title withHiddenDelay:(NSTimeInterval)delay withView:(UIView *)view;
//-(void)showHUD:(NSString *)title withHiddenDelay:(NSTimeInterval)delay;
@property (nonatomic,strong)id Dataresult;
@property (nonatomic,strong)NSString *currentId;
@property (copy,nonatomic)NSString *areaId;
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
//@property (strong,nonatomic)NSMutableArray *dataList;
@property(strong,nonatomic)CommunityModel *model;
@property(strong,nonatomic)UILabel *lpLabel;
@property(strong,nonatomic)UITextField *loupanTextField;
@end
