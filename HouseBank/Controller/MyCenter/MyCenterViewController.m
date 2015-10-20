//
//  MyCenterViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UserBean.h"
#import "TextUtil.h"
#import "MyCenterWsImpl.h"
#import "BrokerInfoBean.h"
#import "WaitingView.h"
#import "FYBrokerDao.h"
#import "CustomStatueBar.h"
#import "ViewUtil.h"
#import "BrokerInfoView.h"
#import "PersonInfoViewController.h"
#import "KGStatusBar.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "URLCommon.h"
#import "ResultCode.h"
#import "Share.h"
#import "XSPrivacyViewController.h"
#import "FYUserDao.h"
#import "MBProgressHUD+Add.h"
#import "ShareHandler.h"
#import "Config.h"
#import "DistributionViewController.h"

@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    // 经理人实体类
    BrokerInfoBean *_broker;
    //个人中心列表按钮的title
    NSArray *_buttonTexts;
    //个人中心首页列表
    UITableView *_tableView;
    UIAlertView *_checkUpdate;
    NSString *_trackViewUrl ;
}

-(void) doLoadView;
-(void) loadData;
-(void) loadDataFromDb;
-(void) loadDataFromServer;
-(void) onBrokerLoadError ;
-(void) loadTableView;
-(void) onLogOutBtnClick;
-(void) loadPersonInfoViewByBroker:(BrokerInfoBean *)broker;
-(void) checkAppUpdate;

@end

@implementation MyCenterViewController

- (void)viewDidLoad{
    @autoreleasepool {
        [super viewDidLoad];
        
        _buttonTexts = [NSArray arrayWithObjects:@"收入报表", @"诚信评价",@"通话记录",@"修改密码",@"意见反馈",@"用户协议", nil];
        
        [self doLoadView];
        [self loadData];
        
    }
}

