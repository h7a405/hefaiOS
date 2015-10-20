//
//  CallRecordViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-18.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CallRecordViewController.h"
#import "ViewUtil.h"
#import "Constants.h"
#import "KGStatusBar.h"
#import "ResultCode.h"
#import "URLCommon.h"
#import "MyCenterWsImpl.h"
#import "WaitingView.h"
#import "AppDelegate.h"
#import "TextUtil.h"
#import "CallRecords.h"
#import "House.h"
#import "HouseListCell.h"
#import "HouseInfoViewController.h"
#import "PullTableView.h"
#import "XSNewHouseInfoViewController.h"
#import "XSNewHouseCell.h"
#import "NewHouseBean.h"
#import "NSDictionary+String.h"

#define BtnStrs @[@"二手房",@"新房",@"租房"]

@interface CallRecordViewController ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>{
    UIView *_positionStrip;
    NSInteger _currentIndex;
    NSInteger _pageNo;
    NSMutableArray *_houses ;
    PullTableView *_tableView;
    UIButton *_clearBtn;
    UIView *_noDataView;
    
    NSMutableArray *_data;
}

-(void) doLoadView;
-(void) loadData ;
-(void) onBtnClick : (UIButton *) btn;
-(void) onClearBtnClick ;
-(void) moveStripToPosition : (NSInteger) index;
-(void) onDataEmtry : (BOOL) isEmtry;
@end

@implementation CallRecordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"通话记录";
    _houses = [NSMutableArray array];
    _data=[NSMutableArray array];
    [self doLoadView];
    [self loadData];
}

/**
 加载界面
 */
-(void)doLoadView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7 ? self.navigationController.navigationBar.frame.size.height+20:0;
    
    float btnCount = [BtnStrs count];
    float btnWidth = rect.size.width / btnCount;
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*i, topOffset, btnWidth, 40)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[BtnStrs objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setBackgroundImage:[ViewUtil imageWithColor:[UIColor colorWithWhite:0.9 alpha:1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth * i-1, topOffset + 5, 0.5 , 30)];
        line.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self.view addSubview:line];
    }
    
    _positionStrip = [[UIView alloc] initWithFrame:CGRectMake(0, topOffset + 38, btnWidth, 2)];
    _positionStrip.backgroundColor = KNavBGColor;
    [self.view addSubview:_positionStrip];
    
    _tableView = [[PullTableView alloc] initWithAttribute:CGRectMake(0, topOffset + 40, rect.size.width, rect.size.height - topOffset - 80) style:UITableViewStyleGrouped isHasHeader:NO isHasFooter:YES];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, rect.size.height - 40, rect.size.width, 40)];
    [clearBtn setBackgroundImage:[ViewUtil imageWithColor:[ViewUtil string2Color:@"ff9900"]] forState:UIControlStateNormal];
    [clearBtn setTitle:@"清  空" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(onClearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
    _clearBtn = clearBtn;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topOffset + 40, rect.size.width, rect.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    float imgWidth = 68;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - imgWidth)/2, 20, imgWidth, imgWidth)];
    imageView.image = [UIImage imageNamed:@"ic_stat_no_result"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imgWidth + 30, view.frame.size.width - 20, 50)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有通话记录";
    [view addSubview:label];
    
    _noDataView = view;
    _noDataView.hidden = YES;
}

