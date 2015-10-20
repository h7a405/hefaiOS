///Users/admin/Desktop/客需/客需.xcodeproj
//  CustomerView.h
//  客需
//
//  Created by JunJun on 14/12/29.
//  Copyright (c) 2014年 JunJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedViewController.h"
#import "VWSelectedView.h"
#import "RTLabel.h"
#import "SelectTypeView.h"
#import "Address.h"
#import "XSSelectDataArea.h"
#import "CommunityModel.h"
#import "CustomerModel.h"
#import "UIPlaceHolderTextView.h"

@interface CustomerView : UIView <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SelectTypeViewDelegate>
{
    VWSelectedView *ytView;
    VWSelectedView *zxView;
    VWSelectedView *hxView;
    VWSelectedView *cxView;
    VWSelectedView *lxView;
    UIPlaceHolderTextView *msTextView;
    RTLabel *_label1;
    UILabel *jiaoylabel;
    UITableView *_tableView;
    NSMutableArray *_titles;
//  NSArray *_provience;
//     NSArray *_city;
//     NSArray *_area;
//    NSArray *_strees;
    NSArray *_provience1;
    NSArray *_provience2;
    NSArray *_provience3;
    NSArray *_provience4;
    NSArray *_city1;
     NSArray *_city2;
     NSArray *_city3;
     NSArray *_city4;
    NSArray *_area1;
    NSArray *_area2;
    NSArray *_area3;
    NSArray *_area4;
    NSArray *_strees1;
    NSArray *_strees2;
    NSArray *_strees3;
    NSArray *_strees4;

    
    NSString *_cityId;
    NSString *_areaId;
    NSString *_streesId;
    
    NSString *_priceBegin;
    NSString *_prictEnd;
    
    NSString *_areaBegin;
    NSString *_areaEnd;
    
    NSString *_target;
   
    
    AddressLevel _level;
    NSString *_addressInfo;
    NSInteger _currentIndex;
    
    NSMutableArray *_data;
    XSSelectDataArea *_selectAreaView;
    UIButton *bottombtn1;
    UIButton *bottombtn2;
    UIButton *bottombtn3;
    UIButton *bottombtn4;
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
    int _currentButton;
    NSMutableArray *_dataList1;
    NSMutableArray *_dataList2;
    NSMutableArray *_dataList3;
    NSMutableArray *_dataList4;
    UITextField *textField1;
    UITextField *textField2;
    UITextField *textField3;
    UITextField *textField4;
    UIButton *zxBtn;
    UIButton *hxBtn;
    UIButton *cxBtn;
    UIButton *lxBtn;
    NSString *_str;
    NSString *_str1;
    NSString *_str2;
    NSString *_str3;

}
@property (nonatomic,strong)NSString *streesId1;
@property (nonatomic,strong)NSString *streesId2;
@property (nonatomic,strong)NSString *streesId3;
@property (nonatomic,strong)NSString *streesId4;
@property (nonatomic,strong)NSString *cityId1;
@property (nonatomic,strong)NSString *cityId2;
@property (nonatomic,strong)NSString *cityId3;
@property (nonatomic,strong)NSString *cityId4;
@property (nonatomic,strong)NSString *areaId1;
@property (nonatomic,strong)NSString *areaId2;
@property (nonatomic,strong)NSString *areaId3;
@property (nonatomic,strong)NSString *areaId4;
@property (nonatomic,strong)id Dataresult1;
@property (nonatomic,strong)NSString *currentId1;
@property (nonatomic,strong)id Dataresult2;
@property (nonatomic,strong)NSString *currentId2;
@property (nonatomic,strong)id Dataresult3;
@property (nonatomic,strong)NSString *currentId3;
@property (nonatomic,strong)id Dataresult4;
@property (nonatomic,strong)NSString *currentId4;
@property(nonatomic,strong)CustomerModel *customerModel;
- (id)initWithFrame:(CGRect)frame;
@property(nonatomic,strong)NeedViewController *vc;
@property(nonatomic,weak) UIScrollView *bgScroV;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,copy)NSString *cityName;
@property (nonatomic,strong)CommunityModel *model1;
@property (nonatomic,strong)CommunityModel *model2;
@property (nonatomic,strong)CommunityModel *model3;
@property (nonatomic,strong)CommunityModel *model4;
@end
