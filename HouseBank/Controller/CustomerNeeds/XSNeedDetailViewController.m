//
//  XSNeedDetailViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-14.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNeedDetailViewController.h"
#import "MyCenterWsImpl.h"
#import "XSNeedBean.h"
#import "BrokerInfoBean.h"
#import "URLCommon.h"
#import "XSHouseBrokerInfoViewController.h"
#import "UIViewController+Storyboard.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "CustomerNeedsWsImpl.h"

@interface XSNeedDetailViewController ()
{
    NSString *_phoneNumber;
}
@property(nonatomic,strong)AFHTTPRequestOperationManager *request;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *reqId;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *purpose;
@property (weak, nonatomic) IBOutlet UILabel *tradeType;
@property (weak, nonatomic) IBOutlet UILabel *blockNameMap;
@property (weak, nonatomic) IBOutlet UILabel *communityNameMap;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *decorationState;
@property (weak, nonatomic) IBOutlet UILabel *houseType;
@property (weak, nonatomic) IBOutlet UILabel *houseFloor;
@property (weak, nonatomic) IBOutlet UILabel *bedRoom;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *mobilephone;
@property (weak, nonatomic) IBOutlet UILabel *authStatus;
@property (weak, nonatomic) IBOutlet UIImageView *brokerIcon;
@property (weak, nonatomic) IBOutlet UIView *cuttingLine1;
@property (weak, nonatomic) IBOutlet UIView *cuttingLine2;


@end

@implementation XSNeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.frame=self.view.bounds;
    _scrollView.contentSize=CGSizeMake(KWidth, _scrollView.frame.size.height+(IPhone4?110:30));
    [self.view sendSubviewToBack:_scrollView];
    
    
    [self loadMoreData];
}

-(void) addCuttingLine:(float) y{
    UIView *view = [[UIView alloc] initWithFrame:rect(0, y, self.view.frame.size.width,1 )];
    view.backgroundColor = KColorFromRGB(0xcccccc);
    [_scrollView addSubview:view];
}

#pragma mark - 初始化view
-(void)setupView{
    _reqId.text=_model.reqId;
    _createTime.text=[TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[_model.createTime doubleValue]/1000] format:@"yyyy-MM-dd"];
    
    _decorationState.text=[Tool decorationState:_model.decorationState];
    _purpose.text=[Tool purpose:_model.purpose];
    _tradeType.text=[Tool tradeType:_model.tradeType];
    _blockNameMap.text=[_model.blockNameMap isEqualToString:@""]?@"不限":_model.blockNameMap;
    [self plusHeightForAjdFrameWithLabel:_blockNameMap];
    _communityNameMap.text=[_model.communityNameMap isEqualToString:@""]?@"不限":_model.communityNameMap;
    [self plusHeightForAjdFrameWithLabel:_communityNameMap];
    _area.text=[NSString stringWithFormat:@"%@-%@平米",_model.areaFrom,_model.areaTo];
    if ([_model.tradeType integerValue]==2) {//出租
        _price.text=[NSString stringWithFormat:@"%@-%@元/月",_model.priceFrom,_model.priceTo];
    }else{//出售
        _price.text=[NSString stringWithFormat:@"%@-%@万",_model.priceFrom,_model.priceTo];
    }
    if ([_model.houseFloorFrom isEqualToString:@"0"]) {
        _houseFloor.text=@"不限";
    }else{
        _houseFloor.text=[NSString stringWithFormat:@"%@-%@层",_model.houseFloorFrom,_model.houseFloorTo];
    }
    _bedRoom.text=[Tool bedroom:_model.bedRoom];
    _houseType.text=[Tool houseType:_model.houseType type:_model.purpose];
    _cuttingLine1.center = CGPointMake(160, 119);
    _cuttingLine2.center = CGPointMake(160, 148);
    [self addCuttingLine:30];
    [self addCuttingLine:60];
    [self addCuttingLine:90];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.hidden=NO;
    [super viewWillAppear:animated];
}
#pragma mark - 加载数据
-(void)loadMoreData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CustomerNeedsWsImpl *ws = [CustomerNeedsWsImpl new];
    _request =  [ws requestCustomerNeedsDetail:_model.reqId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            _model=[XSNeedBean modelObjectWithDictionary:[result allStringObjDict]];
            [self setupView];
            [self loadInfoData];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 加载数据
-(void)loadInfoData{
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestBrokerInfo:KUrlConfig brokerId:_model.createUserId result:^(BOOL isSeccess,id result,NSString *data){
        if (isSeccess) {
            BrokerInfoBean *_broker=[BrokerInfoBean brokerFromDic:result];
            _name.text=[NSString stringWithFormat:@"%@",_broker.name];
            _company.text=_broker.company;
            _store.text=_broker.store;
            _mobilephone.text=[NSString stringWithFormat:@"%@",_broker.mobilephone];
            _authStatus.text=[Tool authStatus:[NSString stringWithFormat:@"%@",_broker.authStatus]];
            if (![_broker.brokerHeadImg isKindOfClass:[NSNull class]]) {//设置用户头像
                NSString *url = [URLCommon buildImageUrl:_broker.brokerHeadImg imageSize:L03 brokerId:_broker.brokerId];
                [_brokerIcon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nophoto"]];
            }
            _phoneNumber=[NSString stringWithFormat:@"%@",_broker.mobilephone];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
#pragma mark - 调整界面
-(void)plusHeightForAjdFrameWithLabel:(UILabel *)label{
    NSDictionary *dict=@{NSFontAttributeName: label.font};
    CGSize size=[label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    if (size.height<label.frame.size.height) {
        return;
    }
    CGFloat plusHeight=size.height-label.frame.size.height;
    NSInteger index=[label.superview.subviews indexOfObject:label];
    
    for (int i =index; i<label.superview.subviews.count; i++) {
        UIView *view=label.superview.subviews[i];
        CGRect frame=view.frame;
        if (i==index) {
            frame.size.height=size.height;
        }else{
            frame.origin.y+=plusHeight;
            
        }
        view.frame=frame;
    }
    [self adjScrollView:label.superview andPlusHeight:plusHeight];
    
}
-(void)adjScrollView:(UIView *)view andPlusHeight:(CGFloat)plusHeight
{
    NSInteger index=[_scrollView.subviews indexOfObject:view];
    for (int i=index; i<_scrollView.subviews.count; i++) {
        UIView *view=_scrollView.subviews[i];
        CGRect frame=view.frame;
        if (i==index) {
            frame.size.height+=plusHeight;
        }else{
            frame.origin.y+=plusHeight;
        }
        view.frame=frame;
    }
    _scrollView.contentSize=CGSizeMake(KWidth, _scrollView.contentSize.height+plusHeight);
}
- (IBAction)call:(id)sender
{
    [Tool callPhone:_phoneNumber];
}
- (IBAction)clibkBrokerInfo:(id)sender
{
    XSHouseBrokerInfoViewController *info=[XSHouseBrokerInfoViewController controllerWithStoryboard:@"Home" andIdentify:@"XSHouseBrokerInfoViewController"];
    info.brokerId=_model.createUserId;
    
    [self.navigationController pushViewController:info animated:YES];
}

@end
