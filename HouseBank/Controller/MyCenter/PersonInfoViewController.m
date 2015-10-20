//
//  PersonInfoViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "BrokerInfoView.h"
#import "WaitingView.h"
#import "TextUtil.h"
#import "ChangePersonIntroductionViewController.h"
#import "ChangeBlockViewController.h"
#import "ChangeCommunityViewController.h"
#import "WorkYearView.h"
#import "AppDelegate.h"
#import "MyCenterWsImpl.h"
#import "Constants.h"
#import "URLCommon.h"
#import "ResultCode.h"
#import "KGStatusBar.h"
#import "FYUserDao.h"

#define ItemHeight 55

/**
 个人基本信息
 */
@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate,WorkYearViewDelegation>{
    __weak BrokerInfoBean *_broker;
    __weak BrokerInfoView *_brokerView;
    __weak WaitingView *_waitingView;
    __weak UITableView *_tableView;
}

-(void) doLoadView;
-(void) showWorkYearPicker;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self doLoadView];
}

-(void) doLoadView{
    CGRect rect = self.view.bounds;
    
    self.navigationItem.title = @"基本信息" ;
    
    float topOffset = iOS7 ? 70 : 10;
    
    //个人信息界面
    BrokerInfoView *brokerInfoView = [[BrokerInfoView alloc] initWithFrame:CGRectMake(5, topOffset, rect.size.width - 10, 140)];
    brokerInfoView.backgroundColor = [UIColor whiteColor] ;
    _brokerView = brokerInfoView;
    [self.view addSubview:brokerInfoView];
    [brokerInfoView setBroker:_broker];
    
    // 个人基本信息下面的按钮列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 145+topOffset, rect.size.width-10, ItemHeight*4)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

-(void) viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
}

-(void) setBroker : (BrokerInfoBean *) broker{
    _broker = broker;
    [_brokerView setBroker:broker];
};

-(void) showWorkYearPicker{
    WorkYearView *workView = [[WorkYearView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    workView.delegation = self;
    [workView showWithYear:_broker.workYear];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark table view delegation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    }
    
    cell.detailTextLabel.adjustsFontSizeToFitWidth = indexPath.row == 2;
    
    NSString *detailText = @"未填写";
    
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"自我介绍"];
            if (![TextUtil isEmpty:_broker.resume] && ![_broker.resume isKindOfClass:[NSNull class]]) {
                detailText = _broker.resume;
            }
            break;
        case 1:
            [cell.textLabel setText:@"熟悉板块"];
            if (![TextUtil isEmpty:_broker.familiarBlock]&& ![_broker.familiarBlock isKindOfClass:[NSNull class]]) {
                detailText = _broker.familiarBlock;
            }
            
            break;
        case 2:
            [cell.textLabel setText:@"主营小区"];
            if (![TextUtil isEmpty:_broker.familiarCommunity]&& ![_broker.familiarCommunity isKindOfClass:[NSNull class]]) {
                detailText = _broker.familiarCommunity;
            }
            break;
        case 3:
            [cell.textLabel setText:@"从业时间"];
            if([_broker.workYear intValue])
                detailText = [NSString stringWithFormat:@"%@年",_broker.workYear];
            break;
            
        default:
            break;
    }
    
    if(detailText)
        cell.detailTextLabel.text  = detailText;
    
    return cell;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ItemHeight;
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ChangePersonIntroductionViewController *cpiVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeIntroduction"];
        [cpiVc setBroker:_broker];
        [self.navigationController pushViewController:cpiVc animated:YES];
    }else if (indexPath.row == 1) {
        ChangeBlockViewController *cpiVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeBlock"];
        [cpiVc setBroker:_broker];
        [self.navigationController pushViewController:cpiVc animated:YES];
    }else if (indexPath.row == 2) {
        ChangeCommunityViewController *cpiVc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeCommunity"];
        [cpiVc setBroker:_broker];
        [self.navigationController pushViewController:cpiVc animated:YES];
    }else if (indexPath.row == 3) {
        [self showWorkYearPicker];
    }
};

#pragma mark year view delegation
-(void) onYearCheck:(NSInteger)integer{
    WaitingView *waitingView = [[WaitingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [waitingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在连接..."];
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws updataWorkYear:[URLCommon buildUrl:UPDATE_BROKER_INFO] sid:user.sid workYear:integer+1 result:^(BOOL isSuccess, id result, NSString *data) {
        [waitingView dismissWatingView];
        if ([data intValue]==SUCCESS) {
            _broker.workYear = [NSNumber numberWithInteger:integer+1];
            [_tableView reloadData];
            [KGStatusBar showSuccessWithStatus:@"修改成功"];
        }else{
            [KGStatusBar showErrorWithStatus:@"修改失败，请重新上传"];
        }
    }];
}

@end
