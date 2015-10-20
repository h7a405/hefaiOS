//
//  XSNeedFilterViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-14.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNeedFilterViewController.h"
#import "SelectMoreTypeView.h"
#import "SelectBlockViewForHouse.h"
#import "XSSelectPriceForNeed.h"
#import "SelectPrice.h"
#import "MJRefresh.h"
#import "XSNeedListCell.h"
#import "XSNeedBean.h"
#import "XSNeedDetailViewController.h"
#import "XSSelectMoreFilterView.h"
#import "BackButton.h"
#import "AddressSelectView.h"
#import "FYUserDao.h"
#import "KeyboardToolView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "FYCustomerNeedsDao.h"
#import "CustomerNeedsWsImpl.h"

@interface XSNeedFilterViewController ()<SelectMoreTypeViewDelegate,SelectBlockViewForHouseDelegate,XSSelectPriceForNeedDelegate,SelectPriceDelegate,UITableViewDataSource,UITableViewDelegate,XSSelectMoreFilterViewDelegate,KeyboardToolDelegate,UITextFieldDelegate,AddressSelectViewDelegate>{
    SelectMoreTypeView *_more;
    SelectBlockViewForHouse *_addressView;
    XSSelectPriceForNeed *_selectPrice;
    SelectPrice *_priceView;
    XSSelectMoreFilterView *_moreFilter;
    AddressSelectView *_selectAllCity;
    NSString *_regionId;
    NSString *_priceFrom;
    NSString *_priceTo;
    NSString *_areaFrom;
    NSString *_areaTo;
    NSString *_bedRoom;
    NSString *_communityId;
    NSString *_purpose;
    NSString *_tradeType;
    NSString *_sid;
    NSInteger _pageNo;
    
    NSString *_keyWord;
    /**
     *  搜索记录
     */
    NSMutableArray *_resultData;
    /**
     *  历史记录
     */
    NSMutableArray *_historyData;
    
}

@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)AFHTTPRequestOperationManager *request;

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet BackButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *searchBg;
@property (weak, nonatomic) IBOutlet UIImageView *searchButton;

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UITableView *history;
@property (weak, nonatomic) IBOutlet UIView *noDataShowView;

@end

@implementation XSNeedFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelectMoreView];
    [self initParams];
    [self setupTableView];
    [self setupSearchResultTable];
    
    if (self.type == NeedTypeSell) {
        _searchText.placeholder = @"搜索求购客需";
    }else{
        _searchText.placeholder = @"搜索求租客需";
    }
}

-(void)initParams{
    _regionId=@"0";
    _priceFrom=@"0";
    _priceTo=@"0";
    _areaFrom=@"0";
    _areaTo=@"0";
    _bedRoom=@"0";
    _communityId=@"0";
    _purpose=@"0";
    _tradeType=@"0";
    _keyWord=@"";
    _pageNo=1;
    
    _resultData=[NSMutableArray array];
    _historyData=[NSMutableArray array];
    _data=[NSMutableArray array];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha=0;
    self.navigationController.navigationBar.hidden=YES;
    [super viewDidAppear:animated];
    
}
-(void)setupSearchResultTable{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    label.text=@"  搜索历史";
    label.font=[UIFont systemFontOfSize:14.0];
    label.backgroundColor=[UIColor lightGrayColor];
    _history.tableHeaderView=label;
}

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

-(void)cleanAllHistory{
    FYCustomerNeedsDao *dao = [FYCustomerNeedsDao new];
    [dao removeAllHistoryForNeed];
    [self showHistory];
}

#pragma mark - 初始化view
-(void)setupTableView{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
    [_tableView headerBeginRefreshing];
}

#pragma mark - 刷新数据
-(void)headerRefenre{
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _pageNo=1;
    [self loadMoreData];
}

-(void)footerReference{
    _pageNo++;
    [self loadMoreData];
}

-(void)setupSelectMoreView{
    _more=[[SelectMoreTypeView alloc]initWithFrame:CGRectMake(0, 64, KWidth, 44)];
    _more.delegate=self;
    [_more setButton1Title:@"区域"];
    [_more setButton2Title:@"预算"];
    if(_type==NeedTypeSell){
        [_more setButton3Title:@"更多"];
    }else if (_type==NeedTypeRent){
        [_more setButton3Title:@"面积"];
    }
    
    [self.view addSubview:_more];
    [self.view sendSubviewToBack:_more];
}
-(void)setupAddressSelectView
{
    if(_addressView==nil){
        _addressView=[[SelectBlockViewForHouse alloc]init];
        _addressView.delegate=self;
    }
    [_addressView show];
}
#pragma mark - 选择价格---求租
-(void)setupSelectPriceViewForNeedRent
{
    if (_selectPrice==nil) {
        NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"PriceForNeed" withExtension:@"plist"]];
        _selectPrice=[XSSelectPriceForNeed selectPrictForNeedWithData:data];
        _selectPrice.delegate=self;
    }
    [_selectPrice show];
}

