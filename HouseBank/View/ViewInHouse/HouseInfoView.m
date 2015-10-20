//
//  HouseInfo.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseInfoView.h"
#import "HouseInfoBean.h"
#import "MoreInfos.h"
#import "CommunityBean.h"
#import "HouseInfoBGView.h"
#import "XSCycleScrollView.h"
#import "HouseInfoImageBean.h"
#import "BrokerInfoBean.h"
#import "URLCommon.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "NSString+Helper.h"
#import "UIImageView+WebCache.h"
#import "FYCallHistoryDao.h"
#import "FYUserDao.h"
@interface HouseInfoView()<CycleScrollViewDelegate>
{
    XSCycleScrollView *_cycle;
}
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *houseId;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *leftCommission;
@property (weak, nonatomic) IBOutlet UILabel *rightCommission;
@property (weak, nonatomic) IBOutlet UILabel *sellerDivided;
@property (weak, nonatomic) IBOutlet UILabel *buyerDivided;
@property (weak, nonatomic) IBOutlet UILabel *advTitle;
@property (weak, nonatomic) IBOutlet UILabel *buildArea;
@property (weak, nonatomic) IBOutlet UILabel *houseFloor;
@property (weak, nonatomic) IBOutlet UILabel *buildYear;

@property (weak, nonatomic) IBOutlet UILabel *bedRooms;
@property (weak, nonatomic) IBOutlet UILabel *decorationState;
@property (weak, nonatomic) IBOutlet UILabel *toward;
@property (weak, nonatomic) IBOutlet UILabel *advDesc;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
#pragma mark -
@property (weak, nonatomic) IBOutlet UILabel *schoolTitle;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *shopTitle;
@property (weak, nonatomic) IBOutlet UILabel *shop;
@property (weak, nonatomic) IBOutlet UILabel *bankTitle;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *hospitalTitle;
@property (weak, nonatomic) IBOutlet UILabel *hospital;
@property (weak, nonatomic) IBOutlet UILabel *cateTitle;
@property (weak, nonatomic) IBOutlet UILabel *cate;
@property (weak, nonatomic) IBOutlet UILabel *configurationTitle;
@property (weak, nonatomic) IBOutlet UILabel *configuration;
@property (weak, nonatomic) IBOutlet HouseInfoBGView *communityView;
@property (weak, nonatomic) IBOutlet UILabel *other;
@property (weak, nonatomic) IBOutlet HouseInfoBGView *traffic;

@property (weak, nonatomic) IBOutlet UILabel *bus;
@property (weak, nonatomic) IBOutlet UILabel *subway;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UILabel *communityName;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UILabel *commonityName;
#pragma mark -
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *mobilephone;
@property (weak, nonatomic) IBOutlet UILabel *authStatus;
@property (weak, nonatomic) IBOutlet UIImageView *brokerIcon;


@end
@implementation HouseInfoView

@synthesize isBusiness = _isBusiness;

- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(HouseInfoView *)[ViewUtil xibView:@"HouseInfoView"];
        UIScrollView *view=self.subviews[0];
        view.contentSize=view.frame.size;
    }
    return self;
}
#pragma mark - 打电话
- (IBAction)callPhone:(id)sender {
    FYCallHistoryDao *dao = [FYCallHistoryDao new];
    [dao saveCallHistoryWithHouseId:_houseInfo.houseId andHouseType:[NSString stringWithFormat:@"%d",_type+1]];
    if (_broker.mobilephone) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_broker.mobilephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 查看小区
- (IBAction)communityClick:(id)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(houseInfo:didClickCommunityView:)]) {
        [_delegate houseInfo:self didClickCommunityView:_community];
    }
}
#pragma mark - 点击地图
- (IBAction)mapClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(houseInfo:didClickMapView:)]) {
        [_delegate houseInfo:self didClickMapView:_mapView.centerCoordinate];
    }
}
#pragma mark - 显示隐藏地图
-(void)showMap{
    if ([_community.longitude isEqualToString:@"0"]||[_community.longitude isEqualToString:@""]) {
        [_mapView viewWillAppear];
        _mapView.delegate=self;
    }
}

-(void)hideMap{
    if ([_community.longitude isEqualToString:@"0"]||[_community.longitude isEqualToString:@""]) {
        [_mapView viewWillDisappear];
        _mapView.delegate=nil;
    }
}

