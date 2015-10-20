//
//  XSNewHouseInfoView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNewHouseInfoView.h"
#import "XSCycleScrollView.h"
#import "NewHouseInfoBean.h"
#import "CommunityBean.h"
#import "CommunityImageBean.h"
#import "NewHouseTypeBean.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MoreInfos.h"
#import "HouseInfoBGView.h"
#import "XSHouseTypeView.h"
#import "NSString+Helper.h"
#import "FYCallHistoryDao.h"
#import "FYUserDao.h"

@interface XSNewHouseInfoView()<CycleScrollViewDelegate,BMKMapViewDelegate>
{
    XSCycleScrollView *_cycle;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *averagePrice;
@property (weak, nonatomic) IBOutlet UILabel *commissionRate;

#pragma mark - 房产项目介绍
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *propertyType;
@property (weak, nonatomic) IBOutlet UILabel *developer;
@property (weak, nonatomic) IBOutlet UILabel *propertyCorp;
@property (weak, nonatomic) IBOutlet UILabel *wuyeleixing;//propertyType同为这个名，命名冲突
@property (weak, nonatomic) IBOutlet UILabel *openDate;
@property (weak, nonatomic) IBOutlet UILabel *deliverDate;
@property (weak, nonatomic) IBOutlet UILabel *greeningRate;
@property (weak, nonatomic) IBOutlet UILabel *volumeRate;
@property (weak, nonatomic) IBOutlet UILabel *propertyYear;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *manageFee;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
#pragma mark - 优惠活动
@property (weak, nonatomic) IBOutlet UILabel *customerDiscount;

#pragma mark -
@property (weak, nonatomic) IBOutlet UILabel *about;

@property (weak, nonatomic) IBOutlet UILabel *bus;
@property (weak, nonatomic) IBOutlet UILabel *subwas;
@property (weak, nonatomic) IBOutlet UILabel *shop;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *hospital;
@property (weak, nonatomic) IBOutlet UILabel *configuration;
@property (weak, nonatomic) IBOutlet UILabel *other;
@property (weak, nonatomic) IBOutlet UILabel *cate;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *brokerLinkman;
@property (weak, nonatomic) IBOutlet UILabel *canteen;
@property (weak, nonatomic) IBOutlet UILabel *recreation;
@property (weak, nonatomic) IBOutlet UIImageView *yjBack;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet HouseInfoBGView *houseTypeView;
@property (weak, nonatomic) IBOutlet UILabel *brokerPhone;
/**
 *  设置格式，无别的用处
 */
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) IBOutlet UIButton *yongjinBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiangliBtn;


@end
@implementation XSNewHouseInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(XSNewHouseInfoView *)[ViewUtil xibView:@"XSNewHouseInfoView"];
        _scrollView.contentSize=_scrollView.frame.size;
        [self changeButtonStyle:_button1];
        [self changeButtonStyle:_button2];
        
        if(![FYUserDao new].isLogin){
            [self adjForDeleteScrollView:_yongjinBtn.superview andPlusHeight:_yongjinBtn.frame.size.height+10];
            [_commissionRate removeFromSuperview];
            [_yjBack removeFromSuperview];
            [_yongjinBtn removeFromSuperview];
            [_jiangliBtn removeFromSuperview];
            
        }
    }
    
    return self;
}
- (IBAction)call:(id)sender{
    FYCallHistoryDao  *dao = [FYCallHistoryDao new];
    
    [dao saveCallHistoryWithHouseId:_info.projectId andHouseType:@"3"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_info.brokerPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)applyFor:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(xsNewHouseInfoViewDidClickApplyFor:)]) {
        [_delegate xsNewHouseInfoViewDidClickApplyFor:self];
    }
}

- (IBAction)commissionClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(xsNewHouseInfoViewdidClickCommission:)]) {
        [_delegate xsNewHouseInfoViewdidClickCommission:self];
    }
}
- (IBAction)awardClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(xsNewHouseInfoViewdidClickaAward:)]) {
        [_delegate xsNewHouseInfoViewdidClickaAward:self];
    }
}
- (IBAction)mapClick:(UITapGestureRecognizer *)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(xsNewHouseInfoView:didClickMapView:)]){
        [_delegate xsNewHouseInfoView:self didClickMapView:_mapView.centerCoordinate];
    }
}

-(void)refreshView
{
    
#pragma mark  - 第一块
    [self setupHeader];
#pragma mark - 第二块
    _projectName.text=_info.projectName;
    _averagePrice.text=[NSString stringWithFormat:@"%@元/平米",_info.averagePrice];
    _commissionRate.text=[NSString stringWithFormat:@"佣金比例\n%@",_info.commissionRate];
    
#pragma mark - 第三块
    _region.text=_community.region;
    _propertyType.text=_info.propertyType;
    _developer.text=_info.developer;
    _propertyCorp.text=_community.propertyCorp;
    _wuyeleixing.text=_community.propertyType;
    _openDate.text=_info.openDate;
    _deliverDate.text=_info.deliverDate;
    _greeningRate.text=_info.greeningRate;
    _volumeRate.text=_info.volumeRate;
    _propertyYear.text=_info.propertyYear;
    _payment.text=_info.payment;
    _manageFee.text=_info.manageFee;
#pragma mark - 地图
    _address.text=_community.address;
    [self refreshMap];
#pragma mark - 优惠活动
    _customerDiscount.text=_info.customerDiscount;
    [self plusHeightForAjdFrameWithLabel:_customerDiscount];
#pragma mark - 楼盘介绍
    _about.attributedText=[ViewUtil content:_community.moreInfos.t_1 colorString:@""];
    [self plusHeightForAjdFrameWithLabel:_about];
#pragma mark - 房型
    if(_houseTypes.count>0){
        __block CGFloat tmpHeight=0;
        [_houseTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XSHouseTypeView *type=[[XSHouseTypeView alloc]init];
            if (tmpHeight==0) {
                tmpHeight=type.frame.size.height;
            }
            type.propertyTypeString=_info.propertyType;
            type.type=obj;
            type.tag=idx;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHouseType:)];
            [type addGestureRecognizer:tap];
            type.frame=CGRectMake(0, type.frame.size.height*idx+38, 0, 0);
            [_houseTypeView addSubview:type];
            [type reloadData];
        }];
        [self adjScrollView:_houseTypeView andPlusHeight:(tmpHeight*(_houseTypes.count-1))];
    }
