//
//  XSSubscibeViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSSubscibeViewController.h"
#import "SelectTypeView.h"
#import "XSSelectDataArea.h"
#import "SelectPrice.h"
#import "XSSubscibeListViewController.h"
#import "FYUserDao.h"
#import "AFNetworking.h"
#import "Address.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "SubscibeWsImpl.h"

@interface XSSubscibeViewController ()<UITableViewDelegate,UITableViewDataSource,SelectTypeViewDelegate,XSSelectDataAreaDelegate,SelectPriceDelegate>{
    NSMutableArray *_titles;
    
    NSArray *_provience;
    NSArray *_city;
    NSArray *_area;
    NSArray *_strees;
    
    NSString *_cityId;
    NSString *_areaId;
    NSString *_streesId;
    
    NSString *_priceBegin;
    NSString *_prictEnd;
    
    NSString *_areaBegin;
    NSString *_areaEnd;
    
    NSString *_target;
    
    
    AddressLevel _level;
    NSString *_addressInfo;
    NSInteger _currentIndex;
    
    NSMutableArray *_data;
    XSSelectDataArea *_selectAreaView;
}

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *rentBtn;
@end

@implementation XSSubscibeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (_type==HouseTypeRent) {
        
        [self typeChange:_rentBtn];
        
    }else{
        
        [self getSubscibeData];
    }
    
    _city=[NSMutableArray array];
    _provience=[NSMutableArray array];
    _area=[NSMutableArray array];
    _strees=[NSMutableArray array];
    _titles=[NSMutableArray array];
    _data=[NSMutableArray array];
    [_titles addObjectsFromArray:@[@"人群",@"区域",@"面积",@"租金"]];
    
}
#pragma mark - tableview data source and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font=[UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14.f];
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        cell.selectedBackgroundView=view;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text=@" ";
    }
    if (_data.count>0) {
        cell.detailTextLabel.text=_data[indexPath.row];
    }
    cell.textLabel.text=_titles[indexPath.row];
    if (indexPath.row==3) {
        if(_type==HouseTypeSell){
            cell.textLabel.text=@"售价";
        }
    }
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
#pragma mark - 点击选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selected=NO;
    _currentIndex=indexPath.row;
    if(indexPath.row==1){//选择地区
        [self showSelectTypeView:AddressLevelProvince];
    }else if (indexPath.row==0){//选择人群
        [self showSelectPerson];
    }else if(indexPath.row==2){//选择面积
        NSLog(@"++++");
        [self selectArea];
    }else if (indexPath.row==3){//租金、售价
        [self selectPrice];
    }
}

#pragma mark - 选择地区
-(void)typeView:(SelectTypeView *)view didSelect:(NSString *)str selectIndex:(NSInteger)index
{
    UITableViewCell *cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    if (_currentIndex==1) {
        
        if (_level==AddressLevelProvince) {
            _addressInfo=str;
        }else{
            _addressInfo= [_addressInfo stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
        }
        
        cell.detailTextLabel.text=_addressInfo;
        //_address.text=_addressInfo;
        if (_level==AddressLevelProvince) {
            _city=[Address citysWithProvience:_provience[index]];
            Address *address=_city[0];
            
            if (_city.count==1&&[str isEqualToString:address.name]) {
                _cityId=[NSString stringWithFormat:@"%@",[_city[0] tid]];
                _area=[Address areasWithCity:_city[0]];
                [self showSelectTypeView:AddressLevelArea];
            }else{
                [self showSelectTypeView:AddressLevelCity];
            }
        }else if (_level==AddressLevelCity){
            _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
            _area=[Address areasWithCity:_city[index]];
            [self showSelectTypeView:AddressLevelArea];
        }else if (_level==AddressLevelArea){
            _areaId=[NSString stringWithFormat:@"%@",[_area[index] tid]];
            
            _strees=[Address streesWithArea:_area[index]];
            [self showSelectTypeView:AddressLevelStreet];
        }else{
            _streesId=[NSString stringWithFormat:@"%@",[_strees[index] tid]];
        }
    }else if (_currentIndex==0){
        
        cell.detailTextLabel.text=str;
        _target=[NSString stringWithFormat:@"%d",index];
    }
    
}
#pragma mark - 显示选择地理位置
-(void)showSelectTypeView:(AddressLevel)level
{
    SelectTypeView *view=[[SelectTypeView alloc]init];
    
    [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
    view.delegate=self;
    NSMutableArray *tmp=[NSMutableArray array];
    _level=level;
    if (level==AddressLevelProvince) {
        _provience=[Address getAllProvience];
        
        [_provience enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
            
        }];
        [view showWithTitle:@"请选择省份"];
    }else if (level==AddressLevelCity){
        [_city enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
            
        }];
        [view showWithTitle:@"请选择城市"];
    }else if (level==AddressLevelArea){
        [_area enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择区域"];
    }else if (level==AddressLevelStreet){
        [_strees enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择版块"];
    }
    view.data=tmp;
}
#pragma mark - 选择人群
-(void)showSelectPerson
{
    SelectTypeView *view=[[SelectTypeView alloc]init];
    
    [view setClickButtonFrame:CGRectMake(0, 150, 0, 0)];
    view.delegate=self;
    NSMutableArray *tmp=[NSMutableArray array];
    [tmp addObjectsFromArray:@[@"所有经纪人",@"朋友"]];
    
    [view showWithTitle:@"订阅人群"];
    view.data=tmp;
}
#pragma mark - 选择面积
-(void)selectArea
{
    NSArray *tmp=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"]];
    
    if (_selectAreaView==nil) {
        _selectAreaView=[[XSSelectDataArea alloc]initWithFrame:CGRectZero andData:[tmp[1] objectForKey:@"data"]];
        _selectAreaView.delegate=self;
    }
    NSLog(@"%@",_selectAreaView);
    [_selectAreaView show];
}
-(void)selectDataArea:(XSSelectDataArea *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end name:(NSString *)name
{
    
    UITableViewCell *cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    
    cell.detailTextLabel.text=name;
    _areaBegin=begin;
    _areaEnd=end;
}
#pragma mark - 选择价格
-(void)selectPrice
{
    NSString *fileName=nil;
    if (_type==HouseTypeSell) {
        fileName=@"Price";
    }else{
        fileName=@"Rent";
    }
    NSArray *tmp=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:fileName withExtension:@"plist"]];
    SelectPrice *price=[[SelectPrice alloc]initWithFrame:CGRectZero andData:tmp];
    price.delegate=self;
    [price show];
    
}
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end name:(NSString *)name
{
    
    UITableViewCell *cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    
    cell.detailTextLabel.text=name;
    _priceBegin=begin;
    _prictEnd=end;
}

#pragma mark - 改变订阅类型
- (IBAction)typeChange:(UIButton *)sender
{
    CGRect frame=_line.frame;
    frame.origin.x=160*sender.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _line.frame=frame;
    }];
    _type=sender.tag;
    
    [self getSubscibeData];
}