#pragma mark - 刷新界面数据
-(void)refreshData{
    FYUserDao *dao = [FYUserDao new];
    BOOL isLogin = [dao isLogin];
    if (!isLogin) {
        [self deleteYongJin];
    }
    
    [self setupHeader];
    [self refreshMap];
    [self refreshUserInfo];
    _houseId.text=_houseInfo.houseId;
    NSString *danwei=nil;
    if (_type==HouseTypeRent) {
        if (_isBusiness) {
            danwei = @"元/天.平米";
        }else{
            danwei=@"元/月";
        }
    }else{
        danwei=@"万";
    }
    _showCount.attributedText=[ViewUtil content:[NSString stringWithFormat:@"已有%@人查看",_count] colorString:_count];
    _totalPrice.text=[NSString stringWithFormat:@"%.2f%@",_houseInfo.totalPrice.floatValue,danwei];
    _createTime.text=_houseInfo.createTime;
    _leftCommission.text=[NSString stringWithFormat:@"%@%%",_houseInfo.leftCommission];
    _rightCommission.text=[NSString stringWithFormat:@"%@%%",_houseInfo.rightCommission];
    _sellerDivided.text=[NSString stringWithFormat:@"%@%%",_houseInfo.sellerDivided];
    _buyerDivided.text=[NSString stringWithFormat:@"%@%%",_houseInfo.buyerDivided];
    _advTitle.text=_houseInfo.advTitle;
    _buildArea.text=[NSString stringWithFormat:@"%@平",_houseInfo.buildArea];
    _bedRooms.text=[NSString stringWithFormat:@"%@房%@厅",_houseInfo.bedRooms,_houseInfo.livingRooms];
    _houseFloor.text=[NSString stringWithFormat:@"%@/%@",_houseInfo.houseFloor,_houseInfo.totalFloor];
    _decorationState.text=[Tool decorationStateWithType:_houseInfo.decorationState];
    _toward.text=[Tool towartWithTypeString:_houseInfo.toward];
    _buildYear.text=_houseInfo.buildYear;
    
    NSString *html =[NSString stringWithFormat:@"%@",_houseInfo.advDesc];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];
    _advDesc.text=attrString.string;
    
    [self adjFrameWithLabel:_advDesc];
    [self refreshCommunity];
    
}

