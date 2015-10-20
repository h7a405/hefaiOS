//
//  MessageRecordViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-18.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "MessageRecordViewController.h"
#import "XSNotification.h"
#import "XSShowNotificationViewController.h"

/**
 消息中心
 */
@interface MessageRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIView *nodataView;

@end

@implementation MessageRecordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    
    _data =[NSMutableArray array];
    [self loadMoreData];
}

-(void)loadMoreData{
    [_data removeAllObjects];
    NSArray *data=[XSNotification allNotification];
    [_data addObjectsFromArray:data];
    [_tableView reloadData];
    
    _nodataView.hidden = _data.count!=0 ;
    _clearBtn.hidden = _data.count==0 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageRecordViewController"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MessageRecordViewController"];
    }
    XSNotification *notification=_data[indexPath.row];
    cell.textLabel.text=notification.title;
    cell.detailTextLabel.text=notification.content;
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"notification%@",notification.type]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - 推送信息分类
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XSNotification *notification=_data[indexPath.row];
    if ([notification.type integerValue]==0||[notification.type integerValue]==4) {
        [self performSegueWithIdentifier:@"XSShowNotificationViewController" sender:notification];
    }else if ([notification.type integerValue]==3){
        UIViewController *controller=[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"XSCooperationViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([notification.type integerValue]==2){
        UIViewController *controller=[[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"FriendsViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([notification.type integerValue]==3){
        UIViewController *controller=[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"XSSubscibeViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"XSShowNotificationViewController"]) {
        XSShowNotificationViewController *show=segue.destinationViewController;
        show.notification=sender;
    }
}
#pragma mark - 清除所有通知
- (IBAction)cleanClick:(id)sender{
    [XSNotification cleanAllNotification];
    [self loadMoreData];
}

@end
