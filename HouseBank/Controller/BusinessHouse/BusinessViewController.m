//
//  BusinessViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/19.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BusinessViewController.h"
#import "SelectMoreTypeView.h"
#import "UIScrollView+MJRefresh.h"
#import "HistoryTableView.h"
#import "FYSearchHouseDao.h"
#import "HouseWsImpl.h"
#import "HouseListCell.h"
#import "Constants.h"
#import "Tool.h"
#import "House.h"
#import "TextUtil.h"
#import "ViewUtil.h"
#import "HouseInfoViewController.h"
#import "SelectBlockViewForHouse.h"
#import "AddressSelectView.h"
#import "SelectBlockViewForHouse.h"
#import "FYUserDao.h"
#import "MyCenterWsImpl.h"
#import "MBProgressHUD+Add.h"
#import "SearchHouseTableView.h"
#import "SelectPrice.h"
#import "FilterView.h"


//商业地产
@interface BusinessViewController ()<UISearchBarDelegate,SelectMoreTypeViewDelegate,UITableViewDelegate,HistoryDelegation,UITableViewDataSource,AddressSelectViewDelegate,SelectBlockViewForHouseDelegate,SearchHouseTableViewDelegation,SelectPriceDelegate,FilterViewDelegate>{
    
    __weak UISearchBar *_searchBar ; // 搜索的view
    __weak HistoryTableView *_historyView ; // 搜索历史
    __weak SearchHouseTableView *_searchTableView;
    __weak NSArray *_searchDatas ; // 搜索历史数据
    
    __weak UIView *_noDataView;
    
    SelectPrice *_priceView;
    FilterView *_filterView;
    
    SelectMoreTypeView *_selectView;
    
    NSMutableArray *_officeDatas;
    NSMutableArray *_shopDatas;
    NSArray *_searchDatasFromServer;
    
    CGPoint _indicatorDefaultCenter ;
    
    NSInteger _cachePageNo;
    
    NSString *_searchRegionId;
    
    BOOL _isOffice;
    BOOL _isSell;
    
    BOOL _isDataRefreshing;
    
    BOOL _isOfficeHasFooter;
    BOOL _isShopHasFooter;
    
    // 网络请求参数
    NSInteger _pageNoForOffice ;
    NSInteger _pageNoForShop ;
    
    NSInteger _tradeType;
    NSInteger _purpose;
    NSString *_kw;
    NSString *_regionId;
    NSString *_priceFrom;
    NSString *_priceTo;
    NSString *_areaFrom;
    NSString *_areaTo;
    NSInteger _sort;//排序字段：升序用正数表示，降序用负数表示0：不排序（pt参数生效时，按距离由近到远排序）1：发布时间2：价格3：面积
    
    AddressSelectView *_selectAllCity;
    SelectBlockViewForHouse *_addressSelect;
    
    AFHTTPRequestOperationManager *_searchWs ;
}

-(void) initialize;
-(void) resignSearch;
-(void) registerSearch;
-(void) setupSelectTypeView;//初始化选择类型view
-(void) setupRightNaviButton;// 设置 navigationbar 右键
-(void) invalidateRightNaviButton;// 取消 navigationbar 右键
-(void) invalidateTableViewRefreshing;
-(void) didRightNaviBtnTapped : (id) sender;

-(void) requestDataFromServer ; //请求数据

-(void) moveIndicatorBy : (NSInteger) index;

-(void) headerRefresh : (UITableView *) tableView;
-(void) footerRefresh : (UITableView *) tableView;
-(void) initializeParam ;
-(void) initializeIndicator;

-(void) setupTableFooter : (BOOL) isFooter ;
-(void) setupTableViewNodataView : (BOOL) isHasNatas ;

-(void) doSearch : (NSString *) searchText;


@property (weak, nonatomic) IBOutlet UITableView *houseTableView;

@property (weak, nonatomic) IBOutlet UIView *indicator;

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @autoreleasepool {
        [self initializeIndicator];
        [self initializeParam];
        [self initialize];
    }
}

