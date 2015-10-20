//
//  HouseListViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseListViewController.h"
#import "SelectMoreTypeView.h"
#import "FilterView.h"
#import "SelectBlockViewForHouse.h"
#import "SelectPrice.h"
#import "MJRefresh.h"
#import "House.h"
#import "HouseListCell.h"
#import "BackButton.h"
#import "FYBrokerDao.h"
#import "BrokerInfoBean.h"
#import "HouseInfoViewController.h"
#import "XSLocationHouseViewController.h"
#import "XSSubscibeViewController.h"
#import "UIViewController+Storyboard.h"
#import "AddressSelectView.h"
#import "FYUserDao.h"
#import "KeyboardToolView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "MyCenterWsImpl.h"
#import "HouseWsImpl.h"
#import "FYSearchHistoryDao.h"

@interface HouseListViewController ()<UITextFieldDelegate,KeyboardToolDelegate,SelectMoreTypeViewDelegate,FilterViewDelegate,SelectBlockViewForHouseDelegate,SelectPriceDelegate,UITableViewDataSource,UITableViewDelegate,AddressSelectViewDelegate>{
    
    SelectMoreTypeView *_selectMore;
    SelectBlockViewForHouse *_addressSelect;
    FilterView *_filterView;
    SelectPrice *_priceView;
    AFHTTPRequestOperationManager *_request;
    AFHTTPRequestOperationManager *_requestForHouseList;
    AddressSelectView *_selectAllCity;
    
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
    
    NSString *_searchRegionId;
    
    NSMutableArray *_data;
    /**
     *  搜索记录
     */
    NSMutableArray *_resultData;
    /**
     *  历史记录
     */
    NSMutableArray *_historyData;
}

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIImageView *searchButton;
@property (weak, nonatomic) IBOutlet UIImageView *searchBg;
@property (weak, nonatomic) IBOutlet UIButton *dingyue;
@property (weak, nonatomic) IBOutlet UIButton *fujin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet BackButton *backButton;

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UITableView *history;
@property (weak, nonatomic) IBOutlet UIView *noDataShowView;

@end

@implementation HouseListViewController