#pragma mark - 选择价格----求购
-(void)setupPriceViewForNeedSell
{
    if (_priceView==nil) {
        NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Price" withExtension:@"plist"]];
        _priceView=[[SelectPrice alloc]initWithFrame:CGRectZero andData:data];
        _priceView.delegate=self;
    }
    [_priceView show];
    
}
#pragma mark - 求租的面积
-(void)setupSelectArea{
    NSString *file=@"More";
    NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:file withExtension:@"plist"]];
    SelectPrice *  areaView=[[SelectPrice alloc]initWithFrame:CGRectZero andData:[data[1] objectForKey:@"data"]];
    areaView.delegate=self;
    
    [areaView show];
}

-(void)setupSelectMoreFilterView{
    if (_moreFilter==nil) {
        NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"MoreFilterForNeed" withExtension:@"plist"]];
        
        _moreFilter=[XSSelectMoreFilterView selectMoreFilterViewWithData:data];
        _moreFilter.delegate=self;
    }
    
    [_moreFilter show];
}

-(void)selectMoreView:(SelectMoreTypeView *)view didClickButtonIndex:(NSInteger)index{
    if(index==0){
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *cityId=[user objectForKey:KLocationCityId];
        if ([cityId integerValue]==0) {//选择全国城市
            if(_selectAllCity==nil){
                _selectAllCity=[[AddressSelectView alloc]init];
                _selectAllCity.delegate=self;
            }
            [_selectAllCity show];
        }else{
            [self setupAddressSelectView];
        }
        
    }else if (index==1){
        if(_type==NeedTypeRent){
            [self setupSelectPriceViewForNeedRent];
        }else if (_type==NeedTypeSell){
            [self setupPriceViewForNeedSell];
        }
    }else{
        if (_type==NeedTypeRent) {
            [self setupSelectArea];
        }else{
            [self setupSelectMoreFilterView];
        }
    }
}

#pragma mark - 条件选择回调
-(void)addressSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId{
    _regionId=streetId;
    [_tableView headerBeginRefreshing];
}

-(void)addressAll{
    _regionId=@"0";
    [_tableView headerBeginRefreshing];
}

-(void)cityAll : (NSString *) cityId{
    _regionId=cityId;
    [_tableView headerBeginRefreshing];
};

-(void)areaAll : (NSString *) areaId{
    _regionId=areaId;
    [_tableView headerBeginRefreshing];
};

#pragma mark - 当用户有选择城市的时候
-(void)blockSelectView:(SelectBlockViewForHouse *)view didSelectCityId:(NSString *)cityId andAreaId:(NSString *)areaId andStreetId:(NSString *)streetId{
    
    _resultView.hidden = NO;
    _regionId=streetId;
    [_tableView headerBeginRefreshing];
}

-(void)blockAll{
    _regionId=@"0";
    [_tableView headerBeginRefreshing];
}

-(void)streetAll : (NSString *) areaId{
    
    _regionId = areaId;
    [_tableView headerBeginRefreshing];
};

#pragma mark - 价格
-(void)selectPrictForNeedView:(XSSelectPriceForNeed *)view didSelectHouseType:(HouseUseType)type prictForm:(NSString *)form andPriceTo:(NSString *)to{
    _purpose=[NSString stringWithFormat:@"%d",type];
    _priceFrom=form;
    _priceTo=to;
    
    [_tableView headerBeginRefreshing];
}

-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end{
    if (_type==NeedTypeRent) {
        _areaFrom = begin;
        _areaTo = end;
    }else{
        _priceFrom=begin;
        _priceTo=end;
    }
    
    [_tableView headerBeginRefreshing];
}

#pragma mark - 当求购时选择更多代理
-(void)selectMoreFilterView:(XSSelectMoreFilterView *)view didSelectAreaForm:(NSString *)form andAreaTo:(NSString *)to{
    _areaFrom=form;
    _areaTo=to;
    
    [_tableView headerBeginRefreshing];
}