-(void) initializeParam{
    _officeDatas = [NSMutableArray new];
    _shopDatas = [NSMutableArray new];
    
    _isOffice = YES;
    _isSell = YES;
    
    _tradeType = SALE;
    _purpose = HouseUseTypeWork;
    
    _regionId = [[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityId];
    _sort = DefaultNoSort;
    
    _priceFrom = @"0";
    _priceTo = @"0";
    _areaFrom = @"0";
    _areaTo = @"0";
    _kw = @"";
    _searchRegionId = @"0";
}

-(void) initializeIndicator{
    UIView *view = [[UIView alloc] initWithFrame:_indicator.frame];
    view.backgroundColor = KNavBGColor;
    [_indicator removeFromSuperview];
    _indicator = view;
    
    [self.view addSubview:view];
    
    _indicatorDefaultCenter = _indicator.center;
}

-(void) initialize{
    [self loadBrokerInfo];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:rect(0, 0, 270, 40)];
    searchBar.placeholder = @"搜索商业地产";
    searchBar.delegate = self;
    searchBar.returnKeyType = UIReturnKeyDone;
    
    self.navigationItem.titleView = searchBar;
    
    _searchBar = searchBar;
    
    _houseTableView.delegate = self;
    _houseTableView.dataSource = self;
    _houseTableView.alwaysBounceVertical = YES;
    
    [self setupSelectTypeView];
    
    //添加下拉刷新和上拉刷新
    [_houseTableView addHeaderWithTarget:self action:@selector(headerRefresh:)];
    //    [_houseTableView addFooterWithTarget:self action:@selector(footerRefresh:)];
    
    //  搜索历史
    HistoryTableView *historyView = [[HistoryTableView alloc] initWithFrame:rect(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 226)];
    historyView.delegation = self;
    
    [self.view addSubview:historyView];
    _historyView = historyView;
    
    SearchHouseTableView *searchTableView = [[SearchHouseTableView alloc] initWithFrame:rect(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 226)];
    searchTableView.hidden = YES;
    searchTableView.delegation = self;
    [self.view addSubview:searchTableView];
    
    _searchTableView = searchTableView;
    
    [self resignSearch];
    
    [_houseTableView headerBeginRefreshing];
    
    _houseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//结束搜索
-(void) resignSearch{
    [_searchBar resignFirstResponder];
    [_historyView dismiss];
    [_searchTableView dismiss];
    
    [self invalidateRightNaviButton];
}

//开始搜索
-(void) registerSearch{
    FYSearchHouseDao *historyDao = [FYSearchHouseDao new];
    _searchDatas = [historyDao allSearchHouse];
    
    [_historyView show : _searchDatas];
    [self setupRightNaviButton];
}

-(void) setupTableViewNodataView:(BOOL)isHasNatas{
    BOOL hasDatas = NO;
    if (_isOffice) {
        hasDatas = _officeDatas.count > 0;
    }else{
        hasDatas = _shopDatas.count > 0;
    }
    
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
    
    if (!hasDatas && _noDataView == nil) {
        _noDataView = [ViewUtil xibView:@"NoDataView"];
        [_houseTableView addSubview:_noDataView];
    }
    
}

-(void) headerRefresh:(UITableView *)tableView{
    if (_isOffice) {
        _cachePageNo = _pageNoForOffice;
        _pageNoForOffice = 1;
    }else{
        _cachePageNo = _pageNoForShop;
        _pageNoForShop = 1;
    }
    
    [self requestDataFromServer];
}

-(void) footerRefresh:(UITableView *)tableView{
    [self requestDataFromServer];
}

-(void) invalidateTableViewRefreshing{
    _isDataRefreshing = NO;
    
    [_houseTableView headerEndRefreshing];
    [_houseTableView footerEndRefreshing];
}

-(void) requestDataFromServer{
    _isDataRefreshing = YES;
    _kw = _searchBar.text;
    
    int pageNo = _isOffice ? _pageNoForOffice : _pageNoForShop;
    
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws loadHouse:_regionId priceFrom:_priceFrom priceTo:_priceTo areaFrom:_areaFrom areaTo:_areaTo roomFrom:@"0" roomTo:@"0" tradeType:_tradeType sort:[NSString stringWithFormat:@"%d",_sort] pageNo:pageNo kw:_kw purpose:_purpose result:^(BOOL isSuccess, id result, NSString *data) {
        [self invalidateTableViewRefreshing];
        
        if (isSuccess) {
            if (_isOffice) {
                if (_pageNoForOffice == 1) {
                    [_officeDatas removeAllObjects];
                }
                
            }else{
                if (_pageNoForShop == 1) {
                    [_shopDatas removeAllObjects];
                }
            }
            
            NSArray *data=[result objectForKey:@"data"];
            if (data && [data count]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    House *house=[House modelObjectWithDictionary:obj];
                    
                    if (_isOffice) {
                        [_officeDatas addObject:house];
                    }else{
                        [_shopDatas addObject:house];
                    }
                }];
                
                if (_isOffice) {
                    _pageNoForOffice ++;
                }else{
                    _pageNoForShop ++;
                }
            }
            
            int count = 0;
            int total = [[result objectForKey:@"totalSize"] integerValue];
            if (_isOffice) {
                count = _officeDatas.count;
                _isOfficeHasFooter = count < total && (count != 0);
                [self setupTableFooter:_isOfficeHasFooter];
            }else{
                count = _shopDatas.count;
                _isShopHasFooter = count < total && (count != 0);
                [self setupTableFooter:_isShopHasFooter];
            }
        }else{
            //下载失败 恢复缓存的页码
            if (_isOffice) {
                _pageNoForOffice = _cachePageNo;
            }else{
                _pageNoForShop = _cachePageNo;
            }
        }
        
        [_houseTableView reloadData];
        [self setupTableViewNodataView:NO];
    }];
}

