//
//  SystemContactsViewController.m
//  HouseBank
//
//  Created by CSC on 15/1/3.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "SystemContactsViewController.h"
#import "SelectABCView.h"
#import "DeviceUtil.h"
#import "SystemContactTableViewCell.h"
#import "ViewUtil.h"
#import "PinyinHelper.h"
#import "HanyuPinyinOutputFormat.h"
#import "AddressBookWsImpl.h"
#import "FYUserDao.h"
#import "WaitingView.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"

@interface SystemContactsViewController ()<UITableViewDataSource,UITableViewDelegate,SelectABCViewDelegation>{
    UILabel *_abcLabel;
    
    NSMutableDictionary *_contacts ;
    NSMutableArray *_contactKeys ;
    NSInteger _contactCount ;
}
@property (weak, nonatomic) IBOutlet SelectABCView *abcView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)importTapped:(id)sender;

-(void) initialize ;
-(void) initializeParams ;

@end

@implementation SystemContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self initializeParams];
}

- (IBAction)importTapped:(id)sender {
    NSArray *indexPaths = [_tableView indexPathsForSelectedRows];
    __block int count = indexPaths.count;
    
    __block WaitingView *waittingView = [WaitingView defaultView];
    __block int successCount = 0;
    __block int errorCount = 0;
    if (count) {
        [waittingView showWaitingViewWithHintTextInView:[AppDelegate shareApp].window hintText:@"正在提交数据..."];
    }
    
    for (NSIndexPath *indexPath in indexPaths) {
        
        NSArray *array = _contacts[_contactKeys[indexPath.section]];
        NSDictionary *dict = array[indexPath.row];
        
        FYUserDao *dao = [FYUserDao new];
        NSString *sid = [dao user].sid;
        
        NSString *phone = @"";
        NSArray *phones = dict[@"phones"];
        if (phones && phones.count) {
            phone = phones[0];
        }
        
        AddressBookWsImpl *ws = [AddressBookWsImpl new] ;
        [ws addContact:sid name:dict[@"name"] nickName:dict[@"nickName"] mobilePhone:phone telPhone:@"" email:@"" qq:@"" weixin:@"" industry:@"" company:dict[@"company"] position:@"" birthday:@"" memorialDay:@"" importantLevel:[NSString stringWithFormat:@"%d",VIP] sourceId:@"0" memo:@"" address:@"" linkType:@"0" result:^(BOOL isSuccess, id result, NSString *data) {
            
            count-- ;
            if ([@"0" isEqualToString:data]) {
                successCount ++;
            }else{
                errorCount ++;
            }
            if (count == 0) {
                [MBProgressHUD showMessag:[NSString stringWithFormat:@"成功提交 %d 条，失败 %d 条",successCount,errorCount] toView:[AppDelegate shareApp].window];
                [self.navigationController popViewControllerAnimated:YES];
                [waittingView dismissWatingView];
            }
        }];
    }
}

-(void) initialize{
    self.navigationItem.title = @"导入手机通讯录";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _abcView.delegate = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect(0, 0, 50, 50)];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    label.font = [UIFont systemFontOfSize:45];
    
    label.center = self.view.center;
    label.hidden = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _abcLabel = label;
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
}

-(void) initializeParams{
    NSArray *array = [DeviceUtil allContact] ;
    
    _contacts = [NSMutableDictionary new];
    _contactKeys = [NSMutableArray new];
    
    HanyuPinyinOutputFormat *format = [HanyuPinyinOutputFormat new];
    
    /// 判断用户是否打开了通讯录
    if (array.count == 0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查“设置->合发房银->通讯录”是否开启" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *pinyin = [[PinyinHelper toHanyuPinyinStringWithNSString:obj[@"name"] withHanyuPinyinOutputFormat:format withNSString:@"-"] capitalizedString];
        
        NSInteger count = pinyin.length;
        NSString *key = @"#";
        if (count > 0) {
            key = [pinyin substringToIndex:1];
        }
        
        if (![_contacts objectForKey:key]) {
            NSMutableArray *array = [NSMutableArray new];
            [array addObject:obj];
            [_contactKeys addObject:key];
            [_contacts setObject:array forKey:key];
        }else{
            NSMutableArray *array = [_contacts objectForKey:key];
            [array addObject:obj];
        }
    }];
    
    
    NSComparator cmptr = ^(id obj1, id obj2){
        return [obj1 compare:obj2];
    };
    
    [_contactKeys sortUsingComparator:cmptr];
    
    NSComparator cmpt = ^(id obj1, id obj2){
        return [obj1[@"name"] compare:obj2[@"name"]];
    };
    
    for (NSString *key in _contactKeys) {
        NSMutableArray *array = [_contacts objectForKey:key];
        [array sortUsingComparator:cmpt];
    }
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _contactKeys.count ;
};

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _contactKeys[section] ;
};

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![tableView isEditing]) {
        [tableView setEditing:YES animated:YES];
    }
    return indexPath;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _contacts[_contactKeys[section]];
    return array.count ;
};

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ;
    if (!cell) {
        cell = (SystemContactTableViewCell *)[ViewUtil xibView:@"SystemContactTableViewCell"] ;
    }
    
    NSArray *array = _contacts[_contactKeys[indexPath.section]];
    [cell refresh:array[indexPath.row]];
    
    return cell ;
};

-(void) didSelect : (SelectABCView *) view abcStr : (NSString *) abcStr{
    _abcLabel.text = abcStr;
    _abcLabel.hidden = NO;
    
    if ([@"#" isEqualToString:abcStr]) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        for (int i = 0; i<_contactKeys.count;i++ ) {
            NSString *key = _contactKeys[i];
            if ([key isEqualToString:abcStr]) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                break;
            }
        }
    }
};

-(void) cancel:(SelectABCView *)view{
    _abcLabel.hidden = YES;
}

@end
