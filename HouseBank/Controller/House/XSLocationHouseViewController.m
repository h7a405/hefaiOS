//
//  XSLocationHouseViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSLocationHouseViewController.h"
#import "XSLocationHouseTitleView.h"
#import "SelectMoreTypeView.h"
#import "SelectPrice.h"
#import "FilterView.h"
#import "MJRefresh.h"
#import "XSSelectDistanceView.h"
#import "HouseListCell.h"
#import "HouseInfoViewController.h"
#import "House.h"
#import "AFNetworking.h"
#import "BMapKit.h"
#import "MBProgressHUD+Add.h"
#import "HouseWsImpl.h"

@interface XSLocationHouseViewController ()<SelectMoreTypeViewDelegate,SelectPriceDelegate,FilterViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,XSSelectDistanceViewDelegate>
{
    SelectMoreTypeView *_selectMore;
    XSLocationHouseTitleView *_locationTitle;
    FilterView *_filterView;
    SelectPrice *_priceView;
    XSSelectDistanceView *_distanceView;
    BMKGeoCodeSearch* _searcher;//反地理位置编码
    NSMutableArray *_data;
    AFHTTPRequestOperationManager *_request;
    
    
    BMKLocationService *_location;
    CLLocationManager *_manager;
    
    
    NSString *_keyWord;
    NSString *_regionId;
    NSString *_priceFrom;
    NSString *_priceTo;
    NSString *_areaFrom;
    NSString *_areaTo;
    NSString *_roomFrom;
    NSString *_roomTo;
    NSString *_pt;//经纬度
    NSString *_d;//附近多少公里，默认3
    NSString *_brokerId;
    NSString *_tradeType;//1:出售 2:出租
    NSString *_purpose;//(1:住宅 2:写字楼 3:商铺 4:厂房)
    NSString *_ctime;//发布时间范围：0：不限1：当日2：三天内3：一周内4：二周内5：一月内6：三月内7：半年内8：一年内9：一年之前
    NSString *_sort;//排序字段：升序用正数表示，降序用负数表示0：不排序（pt参数生效时，按距离由近到远排序）1：发布时间2：价格3：面积
    NSInteger _pageNo;//页码
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;


@end

@implementation XSLocationHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllParam];
    _locationTitle=[[XSLocationHouseTitleView alloc]init];
    if (_houseType==HouseTypeRent) {
        _locationTitle.title.text=@"附近租房";
    }
    self.navigationItem.titleView=_locationTitle;
    [self setupSelectTypeView];
    [self setupTableView];
    [self getLocationInfo:nil];
}

#pragma mark - 初始化所有参数
-(void)initAllParam
{
    _data=[NSMutableArray array];
    
    _keyWord=@"";
    _regionId=@"0";
    _priceFrom=@"0";
    _priceTo=@"0";
    _areaFrom=@"0";
    _areaTo=@"0";
    _roomFrom=@"0";
    _roomTo=@"0";
    _pt=@"";
    _d=@"3";
    _brokerId=@"";
    _tradeType=@"";
    _purpose=@"";
    _ctime=@"";
    _sort=@"0";
    _pageNo=0;
    
}
#pragma mark - 初始化选择类型
-(void)setupSelectTypeView
{
    SelectMoreTypeView *view=[[SelectMoreTypeView alloc]init];
    view.delegate=self;
    _selectMore=view;
    if (_houseType==HouseTypeRent) {
        view.prictButtonTitle=@"租金";
    }
    [view setButton1Title:@"距离"];
    [self.view addSubview:view];
    
    
}
#pragma mark - 初始化view
-(void)setupTableView{
    //_tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
    [_tableView headerBeginRefreshing];
}

#pragma mark - 刷新数据
-(void)headerRefenre{
    _noDataView.hidden=YES;
    _pageNo=1;
    [self getDataFormServer];
}

-(void)footerReference{
    _pageNo++;
    [self getDataFormServer];
}