-(void) setupTableFooter : (BOOL) isFooter{
    if (isFooter) {
        [_houseTableView addFooterWithTarget:self action:@selector(footerRefresh:)];
    }else{
        [_houseTableView removeFooter];
    }
};

-(void) setupRightNaviButton{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didRightNaviBtnTapped:)];
    self.navigationItem.rightBarButtonItem = btn;
};

-(void) invalidateRightNaviButton{
    self.navigationItem.rightBarButtonItem = nil;
};

-(void) didRightNaviBtnTapped : (id) sender{
    [self resignSearch];
};

- (IBAction)officeTapped:(id)sender {
    if (!_isOffice && !_isDataRefreshing) {
        _isOffice = YES;
        
        [self moveIndicatorBy:0];
        
        _purpose = HouseUseTypeWork;
        
        [_houseTableView reloadData];
        [_houseTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        if (_officeDatas.count == 0) {
            [_houseTableView headerBeginRefreshing];
        }
        
        [self setupTableViewNodataView:NO];
        
        [_houseTableView headerBeginRefreshing];
    }
}

- (IBAction)shopTapped:(id)sender {
    if (_isOffice && !_isDataRefreshing) {
        _isOffice = NO;
        
        [self moveIndicatorBy:1];
        
        _purpose = HouseUseTypeBusiness;
        
        [_houseTableView reloadData];
        [_houseTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        if (_shopDatas.count == 0) {
            [_houseTableView headerBeginRefreshing];
        }
        
        [self setupTableViewNodataView:NO];
        
        [_houseTableView headerBeginRefreshing];
    }
}

-(void) moveIndicatorBy : (NSInteger) index{
    int width = _indicator.bounds.size.width;
    
    CGPoint center = CGPointMake(_indicatorDefaultCenter.x + width * index, _indicatorDefaultCenter.y);
    
    [UIView animateWithDuration:0.2 animations:^{
        _indicator.center = center;
    }];
};

-(void) doSearch:(NSString *)searchText{
    @autoreleasepool {
        if (_searchWs) {
            [_searchWs.operationQueue cancelAllOperations];
            _searchWs = nil;
        }
        
        if (![TextUtil isEmpty:searchText]) {
            HouseWsImpl *ws = [HouseWsImpl new];
            _searchWs = [ws loadHouseForSearch:searchText pageSize:@"20" regionId:_searchRegionId result:^(BOOL isSuccess, id result, NSString *data) {
                if(isSuccess){
                    _searchTableView.hidden = NO;
                    NSArray *array = result[@"data"];
                    _searchDatasFromServer = array;
                    [_searchTableView refresh:array searchText:searchText];
                }
            }];
        }
    }
}

-(void) dealloc{
    _officeDatas = nil;
    _shopDatas = nil;
    
    _kw = nil;
    _regionId = nil;
    _priceFrom = nil;
    _priceTo = nil;
    _areaFrom = nil;
    _areaTo = nil;
}

#pragma mark - 经纪人信息 - 获取用户所在板块
-(void)loadBrokerInfo{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    if ([userDao isLogin]) {
        MyCenterWsImpl *ws = [MyCenterWsImpl new];
        [ws requestBrokerInfo:KUrlConfig brokerId:user.brokerId result:^(BOOL isSuccess, id result, NSString *data) {
            if (isSuccess) {
                _searchRegionId = result[@"regionId"];
            }else{
                [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            }
        }];
    }
}

#pragma mark - 初始化选择类型
-(void)setupSelectTypeView{
    SelectMoreTypeView *view=[[SelectMoreTypeView alloc]init];
    view.delegate=self;
    
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    
    view.center = CGPointMake(self.view.frame.size.width / 2, 105 + view.frame.size.height/2);
    
    _selectView = view;
}

#pragma mark 选择bar委托
-(void)selectMoreView:(SelectMoreTypeView *)view didClickButtonIndex:(NSInteger)index{
    if (index == 0) {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *cityId=[user objectForKey:KLocationCityId];
        if ([cityId integerValue]==0) {//选择全国城市
            if(_selectAllCity==nil){
                _selectAllCity=[[AddressSelectView alloc]init];
                _selectAllCity.delegate=self;
            }
            [_selectAllCity show];
        }else{//选择指定城市下
            if (_addressSelect==nil) {
                _addressSelect=[[SelectBlockViewForHouse alloc]init];
                _addressSelect.delegate=self;
            }
            [_addressSelect show];
        }
    }else if (index == 1){
        if (_priceView) {
            [_priceView removeFromSuperview];
            _priceView = nil;
        }
        
        if (_priceView==nil) {
            NSString *file=nil;
            if (_isSell) {
                file=@"Price";
            }else{
                if(_isOffice){
                    file=@"RentForBusiness";
                }else{
                    file=@"RentForBusinessShop";
                }
            }
            NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:file withExtension:@"plist"]];
            _priceView=[[SelectPrice alloc]initWithFrame:CGRectZero andData:data];
            _priceView.delegate=self;
        }
        [_priceView show];
    }else{
        if (_filterView) {
            [_filterView removeFromSuperview];
            _filterView = nil;
        }
        
        if (_filterView==nil) {//选择更多
            FilterView *filter=[[FilterView alloc]init];
            filter.delegate=self;
            filter.clickButtonFrame=CGRectMake(0,104, 0, 0);
            [filter show];
            NSMutableArray *tmp=[NSMutableArray array];
            NSMutableArray *names=[NSMutableArray array];
            NSMutableArray *moreData=[NSMutableArray array];
            
            NSString *fileName = nil;
            if (_isOffice) {
                fileName = @"MoreForBusiness";
            }else{
                fileName = @"MoreForBusinessShop";
            }
            
            NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:fileName withExtension:@"plist"]];
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
    }
};

