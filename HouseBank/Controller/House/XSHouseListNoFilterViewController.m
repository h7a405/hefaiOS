//
//  XSHouseListNoFilterViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSHouseListNoFilterViewController.h"
#import "MJRefresh.h"
#import "House.h"
#import "HouseListCell.h"
#import "HouseInfoViewController.h"
#import "HouseWsImpl.h"
#import "MBProgressHUD+Add.h"

@interface XSHouseListNoFilterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _pageNo;
    NSMutableArray *_data;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XSHouseListNoFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray array];
    
    [self setupTableView];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_pageNo==0) {
        [_tableView headerBeginRefreshing];
    }
    [super viewDidAppear:animated];
}
#pragma mark - 初始化view
-(void)setupTableView
{
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
    
}
#pragma mark - 刷新数据
-(void)headerRefenre
{
    _pageNo=1;
    [self getDataFormServer];
}
-(void)footerReference
{
    _pageNo++;
    [self getDataFormServer];
}
#pragma mark - tableview data source and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HouseListCell"];
    if (cell==nil) {
        cell=[[HouseListCell alloc]init];
    }
    cell.house=_data[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationController.navigationBar.hidden=NO;
    [self performSegueWithIdentifier:@"brokerHouseListToInfo" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}

#pragma mark - 跳转界面处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"brokerHouseListToInfo"]) {
        HouseListCell *cell=sender;
        HouseInfoViewController *info=segue.destinationViewController;
        info.houseId=cell.houseId;
        
    }
}

#pragma  mark - 请求网络数据
-(void)getDataFormServer{
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws houseListWithoutFilter:_brokerId tradeType:1 pageNo:_pageNo result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (_pageNo ==1) {
                [_data removeAllObjects];
            }
            NSArray *data=[result objectForKey:@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                House *house=[House modelObjectWithDictionary:obj];
                [_data addObject:house];
            }];
            if (_data.count==0) {
                
                _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                
            }else{
                
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

@end