#pragma mark - 交通
    _bus.text=[Tool stringWithHtml:_community.moreInfos.t_5];
    [self plusHeightForAjdFrameWithLabel:_bus];
    [self checkLabelValue:_bus];
    _subwas.text=[Tool stringWithHtml:_community.moreInfos.t_6];
    [self plusHeightForAjdFrameWithLabel:_subwas];
    [self checkLabelValue:_subwas];
#pragma mark - 周边配套
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
    _recreation.text=[Tool stringWithHtml:_community.moreInfos.t_8];
    [self plusHeightForAjdFrameWithLabel:_recreation];
    [self checkLabelValue:_recreation];
    _configuration.text=[Tool stringWithHtml:_community.moreInfos.t_10];
    [self plusHeightForAjdFrameWithLabel:_configuration];
    [self checkLabelValue:_configuration];
    _canteen.text=[Tool stringWithHtml:_community.moreInfos.t_11];
    [self plusHeightForAjdFrameWithLabel:_canteen];
    [self checkLabelValue:_canteen];
    _other.text=[Tool stringWithHtml:_community.moreInfos.t_255];
    [self plusHeightForAjdFrameWithLabel:_other];
    [self checkLabelValue:_other];
#pragma mark - 学校
    _school.text=[Tool stringWithHtml:[NSString stringWithFormat:@"%@,%@,%@,%@",_community.moreInfos.t_12,_community.moreInfos.t_13,_community.moreInfos.t_14,_community.moreInfos.t_15]];//学校
    [self plusHeightForAjdFrameWithLabel:_school];
    if ([_community.moreInfos.t_12 isEmptyString]&&[_community.moreInfos.t_14 isEmptyString]&&[_community.moreInfos.t_13 isEmptyString]&&[_community.moreInfos.t_15 isEmptyString]) {
        _school.text=@"";
        [self checkLabelValue:_school];
    }
#pragma mark - 项目联系人
    _brokerLinkman.text=_info.brokerLinkman;
    _brokerPhone.text=_info.brokerPhone;
    
    
}
/**
 *  点击房子类型
 *
 *  @param tap
 */
-(void)clickHouseType:(UITapGestureRecognizer *)tap
{
    UIView *view=tap.view;
    if (_delegate&&[_delegate respondsToSelector:@selector(xsNewHouseInfoView:didClickHouseTypeAtIndex:)]) {
        [_delegate xsNewHouseInfoView:self didClickHouseTypeAtIndex:view.tag];
    }
}
-(void)changeButtonStyle:(UIButton *)button
{
    button.layer.borderColor=KNavBGColor.CGColor;
    button.layer.borderWidth=1;
}
#pragma mark - 显示地图
-(void)showMap
{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
}
-(void)hideMap
{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
}
#pragma mark - 刷新地图
-(void)refreshMap
{
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
#pragma mark - 头部广告位
-(void)setupHeader
{
    
    NSMutableArray *urls=[NSMutableArray array];
    [_community.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CommunityImageBean *image=obj;
        [urls addObject:image.imagePath];
        
    }];
    if (urls.count==0) {
        _page.hidden=YES;
        _pageView.hidden=YES;
        return;
    }
    _headerImage.hidden=YES;
    _cycle = [[XSCycleScrollView alloc] initWithFrame:_headerView.bounds
                                       cycleDirection:CycleDirectionLandscape
                                             pictures:urls defaultImg:nil];
    _cycle.delegate = self;
    _page.numberOfPages=urls.count;
    _pageView.hidden=NO;
    [_headerView addSubview:_cycle];
    [_headerView sendSubviewToBack:_cycle];
    
    
}
-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didSelectImageView:(int)index
{
    NSMutableArray *photos=[NSMutableArray array];
    [_community.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MJPhoto *photo=[[MJPhoto alloc]init];
        CommunityImageBean *image=obj;
        photo.url=[NSURL URLWithString:image.imagePath];
        [photos addObject:photo];
    }];
    if (_community.images.count==1) {
        MJPhoto *photo=[[MJPhoto alloc]init];
        photo.image=[UIImage imageNamed:@"loading.png"];
        [photos addObject:photo];
        
    }
    MJPhotoBrowser *browser=[[MJPhotoBrowser alloc]init];
    browser.photos=photos;
    browser.currentPhotoIndex=index-1;
    [browser show];
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

-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didScrollImageView:(int)index
{
    _page.currentPage=index-1;
}
#pragma mark - 检查label的值
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
    _cycle.delegate=nil;
}
@end