#pragma mark 搜索委托
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self resignSearch];
};

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;{
    [self registerSearch];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self doSearch:searchText];
};


#pragma mark HistoryDelegation
-(void) didSelectInIndex :(HistoryTableView *) tableView index : (NSInteger) index{
    [self resignSearch];
    FYSearchHouseDao *dao = [FYSearchHouseDao new];
    NSArray *array = [dao allSearchHouse];
    _searchBar.text = array[index];
    
    [_houseTableView headerBeginRefreshing];
};

-(void) didCancel : (HistoryTableView *) tableView{
    [self resignSearch];
};

-(void) didFooterTapped:(HistoryTableView *)tableView{
    [tableView refresh:nil];
    FYSearchHouseDao *dao = [FYSearchHouseDao new];
    [dao removeAll];
}

-(void) didSelect :(SearchHouseTableView *) tableView index : (NSInteger) index{
    [self resignSearch];
    
    NSDictionary *dict = _searchDatasFromServer[index];
    FYSearchHouseDao *dao = [FYSearchHouseDao new];
    [dao insert:dict[@"communityName"] houseId:dict[@"communityId"]];
    
    _searchBar.text = dict[@"communityName"];
    
    [_houseTableView headerBeginRefreshing];
};

#pragma mark - 区域 - 用户选择全国的时候
-(void)addressSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId{
    _regionId = areaId;
    [_houseTableView headerBeginRefreshing];
}