-(void)selectMoreFilterView:(XSSelectMoreFilterView *)view didSelectNeedType:(HouseUseType)type{
    _purpose=[NSString stringWithFormat:@"%d",type];
    [_tableView headerBeginRefreshing];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview data and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView==tableView) {
        return _data.count;
    }else if (_history==tableView){
        
        return _historyData.count;
    }
    
    return _resultData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView==tableView) {
        XSNeedListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSNeedListCell"];
        if (cell==nil) {
            cell=[XSNeedListCell cell];
        }
        cell.model = _data[indexPath.row];
        return cell;
    }else if(_history==tableView){//历史
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
    }else{//结果
        static   NSString *ID=@"ResultForNeed";
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView==tableView) {
        return 137.f;
    }else if(_history==tableView){
        return 44;
    }else{
        return 44;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark - 点击 tableview cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        XSNeedListCell *cell=(XSNeedListCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"needFilterDetail" sender:cell.model];
    }else if(tableView==_searchResultTableView){
        [self.view endEditing:YES];
        FYCustomerNeedsDao *dao = [FYCustomerNeedsDao new];
        [dao saveHistoryForNeed:_resultData[indexPath.row]];
        _communityId=_resultData[indexPath.row][@"communityId"];
        _searchText.text=_resultData[indexPath.row][@"communityName"];
        [_tableView headerBeginRefreshing];
        _keyWord=_searchText.text;
        [self hideSearchDataView];
        [self endSearchEdit];
    }else{
        _searchText.text=_historyData[indexPath.row][@"communityName"];
        _keyWord=_searchText.text;
        _communityId=_historyData[indexPath.row][@"communityId"];
        
        [_tableView headerBeginRefreshing];
        [self endSearchEdit];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 页面跳转处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"needFilterDetail"]){
        XSNeedDetailViewController *detail=segue.destinationViewController;
        detail.model=sender;
    }
}

#pragma mark - 获取数据
-(void)loadMoreData{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    NSLog(@"%@",_regionId);
    
    CustomerNeedsWsImpl *ws = [CustomerNeedsWsImpl new];
    [ws requestCustomerNeedsWithFilter:_regionId priceFrom:_priceFrom priceTo:_priceTo areaFrom:_areaFrom areaTo:_areaTo bedRoom:_bedRoom communityId:_communityId purpose:_purpose tradeType:_type pageNo:_pageNo sid:user.sid result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (_pageNo==1){
                [_data removeAllObjects];
            }
            
            NSArray *data=[result objectForKey:@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_data addObject:[XSNeedBean modelObjectWithDictionary:obj]];
            }];
            
            if (_data.count>0) {
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                _resultView.hidden=YES;
            }else{
                _resultView.hidden=NO;
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

#pragma mark - 代理
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
    if (_resultData.count==0) {
        [self endSearchEdit];
    }
}

#pragma mark - 开始搜索
-(void)beginSearchEdit{
    [self showHistory];
    [self hideResultView];
    _searchText.text=@"";
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

#pragma mark - 结束搜索
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

#pragma mark - 搜索框发生变化时
- (IBAction)searchTextChange:(UITextField *)sender
{
    if ([_keyWord isEqualToString:sender.text]) {
        return;
    }
    _keyWord=sender.text;
    if ([_keyWord isEqualToString:@""]) {
        [self showHistory];
        [self hideSearchDataView];
    }else{
        [self searchData];
    }
    
}
#pragma mark - 取消搜索
- (IBAction)cancelSearch:(id)sender{
    [_searchText resignFirstResponder];
    
    [self endSearchEdit];
    _keyWord=@"";
    [_tableView headerBeginRefreshing];
}

#pragma mark - 搜索数据
-(void)searchData{
    if (_request) {
        [_resultData removeAllObjects];
        [_searchResultTableView reloadData];
        [_request.operationQueue cancelAllOperations];
        _request = nil;
    }
    
    _request = [[CustomerNeedsWsImpl new] searchCustomerNeeds:_keyWord pageSize:@"20" :^(BOOL isSuccess, id result, NSString *data) {
        if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
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

#pragma  mark - 显示  隐藏
-(void)showHistory{
    FYCustomerNeedsDao *dao = [FYCustomerNeedsDao new];
    
    _history.hidden=NO;
    
    [_historyData removeAllObjects];
    [_historyData addObjectsFromArray:[dao searchHistoryForNeed]];
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


@end
