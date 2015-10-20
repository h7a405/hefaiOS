//
//  ChangeBlockViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "ChangeBlockViewController.h"
#import "ViewUtil.h"
#import "TextUtil.h"
#import "Address.h"
#import "MyCenterWsImpl.h"
#import "URLCommon.h"
#import "Constants.h"
#import "WaitingView.h"
#import "KGStatusBar.h"
#import "BrokerDetailInfoBean.h"
#import "ResultCode.h"
#import "FYUserDao.h"

/**
 选择熟悉板块
 */
@interface ChangeBlockViewController ()<UITableViewDataSource,UITableViewDelegate>{
    __weak BrokerInfoBean *_broker;
    
    int _currentIndex;//当前点击的按钮
    
    __weak UIButton *_btn1;
    __weak UIButton *_btn2;
    __weak UIButton *_btn3;
    __weak UIButton *_btn4;
    
    NSMutableArray *_blocks;
    
    __weak UIView *_tableViewContainer;
    __weak UITableView *_tableView;
    __weak WaitingView *_waitingView;
    
    BrokerDetailInfoBean *_brokerDetail;
    __weak UILabel *_titleLabel;
    
    NSArray *_addresses;
    int _cityId ;
    BOOL _isSecondCheck;
}

-(void) doLoadView ;
-(void) onBtnClick : (id) sender;
-(void) setBtnText ;
-(void) loadTableView ;
-(void) dismissTableView ;
-(void) showTableView ;
-(void) requestData ;
-(void) setBtnText:(NSInteger) index text : (NSString *) text;
-(void) onAddressCheck : (Address *) address index : (NSInteger) index;
-(void) onSaveBtnClick;
-(void) onCloseBtnClick;
@end

@implementation ChangeBlockViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self doLoadView];
    [self loadTableView];
    [self requestData];
    [self.navigationItem setTitle:@"选择熟悉板块"];
}

//加载界面
-(void) doLoadView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7 ? 65 : 5;
    float itemHeight = 74;
    
    //四个按钮和按钮对应的提示
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5, 100, 20)];
    lable1.text = @"熟悉板块一";
    lable1.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight, 100, 20)];
    lable2.text = @"熟悉板块二";
    lable2.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight*2, 100, 20)];
    lable3.text = @"熟悉板块三";
    lable3.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable3];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(5, topOffset+5+itemHeight*3, 100, 20)];
    lable4.text = @"熟悉板块四";
    lable4.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    lable4.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lable4];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30, rect.size.width - 20, 44)];
    [btn1 setBackgroundImage:[ViewUtil imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    btn1.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    btn1.layer.borderWidth = 0.5f;
    btn1.tag = 1;
    [btn1 setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    _btn1 = btn1;
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight, rect.size.width - 20, 44)];
    [btn2 setBackgroundImage:[ViewUtil imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    btn2.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    btn2.layer.borderWidth = 0.5f;
    [btn2 setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    _btn2 = btn2;
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30 + itemHeight*2, rect.size.width - 20, 44)];
    [btn3 setBackgroundImage:[ViewUtil imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    btn3.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    btn3.layer.borderWidth = 0.5f;
    [btn3 setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
    btn3.tag = 3;
    [btn3 addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    _btn3 = btn3;
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight*3, rect.size.width - 20, 44)];
    [btn4 setBackgroundImage:[ViewUtil imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    btn4.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    btn4.layer.borderWidth = 0.5f;
    [btn4 setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
    btn4.tag = 4;
    [btn4 addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    _btn4 = btn4;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, topOffset + 30+ itemHeight*4, rect.size.width - 20, 44)];
    [saveBtn setBackgroundImage:[ViewUtil imageWithColor:[ViewUtil string2Color:@"ff9900"] ] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
    [self loadTableView];
}

//加载选择选择区域列表
-(void) loadTableView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7?65:5;
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:view];
    
    _tableViewContainer = view;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, topOffset + 20, rect.size.width - 60, 40)];
    label.backgroundColor = [UIColor blackColor];
    label.text = @"选择区域";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    _titleLabel = label;
    
    UIButton *clossBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, topOffset + 25, 30, 30)];
    [clossBtn setImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
    [view addSubview:clossBtn];
    [clossBtn addTarget:self action:@selector(onCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, topOffset + 60, rect.size.width - 60, rect.size.height - 170)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [view addSubview:tableView];
    
    [self dismissTableView];
    _tableView = tableView;
}

//隐藏选择区域列表
-(void) dismissTableView{
    [UIView animateWithDuration:0.3 animations:^{
        _tableViewContainer.alpha = 0;
        _tableView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _titleLabel.frame = CGRectMake(30, 0, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    } completion:^(BOOL isFinish){
        _tableViewContainer.hidden = YES;
    }];
};

//显示选择区域列表
-(void) showTableView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7?65:5;
    
    _tableViewContainer.alpha = 0;
    _tableViewContainer.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _tableViewContainer.alpha = 1.0f;
        _tableView.frame = CGRectMake(30, topOffset + 60, rect.size.width - 60, rect.size.height - 170);
        _titleLabel.frame = CGRectMake(30, topOffset + 20, rect.size.width - 60, 40);
    } completion:^(BOOL isFinish){
        
    }];
};

