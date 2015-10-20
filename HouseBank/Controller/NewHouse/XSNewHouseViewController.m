//
//  XSNewHouseViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNewHouseViewController.h"
#import "XSNewHouseCell.h"
#import "MJRefresh.h"
#import "NewHouseBean.h"
#import "XSNewHouseInfoViewController.h"
#import "MBProgressHUD+Add.h"
#import "NewHouseWsImpl.h"
#import "HouseWsImpl.h"
#import "HouseInfoViewController.h"

@interface XSNewHouseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data;
    NSInteger _pageNo;
    NSArray *_hotDatas ;
}

-(void) initialize ;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XSNewHouseViewController

@synthesize isHot = _isHot;

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray array];
    [self setupTableView];
    
    [self initialize];
}

-(void) initialize{
    if (_isHot) {
        self.navigationItem.title = @"热点房源";
    }
}

#pragma mark - 初始化view
-(void)setupTableView{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    if (!_isHot) {
        [_tableView addFooterWithTarget:self action:@selector(footerReference)];
    }
    [_tableView headerBeginRefreshing];
}

#pragma mark - 刷新数据
-(void)headerRefenre{
    _pageNo=1;
    [self getDataFormServer];
}

-(void)footerReference
{
    _pageNo++;
    [self getDataFormServer];
}

#pragma mark - table view data source and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHot) {
        return _hotDatas.count ;
    }
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XSNewHouseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSNewHouseCell"];
    if (cell==nil) {
        cell=[[XSNewHouseCell alloc]init];
        [cell dismissHotView:!_isHot];
    }
    if (_isHot) {
        [cell refresh:_hotDatas[indexPath.row]];
    }else{
        cell.house=_data[indexPath.row];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isHot) {
        NSDictionary *dict = _hotDatas[indexPath.row];
        if ([dict[@"type"] integerValue] == 1) {
            [self performSegueWithIdentifier:@"newHouseInfo" sender:[NSString stringWithFormat:@"%@",dict[@"id"]]];
        }else{
            HouseInfoViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"HouseInfoViewController"];
            vc.houseId = dict[@"id"];
            vc.type = [dict[@"tradeType"] integerValue] + 1;
            vc.communityString = dict[@"advTitle"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        XSNewHouseCell *cell=(XSNewHouseCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"newHouseInfo" sender:cell.house.projectId];
    }
}

#pragma mark - 跳转页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString *)sender{
    if ([segue.identifier isEqualToString:@"newHouseInfo"]) {
        XSNewHouseInfoViewController *info=segue.destinationViewController;
        info.projectId=sender;
    }
}

#pragma mark - 获取数据
-(void)getDataFormServer{
    if (_isHot) {
        NSString *cityId = [[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityId];
        
        HouseWsImpl *ws = [HouseWsImpl new];
        
        [ws requestHotHouseList:nil cityId:cityId result:^(BOOL isSuccess, id result, NSString *data) {
            if (isSuccess) {
                _hotDatas = result;
                
                [_tableView reloadData];
            }
            
            [_tableView headerEndRefreshing];
        }];
    }else{
        NewHouseWsImpl *ws = [NewHouseWsImpl new];
        [ws requestNewHouse:_pageNo pageSize:15 result:^(BOOL isSuccess, id result, NSString *data) {
            if (isSuccess) {
                NSArray *data=result[@"data"];
                if (_pageNo==1) {
                    [_data removeAllObjects];
                }
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NewHouseBean *house = [NewHouseBean modelObjectWithDictionary:obj];
                    [_data addObject:house];
                }];
                
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
}
@end
