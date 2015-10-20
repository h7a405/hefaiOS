//
//  FriendsViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FriendsViewController.h"
#import "NearbyBrokerBean.h"
#import "NearbyBrokerViewCell.h"
#import "MJRefresh.h"
#import "XSHouseBrokerInfoViewController.h"
#import "FYUserDao.h"
#import "KeyboardToolView.h"
#import "FriendsWsImpl.h"
#import "MBProgressHUD+Add.h"


@interface FriendsViewController ()<UITableViewDataSource, UITableViewDelegate, KeyboardToolDelegate>{
    NSInteger _pageNo;
    NSMutableArray *_data;
    NSString *_keyword;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *navBtnSearch;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoData;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    // Do any additional setup after loading the view.
    _data = [NSMutableArray array];
    _pageNo = 1;
    _keyword = @"";
    
    _viewSearch.hidden = YES;
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
    [_tableView headerBeginRefreshing];
    
}


#pragma mark - table data and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

#pragma mark - 刷新
-(void)headerRefenre{
    _pageNo=1;
    [self searchDataFromServer];
}

-(void)footerReference{
    _pageNo++;
    [self searchDataFromServer];
}

- (IBAction)btnCancelClick:(id)sender {
    _txtSearch.text = @"";
}

- (IBAction)doSearchSwitch:(id)sender {
    if(_viewSearch.hidden == YES)
    {
        _viewSearch.hidden = NO;
        [_txtSearch becomeFirstResponder];
    }
    else
    {
        _viewSearch.hidden = YES;
        [self.view endEditing:YES];
    }
}

- (IBAction)txtSearchChanged:(id)sender {
    _btnCancel.hidden = _txtSearch.text.length == 0;
}

- (IBAction)txtSearchEditingBegin:(id)sender {
    KeyboardToolView *keyTool = [[KeyboardToolView alloc]init];
    keyTool.delegate = self;
    keyTool.buttonTitle = @"搜索";
    _txtSearch.inputAccessoryView = keyTool;
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button{
    [self.view endEditing:YES];
    _keyword = _txtSearch.text;
    [self searchDataFromServer];
}

#pragma mark - 搜索好友
-(void)searchDataFromServer{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    FriendsWsImpl *ws = [FriendsWsImpl new];
    [ws searchFriends:user.sid kw:_keyword pageNo:_pageNo pageSize:5 result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (_pageNo == 1) {
                [_data removeAllObjects];
            }
            
            NSArray *data=[result objectForKey:@"data"];
            
            if(![data isKindOfClass:[NSNull class]]){
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NearbyBrokerBean *nearbyBroker=[NearbyBrokerBean modelObjectWithDictionary:obj];
                    [_data addObject:nearbyBroker];
                }];
            }
            
            if (_data.count==0) {
                _imgNoData.hidden = NO;
                _tableView.hidden = YES;
                _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            }else{
                _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                _tableView.hidden = NO;
                _imgNoData.hidden = YES;
                _viewSearch.hidden = YES;
            }
            
            [_tableView reloadData];
        }else{
            if (_data.count==0) {
                _imgNoData.hidden = NO;
                _tableView.hidden = YES;
                _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            }else{
                _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                _tableView.hidden = NO;
                _imgNoData.hidden = YES;
                _viewSearch.hidden = YES;
            }
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
        
        if (_pageNo==1) {
            [_tableView headerEndRefreshing] ;
        }else{
            [_tableView footerEndRefreshing] ;
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - 跳转页面
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //显示经纪人详细信息
    NearbyBrokerBean *nearbyBroker=_data[indexPath.row];
    XSHouseBrokerInfoViewController *info=[[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"XSHouseBrokerInfoViewController"];
    info.brokerId=nearbyBroker.memberUserId;
    [self.navigationController pushViewController:info animated:YES];
}

@end
