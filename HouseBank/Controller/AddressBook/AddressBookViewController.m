//
//  AddressBookViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookCellTableViewCell.h"
#import "AddressBookWsImpl.h"
#import "FYUserDao.h"
#import "MBProgressHUD+Add.h"
#import "PinyinHelper.h"
#import "HanyuPinyinOutputFormat.h"
#import "AddNewContactViewController.h"
#import "SelectABCView.h"
#import "SystemContactsViewController.h"
#import "ContactInfoViewController.h"

@interface AddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,SelectABCViewDelegation>{
    NSMutableDictionary *_contacts ;
    NSMutableArray *_contactKeys ;
    NSInteger _contactCount ;
    
    UILabel *_abcLabel ;
    
    AFHTTPRequestOperationManager *_ws ;
}

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet SelectABCView *selectABCView;

- (void) initialize ;
- (void) rightNaviBtnTapped : (id) sender;
- (void) requestDataFromServer;

- (IBAction)importBtnTapped:(id)sender;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    @autoreleasepool {
        [self initialize] ;
    }
}

-(void) initialize{
    UIButton *btn = [[UIButton alloc] initWithFrame:rect(10, 0, 40, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"index_denglu"] forState:UIControlStateNormal];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(rightNaviBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = item ;
    
    _addressTableView.dataSource = self ;
    _addressTableView.delegate = self ;
    
    _contactKeys = [NSMutableArray new];
    _contacts = [NSMutableDictionary new];
    
    _selectABCView.delegate = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect(0, 0, 50, 50)];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    label.font = [UIFont systemFontOfSize:45];
    
    label.center = self.view.center;
    label.hidden = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _abcLabel = label;
    
    _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestDataFromServer];
}

- (void) rightNaviBtnTapped:(id)sender{
    AddNewContactViewController *addVc = [AddNewContactViewController new];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (IBAction) importBtnTapped:(id)sender {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    
    SystemContactsViewController *vc = [SystemContactsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) requestDataFromServer{
    FYUserDao *dao = [FYUserDao new];
    NSString *sid = [dao user].sid;
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AddressBookWsImpl *ws = [AddressBookWsImpl new];
    _ws = [ws requestAddressBook:sid result:^(BOOL isSuccess, id result, NSString *data) {
        [mbp hide:YES];
        if (isSuccess && result) {
            [_contactKeys removeAllObjects];
            [_contacts removeAllObjects];
            
            HanyuPinyinOutputFormat *format = [HanyuPinyinOutputFormat new];
            
            NSArray *array = result[@"data"];
            
            _contactCount = array.count;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *pinyin = [[PinyinHelper toHanyuPinyinStringWithNSString:obj[@"name"] withHanyuPinyinOutputFormat:format withNSString:@""] capitalizedString];
                
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
            
            if (array.count > 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:rect(0, 0, 320, 25)];
                label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5   ];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [NSString stringWithFormat:@"共有%d位好友",array.count];
                _addressTableView.tableFooterView = label;
            }else{
                _addressTableView.tableFooterView = nil;
            }
            
            [_addressTableView reloadData];
        }else{
            [MBProgressHUD showNetErrorToView:self.view];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

- (void)dealloc{
    _ws = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _contactKeys.count ;
};

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _contactKeys[section] ;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _contacts[_contactKeys[section]];
    return array.count ;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ;
    if (!cell) {
        cell = (AddressBookCellTableViewCell *)[ViewUtil xibView:@"AddressBookCell"] ;
    }
    
    NSArray *array = _contacts[_contactKeys[indexPath.section]];
    [cell refresh:array[indexPath.row]];
    
    return cell ;
};

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = _contacts[_contactKeys[indexPath.section]];
    NSDictionary *dict = array[indexPath.row];
    
    ContactInfoViewController *vc = [ContactInfoViewController new];
    vc.contact = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) didSelect : (SelectABCView *) view abcStr : (NSString *) abcStr{
    _abcLabel.text = abcStr;
    _abcLabel.hidden = NO;
    
    if ([@"#" isEqualToString:abcStr]) {
        [_addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        for (int i = 0; i<_contactKeys.count;i++ ) {
            NSString *key = _contactKeys[i];
            if ([key isEqualToString:abcStr]) {
                [_addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                break;
            }
        }
    }
};

-(void) cancel:(SelectABCView *)view{
    _abcLabel.hidden = YES;
}

@end
