//
//  CommunityView.m
//  HouseBank
//
//  Created by 植梧培 on 14-9-21.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CommunityInfoView.h"
#import "CommunityBean.h"
#import "CommunityImageBean.h"
#import "MoreInfos.h"
#import "XSCycleScrollView.h"
@interface CommunityInfoView()<BMKMapViewDelegate,CycleScrollViewDelegate>
{
    XSCycleScrollView *_cycle;
}

@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
#pragma mark -
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *shop;

@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *hospital;

@property (weak, nonatomic) IBOutlet UILabel *cate;
@property (weak, nonatomic) IBOutlet UILabel *configuration;
@property (weak, nonatomic) IBOutlet UILabel *other;

@property (weak, nonatomic) IBOutlet UILabel *bus;
@property (weak, nonatomic) IBOutlet UILabel *subway;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UILabel *communityName;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *moreInfo;

#pragma mark -
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *houseNum;
@property (weak, nonatomic) IBOutlet UILabel *propertyType;
@property (weak, nonatomic) IBOutlet UILabel *completionDate;
@property (weak, nonatomic) IBOutlet UILabel *propertyCorp;

@property (weak, nonatomic) IBOutlet UILabel *developerCorp;

#pragma mark -
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UIView *pageView;

@end
@implementation CommunityInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(CommunityInfoView *)[ViewUtil xibView:@"CommunityInfoView"];
        UIScrollView *view=self.subviews[0];
        view.contentSize=view.frame.size;
        self.frame = frame;
    }
    return self;
}
-(void)setCommunity:(CommunityBean *)community
{
    _community=community;
    [self setupHeaderView];
    [self refreshMap];
    [self refreshCommunity];
}

#pragma mark - 显示隐藏地图
-(void)showMap
{
    if ([_community.longitude isEqualToString:@"0"]||[_community.longitude isEqualToString:@""]) {
        [_mapView viewWillAppear];
        _mapView.delegate=self;
    }
    
}
-(void)hideMap
{
    if ([_community.longitude isEqualToString:@"0"]||[_community.longitude isEqualToString:@""]) {
        [_mapView viewWillDisappear];
        _mapView.delegate=nil;
    }
    
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
#pragma mark - 显示小区
-(void)refreshCommunity
{
    _price.text=[NSString stringWithFormat:@"%@元/m²",_community.price];
    _houseNum.text=[NSString stringWithFormat:@"%@套",_community.houseNum];
    _propertyType.text=_community.propertyType;
    _completionDate.text=_community.completionDate;
    _developerCorp.text=_community.developerCorp;
    _propertyCorp.text=_community.propertyCorp;
    _communityName.text=_community.community;
    _address.text=_community.address;
    _moreInfo.text=[Tool stringWithHtml:_community.moreInfos.t_1];
    [self plusHeightForAjdFrameWithLabel:_moreInfo];
    _bus.text=[Tool stringWithHtml:_community.moreInfos.t_5];
    [self plusHeightForAjdFrameWithLabel:_bus];
    _subway.text=[Tool stringWithHtml:_community.moreInfos.t_6];
    [self plusHeightForAjdFrameWithLabel:_subway];
    _school.text=[Tool stringWithHtml:[NSString stringWithFormat:@"%@,%@,%@,%@",_community.moreInfos.t_12,_community.moreInfos.t_13,_community.moreInfos.t_14,_community.moreInfos.t_15]];//学校
    [self plusHeightForAjdFrameWithLabel:_school];
    
    _shop.text=[Tool stringWithHtml:_community.moreInfos.t_4];//购物
    [self plusHeightForAjdFrameWithLabel:_shop];
    
    _bank.text=[Tool stringWithHtml:_community.moreInfos.t_2];//银行
    [self plusHeightForAjdFrameWithLabel:_bank];
    
    _hospital.text=[Tool stringWithHtml:_community.moreInfos.t_9];//医保
    [self plusHeightForAjdFrameWithLabel:_hospital];
    _cate.text=[Tool stringWithHtml:_community.moreInfos.t_3];//餐饮
    [self plusHeightForAjdFrameWithLabel:_cate];
    
    _configuration.text=[Tool stringWithHtml:_community.moreInfos.t_10];
    [self plusHeightForAjdFrameWithLabel:_configuration];
    
    _other.text=[Tool stringWithHtml:_community.moreInfos.t_255];
    [self plusHeightForAjdFrameWithLabel:_other];
    
    
}
#pragma mark - 调整高度
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
#pragma mark - 点击地图
- (IBAction)mapClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(communityInfo:didClickMapView:)]) {
        [_delegate communityInfo:self didClickMapView:_mapView.centerCoordinate];
    }
}
#pragma mark - 初始化滚动广告
-(void)setupHeaderView
{
    
    if (_community.images.count==0) {
        _page.hidden=YES;
        _pageView.hidden=YES;
        return;
    }
    _headerImage.hidden=YES;
    NSMutableArray *photos=[NSMutableArray array];
    [_community.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CommunityImageBean *image=obj;
        [photos addObject:image.imagePath];
        
    }];
    
    _cycle = [[XSCycleScrollView alloc] initWithFrame:_header.bounds
                                       cycleDirection:CycleDirectionLandscape
                                             pictures:photos defaultImg:nil];
    _cycle.delegate = self;
    _page.numberOfPages=photos.count;
    [_header addSubview:_cycle];
    [_header sendSubviewToBack:_cycle];
    
}
-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didScrollImageView:(int)index
{
    _page.currentPage=index-1;
}

-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didSelectImageView:(int)index
{
    
}
-(void)dealloc
{
    _cycle.delegate=nil;
}
#pragma mark - 删除地图
-(void)deleteMapView
{
    _mapView.delegate=nil;
    [self adjForDeleteScrollView:_mapView.superview andPlusHeight:_mapView.superview.frame.size.height];
    [_mapView.superview removeFromSuperview];
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
@end