-(void)initAllParam{
    _data=[NSMutableArray array];
    _resultData=[NSMutableArray array];
    _historyData=[NSMutableArray array];
    _keyWord=@"";
    _regionId=[[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityId];
    _priceFrom=@"0";
    _priceTo=@"0";
    _areaFrom=@"0";
    _areaTo=@"0";
    _roomFrom=@"0";
    _roomTo=@"0";
    _pt=@"";
    _d=@"";
    _brokerId=@"";
    _tradeType=@"";
    _purpose=@"";
    _ctime=@"";
    _sort=@"0";
    _pageNo=0;
    _searchRegionId=@"0";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self  initAllParam];
    [self setupSelectTypeView];
    [self setupTableView];
    if (_houseType == HouseTypeRent) {
        [self changeForRent];
    }
    [self setupSearchResultTable];
    [self getBrokerId];
    
    if (IPhone4) {
        _tableView.frame = rect(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height - 88);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if (_pageNo==0) {
        [_tableView headerBeginRefreshing];
    }
    [super viewDidAppear:animated];
}

#pragma mark - 初始化view
-(void)setupTableView{
    //_tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
}

-(void)setupSearchResultTable{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    label.text=@"  搜索历史";
    label.font=[UIFont systemFontOfSize:14.0];
    label.backgroundColor=[UIColor lightGrayColor];
    _history.tableHeaderView=label;
}

#pragma mark - 搜索记录底部按钮初始化
-(void)setupTableFooterView{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    if (_historyData.count>0) {
        _history.tableFooterView=button;
    }else{
        _history.tableFooterView=nil;
        return;
    }
    button.titleLabel.font=[UIFont systemFontOfSize:14.0];
    button.backgroundColor=[UIColor lightGrayColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [button addTarget:self  action:@selector(cleanAllHistory) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 清除所有历史
-(void)cleanAllHistory{
    FYSearchHistoryDao *dao = [FYSearchHistoryDao new];
    [dao removeAllHistory];
    [self showHistory];
}

#pragma mark - 刷新数据
-(void)headerRefenre{
    _pageNo=1;
    //    NSLog(@"%@",_keyWord);
    [self loadHouseInfoFromServer];
}

-(void)footerReference{
    _pageNo++;
    [self loadHouseInfoFromServer];
}

#pragma mark - 初始化选择类型
-(void)setupSelectTypeView{
    SelectMoreTypeView *view=[[SelectMoreTypeView alloc]init];
    view.delegate=self;
    _selectMore=view;
    if (_houseType==HouseTypeRent) {
        view.prictButtonTitle=@"租金";
    }
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -选择显示类型
-(void)selectMoreView:(SelectMoreTypeView *)view didClickButtonIndex:(NSInteger)index{
    if (index==2) {
        if (_filterView==nil) {//选择更多
            FilterView *filter=[[FilterView alloc]init];
            filter.delegate=self;
            filter.clickButtonFrame=CGRectMake(0, CGRectGetMaxY(_selectMore.frame), 0, 0);
            [filter show];
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
        }else{
            [_filterView show];
        }
        
    }else if (index==0){//选择地址
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
        
    }else{//选择价格
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
-(void)filterView:(FilterView *)view didSelectSort:(NSString *)sort{
    if (_houseType==HouseTypeRent) {
        if ([sort isEqualToString:@"2"]) {
            _sort=@"4";
        }else{
            _sort=@"-4";
        }
    }else{
        _sort=sort;
    }
    [_tableView headerBeginRefreshing];
}

#pragma mark - 房型
-(void)filterView:(FilterView *)view didSelectRoomNumWithBegin:(NSString *)begin andEnd:(NSString *)end{
    _roomFrom=begin;
    _roomTo=end;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 面积
-(void)filterView:(FilterView *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end{
    _areaFrom=begin;
    _areaTo=end;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 区域 - 用户选择全国的时候
-(void)addressSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId{
    _regionId=areaId;
    [_tableView headerBeginRefreshing];
}

-(void)addressAll{
    _regionId=@"0";
    [_tableView headerBeginRefreshing];
}

-(void) cityAll:(NSString *)cityId{
    _regionId=cityId;
    [_tableView headerBeginRefreshing];
}

-(void) areaAll:(NSString *)areaId{
    _regionId=areaId;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 当用户有选择城市的时候
-(void)blockSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId{
    _regionId=streetId;
    [_tableView headerBeginRefreshing];
}

-(void)blockAll{
    _regionId=[[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityId];
    [_tableView headerBeginRefreshing];
}

-(void) streetAll:(NSString *)areaId{
    _regionId=areaId;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 价格
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end{
    _priceFrom=begin;
    _priceTo=end;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 点击订阅
- (IBAction)bottomButtonClick:(UIButton *)sender{
    if ([_handler handleUserPermission:self]) {
        XSSubscibeViewController *sub=[XSSubscibeViewController controllerWithStoryboard:@"Subscibe" andIdentify:@"XSSubscibeViewController"];
        sub.type=_houseType;
        [self.navigationController pushViewController:sub animated:YES];
    }
}

#pragma mark - 表格代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView==tableView) {
        return _data.count;
    }else if (_history==tableView){
        return _historyData.count;
    }
    return _resultData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {//正常房子信息显示
        HouseListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HouseListCell"];
        if (cell==nil) {
            cell=[[HouseListCell alloc]init];
        }
        if (HouseTypeSell==_houseType) {
            cell.isSell=YES;
        }
        cell.house=_data[indexPath.row];
        return cell;
    }else if(_history==tableView){//显示历史
        static   NSString *ID=@"History";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.textColor=[UIColor grayColor];
        }
        NSDictionary *dict=_historyData[indexPath.row];
        cell.textLabel.text=dict[@"communityName"];
        return cell;
    }else{//显示搜索结果
        static   NSString *ID=@"Result";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.textColor=[UIColor grayColor];
        }
        NSDictionary *dict=_resultData[indexPath.row];
        
        cell.textLabel.attributedText=[ViewUtil content:dict[@"communityName"] colorString:_searchText.text];
        cell.detailTextLabel.attributedText=[ViewUtil content:dict[@"address"] colorString:_searchText.text];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView==tableView) {
        return 99;
    }else if(_history==tableView){
        return 44;
    }else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView==tableView) {
        [_searchText resignFirstResponder];
        self.navigationController.navigationBar.hidden=NO;
        [self performSegueWithIdentifier:@"houseInfo" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }else if(tableView==_searchResultTableView){
        [self.view endEditing:YES];
        FYSearchHistoryDao *dao = [FYSearchHistoryDao new];
        [dao saveHistory:_resultData[indexPath.row]];
        _searchText.text=_resultData[indexPath.row][@"communityName"];
        _keyWord=_searchText.text;
        [self hideSearchDataView];
        [self endSearchEdit];
        [_tableView headerBeginRefreshing];
    }else{
        _searchText.text=_historyData[indexPath.row][@"communityName"];
        _keyWord=_searchText.text;
        [self endSearchEdit];
        [_tableView headerBeginRefreshing];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - 页面跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"houseInfo"]) {
        HouseListCell *cell=sender;
        HouseInfoViewController *info=segue.destinationViewController;
        info.houseId=cell.houseId;
        info.type=_houseType;
        info.communityString=[NSString stringWithFormat:@"%@ %@",cell.house.region,cell.house.community];
    }else if ([segue.identifier isEqualToString:@"locationHouse"]){
        XSLocationHouseViewController *location=segue.destinationViewController;
        location.houseType=_houseType;
    }
}

#pragma  mark - 请求网络数据
-(void)loadHouseInfoFromServer{
    //        NSLog(@"priceFrom= %@ , priceTo= %@ , areaFrom= %@ , areaTo= %@ , roomFrom= %@ , roomTo= %@ , tradeType= %d , sort=  %@ , pageNo= %d , kw= %@  %@",_priceFrom,_priceTo,_areaFrom,_areaTo,_roomFrom,_roomTo,_houseType,_sort,_pageNo,_keyWord,_regionId);
    
    //从服务器请求房子信息
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws loadHouse:_regionId priceFrom:_priceFrom priceTo:_priceTo areaFrom:_areaFrom areaTo:_areaTo roomFrom:_roomFrom roomTo:_roomTo tradeType:_houseType+1 sort:_sort pageNo:_pageNo kw:_keyWord purpose:1 result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if ((long)_pageNo==1) {
                [_data removeAllObjects];
            }
            
            NSArray *data=[result objectForKey:@"data"];
            if (data && [data count]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    House *house=[House modelObjectWithDictionary:obj];
                    [_data addObject:house];
                }];
                
                _noDataShowView.hidden=YES;
                _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
            }else{
                _noDataShowView.alpha=0;
                _noDataShowView.hidden=NO;
                _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                [UIView animateWithDuration:1 animations:^{
                    _noDataShowView.alpha=1;
                }];
            }
            
            [_tableView reloadData];
            
            if ((long)_pageNo==1) {
                [_tableView headerEndRefreshing];
            }else{
                [_tableView footerEndRefreshing];
            }
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
            if ((long)_pageNo==1) {
                [_tableView headerEndRefreshing];
            }else{
                [_tableView footerEndRefreshing];
            }
        }
    }];
}

/**
 *  设置是二手房还是租房
 *
 *  @param houseType
 */
-(void)setHouseType:(HouseType)houseType{
    _houseType=houseType;
}

-(void)changeForRent{
    _searchText.placeholder=@"搜索出租房";
    [_dingyue setTitle:@"订阅租房" forState:UIControlStateNormal];
    [_dingyue setTitle:@"订阅租房" forState:UIControlStateSelected];
    [_fujin setTitle:@"附近租房" forState:UIControlStateNormal];
    [_fujin setTitle:@"附近租房" forState:UIControlStateSelected];
}

#pragma mark - search
- (IBAction)cancelSearch:(id)sender{
    [_searchText resignFirstResponder];
    [self hideHistory];
    [self hideSearchDataView];
    [self endSearchEdit];
    _keyWord=@"";
    [_tableView headerBeginRefreshing];
}

#pragma mark - textField代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    tool.delegate=self;
    textField.inputAccessoryView=tool;
    [tool setButtonTitle:@"取消"];
    
    [self beginSearchEdit];
    return YES;
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button{
    [self.view endEditing:YES];
    _searchText.text=@"";
    
    [self endSearchEdit];
}

#pragma mark - 开始查找
-(void)beginSearchEdit{
    [self showHistory];
    [self hideResultView];
    if (![_searchText.text isEqualToString:@""]) {
        _searchText.text=@"";
    }
    _backButton.hidden=YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect bgFrame=_searchBg.frame;
        bgFrame.origin.x-=KMoveWidth;
        bgFrame.size.width+=KMoveWidth-30;
        _searchBg.frame=bgFrame;
        CGRect buttonFrame=_searchButton.frame;
        buttonFrame.origin.x-=KMoveWidth;
        _searchButton.frame=buttonFrame;
        CGRect frame=_searchText.frame;
        frame.origin.x-=KMoveWidth;
        frame.size.width+=KMoveWidth-30;
        _searchText.frame=frame;
    }];
    _buttonCancel.hidden=NO;
}

#pragma mark - 结束查找
-(void)endSearchEdit{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect bgFrame=_searchBg.frame;
        bgFrame.origin.x+=KMoveWidth;
        bgFrame.size.width-=KMoveWidth-30;
        _searchBg.frame=bgFrame;
        CGRect buttonFrame=_searchButton.frame;
        buttonFrame.origin.x+=KMoveWidth;
        _searchButton.frame=buttonFrame;
        CGRect frame=_searchText.frame;
        frame.origin.x+=KMoveWidth;
        frame.size.width-=KMoveWidth-30;
        _searchText.frame=frame;
    }];
    _backButton.hidden=NO;
    _buttonCancel.hidden=YES;
    [self.view endEditing:YES];
    [self hideHistory];
    [self hideResultView];
    [self hideSearchDataView];
    
    if (_request) {
        [_request.operationQueue cancelAllOperations];
    }
}

