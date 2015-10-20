//
//  FriendInviteViewController.m
//  HouseBank
//
//  Created by Gram on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "InviteHistoryViewController.h"
#import "MJRefresh.h"
#import "InviteHistoryViewCell.h"
#import "InviteHistoryFriendsBean.h"
#import "UserBean.h"
#import "FYUserDao.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "FriendsWsImpl.h"

@interface InviteHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,InviteHistoryViewCellDelegate>
{
    NSString *_requestType; //请求类型"收到的=request/receive,发出的=linkinvite/send"
    NSInteger _pageNo; //页码
    NSMutableArray *_data;
    NSString *_sid;
    
    NSInteger _invitType ; ////请求类型 //csc添加
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UILabel *lblNorecord;
@property (weak, nonatomic) IBOutlet UIButton *btnReceive;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation InviteHistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_btnReceive addTarget:self action:@selector(onBtnReceiveClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSend addTarget:self action:@selector(onBtnSendClick) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self initParams];
    [self setupTableView];
    
    if(self.isPushFromFriendInvite == YES)
    {
        [self onBtnSendClick];
    }
    else
    {
        [self onBtnReceiveClick];
    }
}
#pragma mark - 收到的邀请
-(void)onBtnReceiveClick
{
    CGRect frame=_line.frame;
    frame.origin.x=0;
    [UIView animateWithDuration:0.2 animations:^{
        _line.frame=frame;
    }];
    _requestType = @"request/receive";
    _invitType = Receive;
    _pageNo = 1;
    [self getDataFormServer];
}
#pragma mark - 发出去的邀请
-(void)onBtnSendClick
{
    CGRect frame=_line.frame;
    frame.origin.x=160;
    [UIView animateWithDuration:0.2 animations:^{
        _line.frame=frame;
    }];
    _requestType = @"linkinvite/send";
    _invitType = Send;
    _pageNo = 1;
    [self getDataFormServer];
}
#pragma mark - 接受邀请
-(void) onBtnAcceptClick:(InviteHistoryViewCell *)cell
{
    // 接受=1
    [self processInviteRequest:cell setStatus:1];
}
#pragma mark - 拒绝邀请
-(void) onBtnRefuseClick:(InviteHistoryViewCell *)cell
{
    // 拒绝=2
    [self processInviteRequest:cell setStatus:2];
}
#pragma mark - tableview data and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteHistoryViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"InviteHistoryViewCell"];
    if (cell==nil) {
        cell=[[InviteHistoryViewCell alloc]init];
        cell.delegate=self;
    }
    
    
    cell.inviteHistory=_data[indexPath.row];
    if([_requestType  isEqual: @"request/receive"])
    {
        // 查看“收到的邀请”
        cell.labelInviteYou.hidden = NO;
        cell.labelYouInvite.hidden = YES;
        CGRect frame=cell.memberName.frame;
        frame.origin.x = 92;
        cell.memberName.frame=frame;
        
        switch ([cell.inviteHistory.status intValue]) {
            case 1:
                cell.sendInviteStatus.text = @"已接受";
                cell.sendInviteStatus.hidden = NO;
                cell.viewButton.hidden = YES;
                break;
                
            case 2:
                cell.sendInviteStatus.text = @"已拒绝";
                cell.sendInviteStatus.hidden = NO;
                cell.viewButton.hidden = YES;
                break;
                
            default:
                cell.sendInviteStatus.hidden = YES;
                cell.viewButton.hidden = NO;
                break;
        }
    }
    else
    {
        // 查看“我邀请的”
        cell.sendInviteStatus.hidden = NO;
        cell.labelInviteYou.hidden = YES;
        cell.labelYouInvite.hidden = NO;
        cell.viewButton.hidden = YES;
        CGRect frame=cell.memberName.frame;
        frame.origin.x = 135;
        cell.memberName.frame=frame;
        switch ([cell.inviteHistory.status intValue]) {
            case 1:
                cell.sendInviteStatus.text = @"已接受";
                break;
                
            case 2:
                cell.sendInviteStatus.text = @"拒绝";
                break;
                
            default:
                cell.sendInviteStatus.text = @"邀请中";
            break;        }
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}
-(void)initParams
{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    _data=[NSMutableArray array];
    _sid = user.sid;
    _pageNo = 1;
    _requestType = @"request/receive";
}

- (void)setupTableView
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
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

#pragma mark - 获取数据
-(void)getDataFormServer{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    FriendsWsImpl *ws = [FriendsWsImpl new];
    [ws invitFriendsHistory:user.sid invitType:_invitType pageNo:_pageNo result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (_pageNo==1) {
                [_data removeAllObjects];
            }
            
            NSArray *data=[result objectForKey:@"data"];
            if(![data isKindOfClass:[NSNull class]])
            {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    InviteHistoryFriendsBean *inviteHistory=[InviteHistoryFriendsBean modelObjectWithDictionary:obj];
                    [_data addObject:inviteHistory];
                }];
            }
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

#pragma mark - 提交 同意/拒绝
-(void) processInviteRequest:(InviteHistoryViewCell *)cell setStatus:(NSInteger) status{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FriendsWsImpl *ws = [FriendsWsImpl new];
    [ws friendsInvitHandle:user.sid requestId:cell.requestId status:status result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if(status == 1){
                cell.sendInviteStatus.text = @"已接受";
                cell.sendInviteStatus.hidden = NO;
                cell.viewButton.hidden = YES;
            }else{
                cell.sendInviteStatus.text = @"已拒绝";
                cell.sendInviteStatus.hidden = NO;
                cell.viewButton.hidden = YES;
            }
        }else{
            [_tableView headerBeginRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

@end
