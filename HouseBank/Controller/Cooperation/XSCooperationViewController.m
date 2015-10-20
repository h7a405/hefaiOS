//
//  XSCooperationViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-28.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSCooperationViewController.h"
#import "MJRefresh.h"
#import "XSCooperationBean.h"
#import "XSCooperationCell.h"
#import "XSCooperationInfoViewController.h"
#import "FYUserDao.h"
#import "AFNetworking.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "CooperationWsImpl.h"

@interface XSCooperationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_data;
    NSInteger _pageNo;
    NSString *_object;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation XSCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray array];
    _object=@"1";
    [self setupTableView];
}

#pragma mark - 初始化view
-(void)setupTableView
{
    //_tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [_tableView headerBeginRefreshing];
    [super viewDidAppear:animated];
}

#pragma mark - 刷新数据
-(void)headerRefenre{
    _pageNo=1;
    [self getDataFormServer];
}

-(void)footerReference{
    _pageNo++;
    [self getDataFormServer];
}

#pragma mark - table data and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XSCooperationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSCooperationCell"];
    if (!cell) {
        cell=[[XSCooperationCell alloc]init];
    }
    
    cell.object=_object;//必须这句在前面
    cell.cooperation=_data[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XSCooperationCell *cell=(XSCooperationCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"cooperationInfo" sender:cell.cooperation];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"cooperationInfo"]) {
        XSCooperationInfoViewController *info=segue.destinationViewController;
        info.cooperation=sender;
        info.object=_object;
    }
}
#pragma mark - 获取网络数据
-(void)getDataFormServer{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    CooperationWsImpl *ws = [CooperationWsImpl new];
    [ws cooperationList:user.brokerId object:_object pageNo:_pageNo sid:user.sid result:^(BOOL isSuccess, id result, NSString *data) {
        if(_pageNo==1){
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        
        if (isSuccess) {
            NSArray *data=[result objectForKey:@"data"];
            
            if(_pageNo==1){
                [_data removeAllObjects];
            }
            
            if(data!=nil && ![data isKindOfClass:[NSNull class]]){
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    XSCooperationBean *cooperation=[XSCooperationBean modelObjectWithDictionary:[obj allStringObjDict]];
                    if ([_object isEqualToString:@"1"]) {
                        cooperation.houseInfo= [cooperation.houseInfo stringByReplacingOccurrencesOfString:@"㎡ " withString:@"㎡\n"];
                    }
                    
                    [_data addObject:cooperation];
                }];
            }
            
            [_tableView reloadData];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

#pragma mark - 类型切换
- (IBAction)buttonClick:(UIButton *)sender{
    CGRect frame=_line.frame;
    frame.origin.x=160*(sender.tag-1);
    [UIView animateWithDuration:0.2 animations:^{
        _line.frame = frame;
    }];
    if ([_object isEqualToString:[NSString stringWithFormat:@"%d",sender.tag]]) {
        return;
    }
    _object=[NSString stringWithFormat:@"%d",sender.tag];
    [_tableView headerBeginRefreshing];
}



@end