// 协议按钮的点击事件
-(void)clickPrivacy{
    XSPrivacyViewController *privacy=[[XSPrivacyViewController alloc]init];
    [self.navigationController pushViewController:privacy animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//加载界面
-(void) doLoadView{
    [self.navigationItem setTitle:@"个人中心"];
    [self loadTableView];
}

//加载数据
-(void) loadData{
    [[WaitingView defaultView] showWaitingViewWithHintTextInView:self.view hintText:@"加载中.."];
    //从数据库加载
    [self loadDataFromDb];
    if (!_broker) {
        //如果从数据库加载的经理人信息为空则从服务器加载
        [self loadDataFromServer];
    }else{
        //否则加载个人信息
        [self loadPersonInfoViewByBroker:_broker];
    }
}

//从数据库加载数据
-(void) loadDataFromDb{
    _broker = [[FYBrokerDao new] brokerInfo];
}

//加载列表界面
-(void) loadTableView{
    CGRect rect = self.view.frame;
    
    float offset = 5;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(offset, 0, rect.size.width-offset*2, rect.size.height)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
    if (iOS7) {
        //由于 iOS7之前和之后的view的起点是不一样的，所以在iOS7之后加一个起点设置
        tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(70, 0, 0, 0);
    }
    
    [self.view addSubview:tableView];
}

/// 从服务器加载经理人数据失败时执行
-(void) onBrokerLoadError  {
    [KGStatusBar showErrorWithStatus:@"下载数据失败！"];
    [self.navigationController popViewControllerAnimated:YES];
}

// 退出登录按钮点击事件
-(void) onLogOutBtnClick{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录吗？\n将拒绝合发房银系统推送给您的消息！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}

//从服务器加载数据
-(void) loadDataFromServer{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    //从服务器加载数据
    [ws requestBrokerInfo:KUrlConfig brokerId:user.brokerId result:^(BOOL isSeccess,id result,NSString *data){
        if (isSeccess) {
            //加载成功
            BrokerInfoBean *broker = [BrokerInfoBean brokerFromDic:result];
            //            [[BrokerDao new] saveBroker:broker];
            _broker = broker;
            
            [self loadPersonInfoViewByBroker:_broker];
        }else{
            //加载失败
            [self onBrokerLoadError];
        }
    }];
}

//加载个人信息
-(void) loadPersonInfoViewByBroker:(BrokerInfoBean *)broker{
    //隐藏等待界面
    [[WaitingView defaultView] dismissWatingView];
    //重新加载列表
    [_tableView reloadData];
}

- (void)dealloc{
    _broker = nil;
    _buttonTexts = nil;
    _tableView = nil;
}

#pragma mark tableview deletation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyCenterBaseViewController *mcbVc = nil;
    //猎豹对应的点击事件，跳转
    switch (indexPath.row) {
        case 0://基本信息
            mcbVc =[[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonInfo"];
            break;
        case 1:{
            DistributionViewController *distributionVC = [[DistributionViewController alloc]init];
            distributionVC.broker = _broker;
            [self.navigationController pushViewController:distributionVC animated:YES];
        }
            break;
        case 2://诚信评价
            mcbVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonScore"];
            break;
        case 3://通话记录
            mcbVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"CallRecord"];
            break;
        case 4://修改密码
            mcbVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPwd"];
            break;
        case 5: //意见反馈
            mcbVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"Suggestion"];
            break;
        case 6://用户协议
            [self clickPrivacy];
            break;
            
        default: //默认
            mcbVc =[[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonInfo"];
            break;
    }
    if (mcbVc) {
        mcbVc.broker = _broker;
        [self.navigationController pushViewController:mcbVc animated:YES];
    }
}

//检查更新
-(void) checkAppUpdate{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText=@"正在检测更新...";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=934245416";
    
    AFHTTPRequestOperationManager *request=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:URL]];
    [request POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *infoArray = [responseObject objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            _trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
            if (![lastVersion isEqualToString:currentVersion]) {
                _checkUpdate = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                
                [_checkUpdate show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }else{
            [MBProgressHUD showSuccess:@"此版本为最新版本!" toView:[KAPPDelegate window]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,error",error);
        [MBProgressHUD showSuccess:@"此版本为最新版本!" toView:[KAPPDelegate window]];
    }];
}

#pragma mark tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_buttonTexts count] +2;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }if (indexPath.row == [_buttonTexts count]+1) {
        return 50;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    //取出tableview可复用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier : identifier];
    if (!cell) {
        //如果复用cell不存在则新建
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //第一个和最后一个之间设置label
    if (indexPath.row != 0 && indexPath.row <= [_buttonTexts count] ) {
        [cell.textLabel setText:[_buttonTexts objectAtIndex:indexPath.row-1]];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }else{
        //否则不设置label
        cell.textLabel.text = @"";
    }
    
    //移除自己添加的view
    NSArray *views = [cell.contentView subviews];
    for (UIView *view in views) {
        if ([view isKindOfClass:[BrokerInfoView class]]||[view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    //第一个item添加人物信息
    if(indexPath.row == 0){
        BrokerInfoView *brokerView = [[BrokerInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 10, 140)];
        [brokerView setBroker:_broker];
        [cell.contentView addSubview:brokerView];
    }else if(indexPath.row == [_buttonTexts count]+1){
        //最后一个item添加一个按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, self.view.frame.size.width-16, 40)];
        button.backgroundColor = KColorFromRGB(0xFC860A);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onLogOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }else{
        UIView *cuttingLine = [[UIView alloc] initWithFrame:rect(0, cell.contentView.frame.size.height - 0.5, 320, 0.5)];
        cuttingLine.backgroundColor = KColorFromRGB(0xdbdbdb);
        [cell.contentView addSubview:cuttingLine];
    }
    
    if (indexPath.row != [_buttonTexts count]+1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor] ;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor] ;
    }
    
    return cell;
};

#pragma mark alterview delegation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }
    if (_checkUpdate==alertView) {
        //        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=934245416"];
        NSURL *url = [NSURL URLWithString:_trackViewUrl];
        [[UIApplication sharedApplication]openURL:url];
    }else{
        FYUserDao *userDao = [FYUserDao new];
        [userDao setLogin:NO];
        [userDao removeUser];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 分享组件
- (IBAction)share:(id)sender{
    [ShareHandler shareApp];
}


@end
