//
//  XSSubscibeListViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSSubscibeListViewController.h"
#import "SelectMoreTypeView.h"
#import "FilterView.h"
#import "SelectPrice.h"

#import "House.h"
#import "HouseListCell.h"
#import "HouseInfoViewController.h"
#import "MJRefresh.h"
#import "UIViewController+Storyboard.h"
#import "FYUserDao.h"
#import "AFNetworking.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "SubscibeWsImpl.h"

@interface XSSubscibeListViewController ()<UITableViewDataSource,UITableViewDelegate,SelectMoreTypeViewDelegate,SelectPriceDelegate,FilterViewDelegate>
{
    SelectMoreTypeView *_selectMore;
    FilterView *_filterView;
    SelectPrice *_priceView;
    AFHTTPRequestOperationManager *_request;
    NSMutableDictionary *_dict;
    NSInteger _pageNo;
}
@property(nonatomic,strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation XSSubscibeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray array];
    [self setupSelectMoreView];
    [self getSubscibeData];
    [self setupTableView];
}

#pragma mark - 初始化
-(void)setupSelectMoreView{
    SelectMoreTypeView *view=[[SelectMoreTypeView alloc]init];
    view.delegate=self;
    _selectMore=view;
    if (_houseType==HouseTypeSell) {
        [_selectMore setButton1Title:@"售价"];
    }else{
        [_selectMore setButton1Title:@"租金"];
    }
    [_selectMore setButton2Title:@"面积"];
    [_selectMore setButton3Title:@"更多"];
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
}

#pragma mark - 更多选择条件
-(void)selectMoreView:(SelectMoreTypeView *)view didClickButtonIndex:(NSInteger)index{
    if (index==2) {
        if (_filterView==nil) {
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
            [tmp[0] removeObjectAtIndex:1];
            [tmp[1] removeObjectAtIndex:1];
            filter.data=tmp;
            _filterView=filter;
        }else{
            [_filterView show];
        }
    }else if (index==1){
        
        NSString *file=@"More";
        NSArray *data=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:file withExtension:@"plist"]];
        SelectPrice *  areaView=[[SelectPrice alloc]initWithFrame:CGRectZero andData:[data[1] objectForKey:@"data"]];
        areaView.delegate=self;
        [areaView show];
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

#pragma mark - 初始化view
-(void)setupTableView{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
}

#pragma mark - 刷新数据
-(void)headerRefenre{
    _pageNo=1;
    [self loadMoreData];
}

-(void)footerReference{
    _pageNo++;
    [self loadMoreData];
}

#pragma mark - tableview data source and delegate
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (IBAction)settingClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    House *house=_data[indexPath.row];
    HouseInfoViewController *info=[HouseInfoViewController controllerWithStoryboard:@"Home" andIdentify:@"HouseInfoViewController"];
    info.houseId=house.houseId;
    info.type=_houseType;
    info.communityString=[NSString stringWithFormat:@"%@ %@",house.region,house.community];
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark - 加载数据
-(void)loadMoreData{
    if (_request==nil) {
        _request=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:KBaseUrl];
    }
    [_dict setValue:@(_pageNo) forKey:@"pageNo"];
    
    [_request GET:@"house/subscription" parameters:_dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_pageNo == 1){
            [_tableView headerEndRefreshing];
            [_data removeAllObjects];
        }else{
            [_tableView footerEndRefreshing];
        }
        
        if([[responseObject objectForKey:@"data"]count]>0){
            _noResultView.hidden=YES;
            NSArray *data=[responseObject objectForKey:@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_data addObject:[House modelObjectWithDictionary:[obj  allStringObjDict]]];
            }];
        }
        
        if([_data count] == 0){
            _noResultView.hidden=NO;
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (_pageNo==1){
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
    }];
}

#pragma mark - 订阅信息
-(void)getSubscibeData{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SubscibeWsImpl *ws = [SubscibeWsImpl new];
    [ws requestSubscibeInfo:user.sid contentType:@"1" tradeType:_houseType+1 result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            
            NSDictionary *dict=[result allStringObjDict];
            _dict=[NSMutableDictionary dictionaryWithDictionary:dict];
            [_dict removeObjectForKey:@"brokerId"];
            [_dict removeObjectForKey:@"id"];
            [_dict removeObjectForKey:@"region"];
            [_dict setObject:user.sid forKey:@"sid"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_tableView headerBeginRefreshing];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

#pragma mark - 选择房间数量

-(void)filterView:(FilterView *)view didSelectRoomNumWithBegin:(NSString *)begin andEnd:(NSString *)end
{
    [_dict setObject:begin forKey:@"roomFrom"];
    [_dict setObject:end forKey:@"roomTo"];
    [_tableView headerBeginRefreshing];
}

#pragma mark - 排序类型
-(void)filterView:(FilterView *)view didSelectSort:(NSString *)sort
{
    
    [_dict setObject:sort forKey:@"sort"];
    [_tableView headerBeginRefreshing];
}
#pragma mark - 价格
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end
{
    if (view==_priceView) {
        [_dict setObject:begin forKey:@"priceFrom"];
        [_dict setObject:end forKey:@"priceTo"];
    }else{
        [_dict setObject:begin forKey:@"areaFrom"];
        [_dict setObject:end forKey:@"areaTo"];
    }
    [_tableView headerBeginRefreshing];
    
}
@end
