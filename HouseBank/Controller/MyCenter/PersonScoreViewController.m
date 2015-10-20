//
//  PersonScroeViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "PersonScoreViewController.h"
#import "BrokerInfoView.h"
#import "ViewUtil.h"
#import "Constants.h"
#import "KGStatusBar.h"
#import "ResultCode.h"
#import "URLCommon.h"
#import "MyCenterWsImpl.h"
#import "WaitingView.h"
#import "AppDelegate.h"
#import "TextUtil.h"
#import "BrokerScoreTableViewCell.h"

/**
 诚信评价
 */
@interface PersonScoreViewController ()<UITableViewDataSource,UITableViewDelegate>{
    __weak UILabel *_label1;
    __weak UILabel *_label2;
    NSArray *_scorsDatas;
}

-(void) doLoadView;
-(void) loadData;
-(void) setLabelText : (id) text1 text2 : (id) text2;
-(void) onDataZero;
-(void) onDataRequested : (NSArray *) datas;

@end

@implementation PersonScoreViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self doLoadView];
    [self loadData];
}

/**
 加载界面
 */
-(void) doLoadView{
    CGRect rect = self.view.bounds;
    self.navigationItem.title = @"诚信评价";
    float topOffset = iOS7 ? 70 : 10;
    
    BrokerInfoView *brokerView = [[BrokerInfoView alloc] initWithFrame:CGRectMake(5, topOffset , rect.size.width - 10, 140)];
    brokerView.backgroundColor = [UIColor whiteColor];
    [brokerView setBroker:self.broker];
    [self.view addSubview:brokerView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, topOffset + 140, rect.size.width - 10, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [self.view addSubview:line];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset + 140.5, (rect.size.width -10)/2 , 50)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.numberOfLines = 0;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    _label1 = label1;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5+(rect.size.width -10)/2, topOffset + 140.5, (rect.size.width -10)/2 , 50)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:12];
    label2.numberOfLines = 0;
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    _label2 = label2;
}

/**
 请求诚信评价数据
 */
-(void) loadData{
    [[WaitingView defaultView] showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在加载..."];
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestPersonScore:[URLCommon buildUrl:RESOURCE_BROKER_SCORE] brokerId:self.broker.brokerId targetBrokerId:@"0" result:^(BOOL isSuccess, id result, NSString *data) {
        [[WaitingView defaultView] dismissWatingView];
        if ([result isKindOfClass:[NSDictionary class]]) {
            [self setLabelText:[result objectForKey:@"scoreNum"] text2:[result objectForKey:@"serviceNum"]];
            if (![[result objectForKey:@"totalSize"] intValue]) {
                [self onDataZero];
            }else{
                [self onDataRequested:[result objectForKey:@"data"]];
            }
        }else{
            //请求失败，关闭当前界面
            [KGStatusBar showErrorWithStatus:@"请求数据失败"] ;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void) setLabelText:(id)text1 text2:(id)text2{
    _label1.text = [NSString stringWithFormat:@"%@\n房源真实度",text1];
    _label2.text = [NSString stringWithFormat:@"%@\n合作诚信度",text2];
}

//当请求数据为空时执行
-(void) onDataZero{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7 ? 70 : 10 ;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, topOffset+200, rect.size.width - 10, 170)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    float imgWidth = 68;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - imgWidth)/2, 20, imgWidth, imgWidth)];
    imageView.image = [UIImage imageNamed:@"ic_stat_no_result"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imgWidth + 30, view.frame.size.width - 20, 50)];
    label.numberOfLines = 0;
    label.text = @"您现在还没有合作评价，赶快发起合作，提升自己诚信度吧";
    [view addSubview:label];
}

//当个人评价数据请求不为空时执行
-(void) onDataRequested:(NSArray *)datas{
    _scorsDatas = datas;
    
    CGRect rect = self.view.bounds;
    float topOffset = iOS7 ? 70 : 10 ;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, topOffset+200, rect.size.width - 10, rect.size.height - topOffset - 200)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark table view delegation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   [_scorsDatas count];
};


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    BrokerScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BrokerScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell refresh:[_scorsDatas objectAtIndex:indexPath.row]];
    
    return cell;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
};

@end