-(void) loadData{
    NSString *houseType=nil;
    if (_currentIndex==0) {
        houseType=[NSString stringWithFormat:@"%d",_currentIndex+1];
    }else if(_currentIndex==1){
        houseType=[NSString stringWithFormat:@"%d",_currentIndex+2];
    }else if (_currentIndex==2){
        houseType=[NSString stringWithFormat:@"%d",_currentIndex];
    }
    NSArray *callRecords = [CallRecords allCallRectrdsWithBrokerId : [NSString stringWithFormat:@"%@",self.broker.brokerId] andHouseType:houseType];
    NSMutableArray *array = [NSMutableArray new];
    
    if ([callRecords count]) {
        for (CallRecords *record in callRecords) {
            
            [array addObject:record.relationId];
            
        }
    }else{
        
    }
    
    NSString *houseIds = [[[array description] stringByReplacingOccurrencesOfString:@"(" withString:@"["] stringByReplacingOccurrencesOfString:@")" withString:@"]"];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    NSString *url=nil;
    if (_currentIndex==1) {
        url=[URLCommon buildUrl:RESOURCE_NEW_HOUSE_CALLRECORD];
    }else{
        url=[URLCommon buildUrl:CALLRECORD_HOUSE];
    }
    [ws requestHouse:url relationIds:houseIds pageNo:++_pageNo result:^(BOOL isSuccess, id result, NSString *data) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (_currentIndex==1) {//新房
                NSInteger totalSize = [[result objectForKey:@"totalSize"] intValue];
                NSArray *data=[result objectForKey:@"data"];
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [_houses addObject:[NewHouseBean modelObjectWithDictionary:[obj allStringObjDict]]];
                }];
                _tableView.isHasFooter = totalSize > [_houses count];
            }else{//二手房和出租房
                NSArray *array = [result objectForKey:@"data"];
                NSInteger totalSize = [[result objectForKey:@"totalSize"] intValue];
                for (NSDictionary *dic in array) {
                    House *house = [House modelObjectWithDictionary:dic];
                    [_houses addObject:house];
                }
                _tableView.isHasFooter = totalSize > [_houses count];
            }
        }
        _tableView.pullTableIsLoadingMore  = NO;
        [_tableView reloadData];
        
        [self onDataEmtry : [_houses count] == 0];
    }];
}

-(void) onBtnClick:(UIButton *)btn{
    if (_currentIndex != btn.tag) {
        
        [self moveStripToPosition:btn.tag];
        _currentIndex = btn.tag;
        _pageNo = 0;
        [_houses removeAllObjects];
        [self onDataEmtry:YES];
        [self loadData];
    }
}

-(void) onClearBtnClick{
    NSString *houseType=nil;
    if (_currentIndex==0) {
        houseType=[NSString stringWithFormat:@"%d",_currentIndex+1];
    }else if(_currentIndex==1){
        houseType=[NSString stringWithFormat:@"%d",_currentIndex+2];
    }else if (_currentIndex==2){
        houseType=[NSString stringWithFormat:@"%d",_currentIndex];
    }
    
    if([CallRecords removeAllCallRecordsWithBrokerId:[NSString stringWithFormat:@"%@",self.broker.brokerId] andHouseType:houseType]){
        [_houses removeAllObjects];
        [_tableView reloadData];
        [self onDataEmtry:YES];
    }
    
}

-(void) onDataEmtry:(BOOL)isEmtry{
    _tableView.hidden = isEmtry;
    _clearBtn.hidden = isEmtry;
    _noDataView.hidden = !isEmtry;
}

-(void) moveStripToPosition:(NSInteger)index{
    CGRect rect = self.view.bounds;
    
    float btnCount = [BtnStrs count];
    float btnWidth = rect.size.width / btnCount;
    
    int diff = index - _currentIndex;
    
    CGPoint newCenter = CGPointMake(_positionStrip.center.x + diff*btnWidth, _positionStrip.center.y);
    [UIView animateWithDuration:0.2 animations:^{
        _positionStrip.center = newCenter;
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    _houses = nil;
    _tableView = nil;
    _clearBtn = nil;
    _noDataView = nil;
}

#pragma mark -  table view delegation
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_currentIndex==1) {
        XSNewHouseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSNewHouseCell"];
        if (cell==nil) {
            cell=[[XSNewHouseCell alloc]init];
        }
        cell.house=_houses[indexPath.row];
        return cell;
    }else{
        HouseListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HouseListCell"];
        
        if (cell==nil) {
            cell=[[HouseListCell alloc]init];
        }
        cell.isSell = YES;
        cell.house=_houses[indexPath.row];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_houses count];
};


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentIndex==1) {
        XSNewHouseInfoViewController  *house=[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"XSNewHouseInfoViewController"];
        NewHouseBean *model=_houses[indexPath.row];
        
        house.projectId=model.projectId;
        [self.navigationController pushViewController:house animated:YES];
        
    }else{
        HouseInfoViewController *vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"HouseInfoViewController"];
        House *house=_houses[indexPath.row];
        vc.houseId=house.houseId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 刷新组件
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView{
    [self loadData];
};

- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView{
};

@end