-(void)addressAll{
    _regionId=@"0";
    [_houseTableView headerBeginRefreshing];
}

-(void) cityAll:(NSString *)cityId{
    _regionId = cityId;
    [_houseTableView headerBeginRefreshing];
}

-(void) areaAll:(NSString *)areaId{
    _regionId = areaId;
    [_houseTableView headerBeginRefreshing];
}

#pragma mark - 当用户有选择城市的时候
-(void)blockSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId{
    _regionId = streetId;
    //    NSLog(@"%@ -- %@",areaId,streetId);
    [_houseTableView headerBeginRefreshing];
}

-(void)blockAll{
    _regionId =[[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityId];
    [_houseTableView headerBeginRefreshing];
}

-(void) streetAll:(NSString *)areaId{
    _regionId = areaId;
    [_houseTableView headerBeginRefreshing];
}

#pragma mark tableview delegation
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
};

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HouseListCell"];
    if (cell==nil) {
        cell=[[HouseListCell alloc]init];
        cell.isBusiness = YES;
    }
    
    cell.isSell = _isSell ;
    
    if (_isOffice) {
        cell.house = _officeDatas[indexPath.row];
    }else {
        cell.house = _shopDatas[indexPath.row];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isOffice) {
        return _officeDatas.count;
    }else{
        return _shopDatas.count;
    }
};

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseListCell *cell = (HouseListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    HouseInfoViewController *info= [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"HouseInfoViewController"];
    info.isBusiness = YES ;
    info.houseId = cell.houseId ;
    info.type = _isSell ? HouseTypeSell : HouseTypeRent ;
    info.communityString=[NSString stringWithFormat:@"%@ %@",cell.house.region,cell.house.community] ;
    
    [self.navigationController pushViewController:info animated:YES] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99 ;
};

#pragma mark - 价格
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end{
    _priceFrom = begin;
    _priceTo = end;
    
    [_houseTableView headerBeginRefreshing];
}

#pragma mark -   筛选代理
#pragma mark  - 排序
-(void)filterView:(FilterView *)view didSelectSort:(NSString *)sort{
    if (_isSell) {
        if ([sort isEqualToString:@"2"]) {
            _sort = 4;
        }else{
            _sort = -4;
        }
    }else{
        _sort = [sort integerValue];
    }
    [_houseTableView headerBeginRefreshing];
}

#pragma mark - 房型
-(void)filterView:(FilterView *)view didSelectRoomNumWithBegin:(NSString *)begin andEnd:(NSString *)end{
    if ([@"0" isEqualToString:begin]) {
        _isSell = YES;
        _tradeType = SALE;
        [_selectView setButton2Title:@"售价"];
        [_selectView setButton3Title:@"出售"];
    }else{
        _isSell = NO;
        _tradeType = RENT;
        [_selectView setButton2Title:@"租金"];
        [_selectView setButton3Title:@"出租"];
    }
    
    [_houseTableView headerBeginRefreshing];
}

#pragma mark - 面积
-(void)filterView:(FilterView *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end{
    _areaFrom=begin;
    _areaTo=end;
    [_houseTableView headerBeginRefreshing];
}

@end