#pragma mark -选择显示类型
-(void)selectMoreView:(SelectMoreTypeView *)view didClickButtonIndex:(NSInteger)index
{
    if (index==2) {
        if (_filterView==nil) {
            FilterView *filter=[[FilterView alloc]init];
            filter.delegate=self;
            filter.clickButtonFrame=CGRectMake(0, CGRectGetMaxY(_selectMore.frame), 0, 0);
            
            NSMutableArray *tmp=[NSMutableArray array];
            NSMutableArray *names=[NSMutableArray array];
            NSMutableArray *moreData=[NSMutableArray array];
            
            NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"]];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dict=obj;
                [names addObject:dict[@"name"]];
                [moreData addObject:dict[@"data"]];
                
            }];
            [tmp addObject:names];
            [tmp addObject:moreData];
            
            filter.data=tmp;
            _filterView=filter;
        }
        
        [_filterView show];
        
        
    }else if (index==0){
        if (_distanceView==nil) {
            _distanceView=[[XSSelectDistanceView alloc]init];
            _distanceView.delegate=self;
        }
        [_distanceView show];
        
    }else{
        if (_priceView==nil) {
            NSString *file=nil;
            if (_houseType==HouseTypeSell) {
                file=@"Price";
            }else{
                file=@"Rent";
            }
            NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:file withExtension:@"plist"]];
            _priceView=[[SelectPrice alloc]initWithFrame:CGRectZero andData:data];
            _priceView.delegate=self;
        }
        [_priceView show];
    }
    
}
#pragma mark -   筛选代理
#pragma mark  - 排序
-(void)filterView:(FilterView *)view didSelectSort:(NSString *)sort
{
    _sort=sort;
    [_tableView headerBeginRefreshing];
}
#pragma mark - 房型
-(void)filterView:(FilterView *)view didSelectRoomNumWithBegin:(NSString *)begin andEnd:(NSString *)end
{
    _roomFrom=begin;
    _roomFrom=end;
    [_tableView headerBeginRefreshing];
}
#pragma mark - 面积
-(void)filterView:(FilterView *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end
{
    _areaFrom=begin;
    _areaTo=end;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 价格
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end
{
    _priceFrom=begin;
    _priceTo=end;
    [_tableView headerBeginRefreshing];
}
#pragma mark - 选择距离
-(void)selectDistanceView:(XSSelectDistanceView *)view didSelectDistance:(NSString *)distance
{
    _d=distance;
    [_tableView headerBeginRefreshing];
}

#pragma mark - tableview 代理/数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HouseListCell"];
    if (cell==nil) {
        cell=[[HouseListCell alloc]init];
    }
    if (HouseTypeSell==_houseType) {
        cell.isSell=YES;
    }
    cell.house=_data[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"LocationHouseInfo" sender:[tableView cellForRowAtIndexPath:indexPath]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99.f;
}
#pragma mark - 页面跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LocationHouseInfo"]) {
        HouseListCell *cell=sender;
        HouseInfoViewController *info=segue.destinationViewController;
        info.houseId=cell.houseId;
        info.type=_houseType;
    }
}
#pragma mark - 定位服务
- (IBAction)getLocationInfo:(id)sender
{
#ifndef iOS8
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined&&[[UIDevice currentDevice].systemVersion floatValue]>=8.0){//ios8最新定位操作必须介样,
        
        _manager=[[CLLocationManager alloc]init];
        [_manager requestAlwaysAuthorization];
    }
#endif
    if (_location==nil) {
        _location=[[BMKLocationService alloc]init];
        _location.delegate=self;
    }
    [_location startUserLocationService];
}

#pragma mark - 地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (BMK_SEARCH_NO_ERROR == error) {
        [_locationTitle setLocationContent:result.address];
        [_tableView headerBeginRefreshing];
    }
}

#pragma mark - 定位成功
-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    [_location stopUserLocationService];
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    _pt=[NSString stringWithFormat:@"%f,%f",pt.latitude,pt.longitude];
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
}


#pragma  mark - 请求网络数据
-(void)getDataFormServer{
    if (_request) {
        [_request.operationQueue cancelAllOperations];
        _request = nil;
    }

    HouseWsImpl *ws = [HouseWsImpl new];
    _request = [ws nearbyHouseList:_regionId priceFrom:_priceFrom priceTo:_priceTo areaFrom:_areaFrom areaTo:_areaTo roomFrom:_roomFrom roomTo:_roomTo tradeType:_houseType sort:_sort pageNo:_pageNo pt:_pt d:_d result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (_pageNo==1) {
                [_data removeAllObjects];
            }
            
            NSArray *data=[result objectForKey:@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                House *house=[House modelObjectWithDictionary:obj];
                [_data addObject:house];
            }];
            if (_data.count==0) {
                _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                _noDataView.hidden=NO;
            }else{
                _noDataView.hidden=YES;
                _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
            }
            [_tableView reloadData];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
        
        if (_pageNo==1) {
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
    }];
    
}

-(void)dealloc
{
    _location.delegate=nil;
    _searcher.delegate=nil;
}

@end
