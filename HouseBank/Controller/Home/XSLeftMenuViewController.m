//
//  XSLeftMenuViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14/11/24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSLeftMenuViewController.h"
#import "PinYin4Objc.h"
#import "CityBean.h"
#import "UIViewController+ECSlidingViewController.h"
#import "NSString+Helper.h"
#import "BMapKit.h"
#import "MBProgressHUD+Add.h"

@interface XSLeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_location;
    BMKGeoCodeSearch* _searcher;//反地理位置编码
}
@property (weak, nonatomic) IBOutlet UILabel *currentsCity;
@property (weak, nonatomic) IBOutlet UITableView *hotCity;
@property (weak, nonatomic) IBOutlet UITableView *otherCity;
@property(nonatomic,strong)NSArray *hotCityData;
@property(nonatomic,strong)NSMutableArray *otherCityData;
@property(nonatomic,strong)NSArray *keys;
@property (weak, nonatomic) IBOutlet UIButton *locationCityButton;

@end

@implementation XSLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_locationCityButton setTitle:DefaultCity forState:UIControlStateNormal];
    _hotCityData=[NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HotCity" withExtension:@"plist"]];
    _otherCityData=[NSMutableArray array];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *city=[user objectForKey:KLocationCityName];
    _currentsCity.text=city;
    [self setupCity];
    [self getLocationInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupCity) name:KChangeCityNotification object:nil];
}
#pragma mark - 初始化城市列表数据
-(void)setupCity{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    __block NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    NSArray *allcity=[Address allCity];
    [allcity enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Address *address=obj;
        
        NSString *pinYin=address.pinyin;
        NSMutableArray *data=[NSMutableArray array];
        if (dict[[pinYin substringToIndex:1]]) {
            [data addObjectsFromArray:dict[[pinYin substringToIndex:1]]];
        }
        
        [data addObject:[[CityBean alloc]initwithAddress:address]];
        [dict setObject:data forKey:[pinYin substringToIndex:1]];
    }];
    _keys=[[dict allKeys]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    [_keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_otherCityData addObject:[dict objectForKey:obj]];
    }];
    
    [_otherCity reloadData];
    
}
#pragma mark - table view delegate and data sources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_otherCity==tableView) {
        return _otherCityData.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hotCity==tableView) {
        return _hotCityData.count;
    }
    return [_otherCityData[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 26.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_otherCity==tableView) {
        return 20;
    }
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSLeftMenuViewController"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XSLeftMenuViewController"];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14.f];
        cell.textLabel.textColor=[UIColor whiteColor];
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor clearColor];
        cell.backgroundView=view;
    }
    if (_hotCity==tableView) {
        cell.textLabel.text=_hotCityData[indexPath.row];
    }else{
        CityBean *city=_otherCityData[indexPath.section][indexPath.row];
        cell.textLabel.text=city.name;
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_otherCity==tableView) {
        return _keys[section];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_otherCity==tableView){
        CityBean *city=_otherCityData[indexPath.section][indexPath.row];
        _currentsCity.text=city.name;
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:city.name forKey:KLocationCityName];
        [user setObject:city.cityid forKey:KLocationCityId];
        [user synchronize];
        [self.slidingViewController resetTopViewAnimated:YES onComplete:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:KChangeCityNotification object:nil];
    }else{
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        
        _currentsCity.text=cell.textLabel.text;
        if (indexPath.row==0) {
            
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:@"全国" forKey:KLocationCityName];
            [user setObject:@"0" forKey:KLocationCityId];
            [user synchronize];
            [self.slidingViewController resetTopViewAnimated:YES onComplete:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:KChangeCityNotification object:nil];
        }else{
            NSString *cityid=[Address addressIdWithCityName:_hotCityData[indexPath.row]];
            if(cityid.length==2){//直辖市
                cityid=[NSString stringWithFormat:@"%@01",cityid];
            }
            
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:_hotCityData[indexPath.row] forKey:KLocationCityName];
            [user setObject:cityid forKey:KLocationCityId];
            [user synchronize];
            [self.slidingViewController resetTopViewAnimated:YES onComplete:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:KChangeCityNotification object:nil];
        }
    }
    
}
- (IBAction)clickLocationCity:(UIButton *)sender
{
    NSString *cityid=[Address addressIdWithCityName:[sender titleForState:UIControlStateNormal]];
    if ([cityid isEmptyString]) {
        [MBProgressHUD showMessag:@"该城市尚未开通，请选择其他城市!" toView:[KAPPDelegate window]];
        return;
    }
    if(cityid.length==2){//直辖市
        cityid=[NSString stringWithFormat:@"%@01",cityid];
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[sender titleForState:UIControlStateNormal] forKey:KLocationCityName];
    [user setObject:cityid forKey:KLocationCityId];
    [user synchronize];
    _currentsCity.text=[sender titleForState:UIControlStateNormal];
    [self.slidingViewController resetTopViewAnimated:YES onComplete:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChangeCityNotification object:nil];
}
#pragma mark - 定位服务
- (void)getLocationInfo
{
#ifndef iOS8
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined&&[[UIDevice currentDevice].systemVersion floatValue]>=8.0){//ios8最新定位操作必须介样,
        
        _manager=[[CLLocationManager alloc]init];
        [_manager requestAlwaysAuthorization];
    }
#endif
    if (_location==nil) {
        _location=[[BMKLocationService alloc]init];
        _location.delegate=self;
    }
    [_location startUserLocationService];
}

#pragma mark - 地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSString *city=result.addressDetail.city ;
    city=[city stringByReplacingOccurrencesOfString:@"市" withString:@""] ;
    [_locationCityButton setTitle:city forState:UIControlStateNormal];
}

#pragma mark - 定位成功
-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    [_location stopUserLocationService];
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
}

#pragma mark - 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@",error);
}

@end