//请求经理人熟悉板块数据
-(void) requestData{
    WaitingView *waitingView = [[WaitingView alloc] initWithFrame:self.view.bounds];
    [waitingView showWaitingViewWithHintTextInView:self.view hintText:@"正在连接..."];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestBrokerDetall:[URLCommon buildUrl:RESOURCE_BROKER_DETAIL resourceId:_broker.brokerId ] result:^(BOOL isSuccess , id result ,NSString *data){
        [waitingView dismissWatingView];
        if (isSuccess) {
            BrokerDetailInfoBean *brokerDetail = [BrokerDetailInfoBean brokerDetailByDic:result];
            _brokerDetail = brokerDetail;
            [self setBtnText];
        }else{
            [KGStatusBar showErrorWithStatus:@"加载失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void) setBroker : (BrokerInfoBean *) broker{
    _broker = broker;
    _cityId = [broker.regionId intValue]/100;
    //    [self setBtnText];
};

-(void) onCloseBtnClick{
    [self dismissTableView];
}

//地名按钮点击时执行
-(void) onBtnClick:(id)sender {
    UIButton *btn = sender;
    //设置当前选择的按钮位置
    _currentIndex = btn.tag;
    
    //刷新弹出框数据
    _addresses = [Address addressDataWithPid:[NSString stringWithFormat:@"%d",_cityId]];
    [_tableView reloadData];
    
    _titleLabel.text = @"选择区域";
    //设置弹出框点击次数未非第二次点击
    _isSecondCheck = NO;
    [self showTableView];
}


-(void) setBtnText {
    NSMutableArray *array = [NSMutableArray new];
    //从地址数据库获取该经纪人的区域板块地址
    NSArray *a1 = [Address addressByAId:_brokerDetail.familiarBlock1];
    //设置相应的地址
    if ([a1 count]) {
        Address *add = [a1 objectAtIndex:0];
        [array addObject:add.name];
    }else{
        [array addObject:@""];
    }
    
    NSArray *a2 = [Address addressByAId:_brokerDetail.familiarBlock2];
    if ([a2 count]) {
        Address *add = [a2 objectAtIndex:0];
        [array addObject:add.name];
    }else{
        [array addObject:@""];
    }
    
    NSArray *a3 = [Address addressByAId:_brokerDetail.familiarBlock3];
    if ([a3 count]) {
        Address *add = [a3 objectAtIndex:0];
        [array addObject:add.name];
    }else{
        [array addObject:@""];
    }
    
    NSArray *a4 = [Address addressByAId:_brokerDetail.familiarBlock4];
    if ([a4 count]) {
        Address *add = [a4 objectAtIndex:0];
        [array addObject:add.name];
    }else{
        [array addObject:@""];
    }
    
    _blocks = [NSMutableArray arrayWithArray:array];
    
    //显示相应的地名
    for (int i = 0; i<[array count]; i++) {
        UIButton *btn;
        switch (i) {
            case 0:
                btn = _btn1;
                break;
            case 1:
                btn = _btn2;
                break;
            case 2:
                btn = _btn3;
                break;
            case 3:
                btn = _btn4;
                break;
                
            default:
                break;
        }
        
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
    }
}

-(void) setBtnText:(NSInteger) index text : (NSString *) text{
    UIButton *btn;
    switch (_currentIndex) {
        case 1:
            btn = _btn1;
            break;
        case 2:
            btn = _btn2;
            break;
        case 3:
            btn = _btn3;
            break;
        case 4:
            btn = _btn4;
            break;
            
        default:
            break;
    }
    
    [btn setTitle:text forState:UIControlStateNormal];
};

-(void) onAddressCheck:(Address *)address index:(NSInteger)index  {
    //当弹出框的地址被选择时执行
    int tId = [address.tid intValue];
    
    //判断地址是否存在
    BOOL isExists = NO;
    
    if ([_brokerDetail.familiarBlock1 intValue] == tId) {
        isExists = YES;
    }
    
    if ([_brokerDetail.familiarBlock2 intValue] == tId) {
        isExists = YES;
    }
    
    if ([_brokerDetail.familiarBlock3 intValue] == tId) {
        isExists = YES;
    }
    
    if ([_brokerDetail.familiarBlock4 intValue] == tId) {
        isExists = YES;
    }
    
    //存在
    if(isExists){
        [KGStatusBar showErrorWithStatus:@"所选地名已经存在"];
    }
    else{
        //不存在
        //改变相应的按钮的显示，地名
        [self setBtnText:index text:address.name];
        //替换相应的经纪人区域板块id
        if (_currentIndex == 1) {
            _brokerDetail.familiarBlock1 = [NSNumber numberWithInt:tId];
        }else if(_currentIndex == 2){
            _brokerDetail.familiarBlock2 = [NSNumber numberWithInt:tId];
        }else if(_currentIndex == 3){
            _brokerDetail.familiarBlock3 = [NSNumber numberWithInt:tId];
        }else if(_currentIndex == 4){
            _brokerDetail.familiarBlock4 = [NSNumber numberWithInt:tId];
        }
        
        //替换相应的地名
        [_blocks replaceObjectAtIndex:_currentIndex-1 withObject:address.name];
    }
}

-(void) onSaveBtnClick{
    //显示等待界面
    WaitingView *waitingView = [[WaitingView alloc] initWithFrame:self.view.bounds];
    [waitingView showWaitingViewWithHintTextInView:self.view hintText:@"正在连接..."];
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws updateBrokerBlock:[URLCommon buildUrl:UPDATE_BROKER_INFO] block1:_brokerDetail.familiarBlock1 block2:_brokerDetail.familiarBlock2 block3:_brokerDetail.familiarBlock3 block4:_brokerDetail.familiarBlock4 sid:user.sid result:^(BOOL isSuccess, id result, NSString *data) {
        //请求完成关闭等待界面
        [waitingView dismissWatingView];
        if (SUCCESS == [data intValue]) {
            //上传成功修改经纪人区域板块
            NSMutableString *string = [NSMutableString new];
            for (NSString *str in _blocks) {
                [string appendString:str];
                [string appendString:@" "];
            }
            
            _broker.familiarBlock = [NSString stringWithString:string];
            //关闭当前界面
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [KGStatusBar showErrorWithStatus:@"上传区域模块失败!"];
        }
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark table view deletagion
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_addresses count];
};

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    Address *address = [_addresses objectAtIndex:indexPath.row];
    cell.textLabel.text = address.name;
    
    return cell;
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Address *address = [_addresses objectAtIndex:indexPath.row];
    
    if (_isSecondCheck) {
        [self dismissTableView];
        
        [self onAddressCheck:address index:indexPath.row];
    }else{
        NSString *cityId = [NSString stringWithFormat:@"%@",address.tid];
        _addresses = [Address addressDataWithPid:cityId];
        [tableView reloadData];
        
        _titleLabel.text = @"选择板块";
    }
    
    _isSecondCheck = YES;
};

@end
