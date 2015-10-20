//
//  NearbyBrokerViewController.m
//  HouseBank
//
//  Created by Gram on 14-9-30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "NearbyBrokerViewController.h"
#import "NearbyBrokerViewCell.h"
#import "NearbyBrokerBean.h"
#import "MJRefresh.h"
#import "UserBean.h"
#import "XSHouseBrokerInfoViewController.h"
#import "FYUserDao.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "FriendsWsImpl.h"

@interface NearbyBrokerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _pageNo; //页码
    NSString *_sid;
    NSMutableArray *_data;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *lblNorecord;

@end

@implementation NearbyBrokerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self initParams];
    [self setupTableView];
    [self getDataFormServer];
}

#pragma mark - tableview dataSource and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyBrokerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyBrokerViewCell"];
    if(cell == nil)
    {
        cell=[[NearbyBrokerViewCell alloc]init];
    }
    cell.nearbyBroker = _data[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}
#pragma mark - 初始化参数
-(void)initParams
{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    _data=[NSMutableArray array];
    _sid = user.sid;
    _pageNo = 1;
}
#pragma mark - 初始化刷新
- (void)setupTableView
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
#pragma mark - 获取数据
-(void)getDataFormServer
{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    FriendsWsImpl *ws = [FriendsWsImpl new];
    [ws requestNearbyBroker:user.sid pageNo:_pageNo pageSize:5 result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (_pageNo==1) {
                [_data removeAllObjects];
            }
            
            NSArray *data=[result objectForKey:@"data"];
            if([data isKindOfClass:[NSNull class]]||data==nil)return ;
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NearbyBrokerBean *nearbyBroker=[NearbyBrokerBean modelObjectWithDictionary:obj];
                [_data addObject:nearbyBroker];
            }];
            if (_data.count==0) {
                _resultView.alpha=0;
                _resultView.hidden=NO;
                _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                [UIView animateWithDuration:1 animations:^{
                    _resultView.alpha=1;
                }];
            }else{
                _resultView.hidden=YES;
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}
#pragma mark - 跳转页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //显示经纪人详细信息
    NearbyBrokerBean *nearbyBroker=_data[indexPath.row];
    XSHouseBrokerInfoViewController *info=[[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"XSHouseBrokerInfoViewController"];
    info.brokerId=nearbyBroker.memberUserId;
    [self.navigationController pushViewController:info animated:YES];
    
}

@end