#pragma mark - 提交订阅
- (IBAction)submit:(id)sender{
    //    [self performSegueWithIdentifier:@"XSSubscibeListViewController" sender:nil];
    
    if(_target==nil){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择订阅人群!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }else if (_streesId==nil){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择订阅区域!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    if (_priceBegin==nil){
        _priceBegin=@"0";
        _prictEnd=@"0";
        
    }
    
    if (_areaBegin==nil){
        _areaBegin=@"0";
        _areaEnd=@"0";
        
    }
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SubscibeWsImpl *ws = [SubscibeWsImpl new];
    
    [ws submitSubscibe:user.sid contentType:@"1" target:_target regionId:_streesId priceFrom:_priceBegin priceTo:_prictEnd areaFrom:_areaBegin areaTo:_areaEnd tradeType:_type+1  purpose:@"1" result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSuccess) {
            if ([data isEqualToString:@"0"]) {//订阅成功走此方法
                [self performSegueWithIdentifier:@"XSSubscibeListViewController" sender:nil];
            }
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    XSSubscibeListViewController *list=segue.destinationViewController;
    list.houseType=_type;
}

#pragma mark - 获取订阅信息
-(void)getSubscibeData{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SubscibeWsImpl *ws = [SubscibeWsImpl new];
    [ws requestSubscibe:user.sid contentType:@"1" tradeType:_type+1 result:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            [_data removeAllObjects];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([result isKindOfClass:[NSNull class]]||result==nil) {
                [_tableView reloadData];
                return ;
            }
            NSDictionary *dict=[result allStringObjDict];
            
            _target=dict[@"target"];
            _streesId=dict[@"regionId"];
            _priceBegin=dict[@"priceFrom"];
            _prictEnd=dict[@"priceTo"];
            _areaBegin=dict[@"areaFrom"];
            _areaEnd=dict[@"areaTo"];
            if([dict[@"target"] isEqualToString:@"0"]){
                [_data addObject:@"所有经纪人"];
            }else{
                [_data addObject:@"朋友"];
            }
            if ([dict[@"regionId"] isKindOfClass:[NSNull class]]) {
                [_data addObject:@"不限"];
            }else{
                if([dict[@"regionId"] isEqualToString:@"0"]){
                    [_data addObject:@"不限"];
                }else{
                    [_data addObject:[Address addressWithRegionId:dict[@"regionId"]]];
                }
            }
            if ([dict[@"areaFrom"] isKindOfClass:[NSNull class]]&&[dict[@"areaTo"] isKindOfClass:[NSNull class]]) {
                [_data addObject:@"不限"];
            }else{
                if ([dict[@"areaFrom"] isEqualToString:@"0"]&&[dict[@"areaTo"] isEqualToString:@"0"]) {
                    [_data addObject:@"不限"];
                }else{
                    [_data addObject:[NSString stringWithFormat:@"%@-%@平米",dict[@"areaFrom"],dict[@"areaTo"]]];
                }
            }
            if ([dict[@"priceTo"] isEqualToString:@"0"]&&[dict[@"priceFrom"] isEqualToString:@"0"]) {
                [_data addObject:@"不限"];
            }else{
                
                if ([dict[@"tradeType"] isEqualToString:@"1"]) {
                    [_data addObject:[NSString stringWithFormat:@"%@-%@万",dict[@"priceFrom"],dict[@"priceTo"]]];
                }else if ([dict[@"tradeType"] isEqualToString:@"2"]){
                    [_data addObject:[NSString stringWithFormat:@"%@-%@元/月",dict[@"priceFrom"],dict[@"priceTo"]]];
                }
            }
            
            [_tableView reloadData];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

- (IBAction)subscibeList:(id)sender{
    XSSubscibeListViewController *list=[[UIStoryboard storyboardWithName:@"Subscibe" bundle:nil]instantiateViewControllerWithIdentifier:@"XSSubscibeListViewController"];
    list.houseType=_type;
    [self.navigationController pushViewController:list animated:YES];
}


@end