-(void)adjFrameWithLabel:(UILabel *)label{
    NSDictionary *dict=@{NSFontAttributeName: label.font};
    CGRect rect=[label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size=rect.size;
    CGRect frame=label.frame;
    CGFloat plusHeight=size.height-frame.size.height;
    if (size.height<label.frame.size.height) {
        return;
    }
    frame.size.height=size.height;
    label.frame=frame;
    UIView *tmp=label.superview;
    [self adjScrollView:tmp andPlusHeight:plusHeight];
}
#pragma mark - 刷新小区信息
-(void)refreshCommunity
{
    _communityName.text=_community.address;
    _commonityName.text=_community.community;
    _bus.text=[Tool stringWithHtml:_community.moreInfos.t_5];
    [self plusHeightForAjdFrameWithLabel:_bus];
    [self checkLabelValue:_bus];
    _subway.text=[Tool stringWithHtml:_community.moreInfos.t_6];
    [self plusHeightForAjdFrameWithLabel:_subway];
    [self checkLabelValue:_subway];
    _school.text=[Tool stringWithHtml:[NSString stringWithFormat:@"%@,%@,%@,%@",_community.moreInfos.t_12,_community.moreInfos.t_13,_community.moreInfos.t_14,_community.moreInfos.t_15]];//学校
    [self plusHeightForAjdFrameWithLabel:_school];
    if ([_community.moreInfos.t_12 isEmptyString]&&[_community.moreInfos.t_14 isEmptyString]&&[_community.moreInfos.t_13 isEmptyString]&&[_community.moreInfos.t_15 isEmptyString]) {
        _school.text=@"";
        [self checkLabelValue:_school];
    }
    _shop.text=[Tool stringWithHtml:_community.moreInfos.t_4];//购物
    [self plusHeightForAjdFrameWithLabel:_shop];
    [self checkLabelValue:_shop];
    _bank.text=[Tool stringWithHtml:_community.moreInfos.t_2];//银行
    [self plusHeightForAjdFrameWithLabel:_bank];
    [self checkLabelValue:_bank];
    _hospital.text=[Tool stringWithHtml:_community.moreInfos.t_9];//医保
    [self plusHeightForAjdFrameWithLabel:_hospital];
    [self checkLabelValue:_hospital];
    _cate.text=[Tool stringWithHtml:_community.moreInfos.t_3];//餐饮
    [self plusHeightForAjdFrameWithLabel:_cate];
    [self checkLabelValue:_cate];
    _configuration.text=[Tool stringWithHtml:_community.moreInfos.t_10];
    [self plusHeightForAjdFrameWithLabel:_configuration];
    [self checkLabelValue:_configuration];
    _other.text=[Tool stringWithHtml:_community.moreInfos.t_255];
    [self plusHeightForAjdFrameWithLabel:_other];
    [self checkLabelValue:_other];
    
}
#pragma mark - 调整界面
-(void)plusHeightForAjdFrameWithLabel:(UILabel *)label
{
    
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
#pragma mark - 头部广告图
-(void)setupHeader{
    NSMutableArray *urls=[NSMutableArray array];
    [_houseInfo.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HouseInfoImageBean *image=obj;
        [urls addObject:image.imagePath];
    }];
    
    if (urls.count==0) {
        _page.hidden=YES;
        _pageView.hidden=YES;
        return;
    }
    _headerImage.hidden=YES;
    _cycle = [[XSCycleScrollView alloc] initWithFrame:_header.bounds
                                       cycleDirection:CycleDirectionLandscape
                                             pictures:urls defaultImg:nil];
    _cycle.delegate = self;
    _page.numberOfPages=urls.count;
    _pageView.hidden=NO;
    [_header addSubview:_cycle];
    [_header sendSubviewToBack:_cycle];
    
    
}
-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didSelectImageView:(int)index
{
    NSMutableArray *photos=[NSMutableArray array];
    [_houseInfo.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MJPhoto *photo=[[MJPhoto alloc]init];
        HouseInfoImageBean *image=obj;
        photo.url=[NSURL URLWithString:image.imagePath];
        [photos addObject:photo];
    }];
    MJPhotoBrowser *browser=[[MJPhotoBrowser alloc]init];
    browser.photos=photos;
    browser.currentPhotoIndex=index-1;
    [browser show];
    
    
    
}
-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didScrollImageView:(int)index
{
    _page.currentPage=index-1;
}
#pragma mark - 刷新地图
-(void)refreshMap
{
    if ([_community.longitude isEqualToString:@"0"]||[_community.longitude isEqualToString:@""]) {
        
        [self deleteMapView];
        
        return;
    }
    _mapView.centerCoordinate=CLLocationCoordinate2DMake([_community.latitude doubleValue], [_community.longitude doubleValue]);
    _mapView.zoomLevel=16;
    
    
    //添加标注
    
    BMKPointAnnotation*    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude =[_community.latitude doubleValue];
    coor.longitude =[_community.longitude doubleValue];
    pointAnnotation.coordinate = coor;
    [_mapView addAnnotation:pointAnnotation];
}
#pragma mark - 用户资料
-(void)refreshUserInfo
{
    _name.text=[NSString stringWithFormat:@"%@",_broker.name];
    _company.text=_broker.company;
    _store.text=_broker.store;
    _mobilephone.text=[NSString stringWithFormat:@"%@",_broker.mobilephone];
    _authStatus.text=[Tool authStatus:[NSString stringWithFormat:@"%@",_broker.authStatus]];
    if (![_broker.brokerHeadImg isKindOfClass:[NSNull class]]) {//设置用户头像
        NSString *url = [URLCommon buildImageUrl:_broker.brokerHeadImg imageSize:L03 brokerId:_broker.brokerId];
        [_brokerIcon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nophoto"]];
    }
    
}
#pragma mark - 点击查看经纪人信息
- (IBAction)clickBrokerInfo:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(houseInfo:didClickBrokerInfo:)]) {
        [_delegate houseInfo:self didClickBrokerInfo:_houseInfo.brokerId];
    }
}
#pragma mark - 看房申请
- (IBAction)applyLookHouse:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(houseInfo:didClickApplyLookHouse:)]) {
        [_delegate houseInfo:self didClickApplyLookHouse:_houseInfo];
    }
}
#pragma mark - 调整界面
-(void)checkLabelValue:(UILabel *)label
{
    if ([label.text isEmptyString]||[[label.text trimString]isEmptyString]) {
        UIView *view=label.superview;
        label.hidden=YES;
        UILabel *title=[view.subviews objectAtIndex:[view.subviews indexOfObject:label]-1];
        title.hidden=YES;
        
        NSInteger index=[label.superview.subviews indexOfObject:label];
        
        for (int i =index; i<label.superview.subviews.count; i++) {
            UIView *view=label.superview.subviews[i];
            CGRect frame=view.frame;
            
            frame.origin.y-=29;
            
            
            view.frame=frame;
        }
        
        [self adjForDeleteScrollView:view andPlusHeight:29];
    }
}
-(void)deleteMapView
{
    _mapView.delegate=nil;
    [self adjForDeleteScrollView:_mapView.superview andPlusHeight:_mapView.superview.frame.size.height];
    [_mapView.superview removeFromSuperview];
}
#pragma mark - 删除佣金一栏
-(void)deleteYongJin
{
    [self adjForDeleteScrollView:_leftCommission.superview andPlusHeight:_leftCommission.superview.frame.size.height];
    [_leftCommission.superview removeFromSuperview];
}
-(void)adjForDeleteScrollView:(UIView *)view andPlusHeight:(CGFloat)plusHeight
{
    NSInteger index=[_scrollView.subviews indexOfObject:view];
    for (int i=index; i<_scrollView.subviews.count; i++) {
        UIView *view=_scrollView.subviews[i];
        CGRect frame=view.frame;
        if (i==index) {
            frame.size.height-=plusHeight;
        }else{
            frame.origin.y-=plusHeight;
        }
        view.frame=frame;
    }
    _scrollView.contentSize=CGSizeMake(KWidth, _scrollView.contentSize.height-plusHeight);
}
-(void)dealloc
{
    _mapView.delegate=nil;
    _mapView=nil;
    _cycle.delegate=nil;
}
@end
