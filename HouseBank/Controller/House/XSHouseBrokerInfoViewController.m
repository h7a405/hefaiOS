//
//  XSHouseBrokerInfoViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSHouseBrokerInfoViewController.h"
#import "MyCenterWsImpl.h"
#import "BrokerInfoBean.h"
#import "House.h"
#import "HouseInfoViewController.h"
#import "BrokerCommentBean.h"
#import "XSBrokerCommentCell.h"
#import "XSHouseListNoFilterViewController.h"
#import "BrokerCommentBean.h"
#import "URLCommon.h"
#import "FYUserDao.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "HouseWsImpl.h"
#import "ResultCode.h"

@interface XSHouseBrokerInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,XSBrokerCommentCellDelegate>
{
    BrokerInfoBean *_broker;
    NSString *_houseId;
    NSMutableArray *_data;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobilephone;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *scoreHouseTruth;
@property (weak, nonatomic) IBOutlet UILabel *scoreService;
@property (weak, nonatomic) IBOutlet UILabel *authStatus;
@property (weak, nonatomic) IBOutlet UIView *noHouseListView;
@property (weak, nonatomic) IBOutlet UILabel *houseCount;
@property (weak, nonatomic) IBOutlet UIView *noComment;


@property (weak, nonatomic) IBOutlet UIImageView *imagePath;
@property (weak, nonatomic) IBOutlet UILabel *advTitle;
@property (weak, nonatomic) IBOutlet UILabel *community;
@property (weak, nonatomic) IBOutlet UILabel *bedRooms;
@property (weak, nonatomic) IBOutlet UILabel *buildArea;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XSHouseBrokerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray array];
    
    _scrollView.contentSize=_scrollView.frame.size;
    _scrollView.frame=self.view.bounds;
    [self getUserInfo];
}


#pragma mark - 查看此经纪人的所有房源
- (IBAction)lookAllHouseList:(id)sender
{
    [self performSegueWithIdentifier:@"XSHouseListNoFilterViewController" sender:nil];
}
#pragma mark - 查看某一个房源信息
- (IBAction)lookHouseInfo:(id)sender
{
    [self performSegueWithIdentifier:@"brokerHouseInfoDetail" sender:nil];
    
}
#pragma mark - 跳转页面处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"brokerHouseInfoDetail"]) {
        HouseInfoViewController *info=segue.destinationViewController;
        info.houseId=_houseId;
    }else if([segue.identifier isEqualToString:@"XSHouseListNoFilterViewController"]){
        XSHouseListNoFilterViewController *list=segue.destinationViewController;
        list.brokerId=_brokerId;
    }
}
#pragma mark - 经纪人信息
-(void)getUserInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestBrokerInfo:KUrlConfig brokerId:_brokerId result:^(BOOL isSeccess,id result,NSString *data){
        if (isSeccess) {
            _broker= [BrokerInfoBean brokerFromDic:result];
            _name.text=[NSString stringWithFormat:@"%@",_broker.name];
            _company.text=_broker.company;
            _store.text=_broker.store;
            _mobilephone.text=[NSString stringWithFormat:@"%@",_broker.mobilephone];
            _authStatus.text=[Tool authStatus:[NSString stringWithFormat:@"%@",_broker.authStatus]];
            if (![_broker.brokerHeadImg isKindOfClass:[NSNull class]]) {//设置用户头像
                NSString *url = [URLCommon buildImageUrl:_broker.brokerHeadImg imageSize:L03 brokerId:_broker.brokerId];
                [_headerImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nophoto"]];
            }
            [self getBrokerScore];
        }
        ;
    }];
}
#pragma mark - 用户评价
-(void)getBrokerScore{
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws brokerScore:_brokerId pageNo:1 pageSize:15 targetBrokerId:_brokerId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            _scoreService.text=[NSString stringWithFormat:@"%@",[result objectForKey:@"serviceNum"]];
            _scoreHouseTruth.text=[NSString stringWithFormat:@"%@",[result objectForKey:@"scoreNum"]];
            _commentCount.attributedText=[ViewUtil content:[NSString stringWithFormat:@"合作评价(%@)",[result objectForKey:@"totalSize"]] colorString:[NSString stringWithFormat:@"%@",[result objectForKey:@"totalSize"]]];
            if([[result objectForKey:@"totalSize"] integerValue]==0){
                _noComment.hidden=NO;
            }else{
                _noComment.hidden=YES;
            }
            NSArray *data=[result objectForKey:@"data"];
            if (![data isKindOfClass:[NSNull class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    BrokerCommentBean *comment=[BrokerCommentBean modelObjectWithDictionary:obj];
                    [_data addObject:comment];
                }];
                [_tableView reloadData];
            }
            [self getHouseList];
        }
    }];
}

#pragma mark - 查看这个经纪人所有的房子列表
-(void)getHouseList{
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws brokerHouseList:_brokerId result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccess) {
            if([[result objectForKey:@"totalSize"] integerValue]==0){
                _noHouseListView.hidden=NO;
            }else{
                NSDictionary *dict=[[result objectForKey:@"data"] firstObject];
                House *_house=[House modelObjectWithDictionary:dict];
                _houseCount.attributedText=[ViewUtil content:[NSString stringWithFormat:@"二手房(%@)",[result objectForKey:@"totalSize"]] colorString:[NSString stringWithFormat:@"%@",[result objectForKey:@"totalSize"]]];
                
                [_imagePath sd_setImageWithURL:_house.imagePath placeholderImage:[UIImage imageNamed:@"noimg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
                _advTitle.text=_house.advTitle;
                _community.text=_house.community;
                _bedRooms.text=[NSString stringWithFormat:@"%@室%@厅",_house.bedRooms,_house.livingRooms];
                _buildArea.text=[NSString stringWithFormat:@"%@平米",_house.buildArea];
                _price.text=[NSString stringWithFormat:@"%@万",_house.price];
                _houseId=_house.houseId;
                
            }
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

#pragma mark - tableview datasoures and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XSBrokerCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSBrokerCommentCell"];
    if (cell==nil) {
        cell=[XSBrokerCommentCell cell];
        cell.delegate=self;
    }
    cell.model=_data[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.f;
}

- (IBAction)rightItemClick:(UIBarButtonItem *)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你正在添加%@为好友，确定添加吗?",_name.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)clickComment:(BrokerCommentBean *)comment{
    HouseWsImpl *ws = [HouseWsImpl new];
    [ws submitBrokerComment:comment.internalBaseClassIdentifier result:^(BOOL isSuccess, id result, NSString *data) {
        if (!isSuccess) {
            if ([data intValue] == SUCCESS) {
                [MBProgressHUD showMessag:@"提交成功!" toView:[KAPPDelegate window]];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FYUserDao *userDao = [FYUserDao new];
        UserBean *user = [userDao user];
        
        HouseWsImpl *ws = [HouseWsImpl new];
        [ws inviteFriend:user.sid receiverName:_broker.name receiverMobilephone:_broker.mobilephone content:[NSString  stringWithFormat:@"我是%@，正在合发房银构建房源合作人脉。登录fybanks.com添加我为人脉，我们就可以合作啦！",user.name] result:^(BOOL isSuccess, id result, NSString *data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!isSuccess && [data isEqualToString:@"true"]) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"邀请发送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"邀请发送失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            }
        }];
    }
}
@end