#pragma mark - 当搜索值发生变化 - 当使用9宫格智能拼音输入法时，有可能会出现按一次响应多次
- (IBAction)searchTextChange:(UITextField *)sender{
    if ([_keyWord isEqualToString:sender.text]) {
        return;
    }
    _keyWord=sender.text;
    
    if ([_keyWord isEqualToString:@""]) {
        [self showHistory];
        [self hideSearchDataView];
    }else{
        [self searchDataFormServer];
    }
}

#pragma mark - 查找数据请求
-(void)searchDataFormServer{
    if (_request){
        [_resultData removeAllObjects];
        [_searchResultTableView reloadData];
        [_request.operationQueue cancelAllOperations];
        _request = nil;
    }
    
    [_resultData removeAllObjects];
    HouseWsImpl *ws = [HouseWsImpl new];
    _request=[ws loadHouseForSearch:_keyWord pageSize:@"20" regionId:_searchRegionId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess && result != [NSNull null]) {
            _resultView.hidden=YES;
            _history.hidden=YES;
            
            NSArray *data=[result objectForKey:@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_resultData addObject:obj];
            }];
            
            [self showSearchDataView];
            if (_resultData.count==0) {
                [self showResultView];
            }
        }else{
            [self showResultView];
        }
    }];
}

#pragma  mark - 显示/隐藏-搜索时结果显示
-(void)showHistory{
    FYSearchHistoryDao *dao = [FYSearchHistoryDao new];
    
    _history.hidden=NO;
    
    [_historyData removeAllObjects];
    [_historyData addObjectsFromArray:[dao searchHistory]];
    [self setupTableFooterView];
    [_history reloadData];
}

-(void)hideHistory{
    _history.hidden=YES;
}

-(void)showResultView{
    _resultView.hidden=NO;
}

-(void)hideResultView{
    _resultView.hidden=YES;
}

-(void)showSearchDataView{
    _searchResultTableView.hidden=NO;
    [_searchResultTableView reloadData];
}

-(void)hideSearchDataView{
    _searchResultTableView.hidden=YES;
}

#pragma mark - 经纪人信息 - 获取用户所在板块
-(void)getBrokerId{
    FYUserDao *userDao = [FYUserDao new];
    
    if ([userDao isLogin] && _searchRegionId) {
        UserBean *user = [userDao user];
        
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

@end
