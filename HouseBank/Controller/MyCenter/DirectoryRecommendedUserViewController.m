//
//  DirectoryRecommendedUserViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 2/7/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "DirectoryRecommendedUserViewController.h"
#import "MyCenterWsImpl.h"
#import "MBProgressHUD+Add.h"
#import "FYUserDao.h"
#import "UserBean.h"
#import "KGStatusBar.h"
#import "Tool.h"

static CGFloat const heightOfSelectionView = 40.0;
static CGFloat const yOriginOfSelectionView = 65.0;

static CGFloat const widthOfSelectionMarker = (320 / 2);
static CGFloat const heightOfSelectionMarker = 3.0;
static CGFloat const yOriginOfSelectionMarker = 37.0;
static CGFloat const xOriginOfDirectory = 0;
static CGFloat const xOriginOfIndirectory = (320 / 2);

static CGFloat const widthOfSelectionButton = (320 / 2);
static CGFloat const heightOfSelectionButton = 37.0;
static CGFloat const yOriginOfSelectionButton = 0;

static CGFloat const xOriginOfDirectoryTableView = 0;
static CGFloat const xOriginOfIndirectoryTableView = 320;

@interface DirectoryRecommendedUserViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *selectionView_top;
@property (strong, nonatomic) UITableView *tableView_directory;
@property (strong, nonatomic) UITableView *tableView_indirectory;
@property (strong, nonatomic) UIScrollView *scrollView_selection;

@property (strong, nonatomic) UILabel *lb_marker;

@property (strong, nonatomic) UIButton *btn_directory;
@property (strong, nonatomic) UIButton *btn_indirectory;

@property (strong, nonatomic) NSArray *array_directory;
@property (strong, nonatomic) NSArray *array_inDirecory;

@end

@implementation DirectoryRecommendedUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:self.selectionView_top];
    [self.view addSubview:self.scrollView_selection];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"我推荐的人";
    
    [self setupTopView];
    [self setupScrollView];
    
    [self requestUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == DIRECTORY){
        return self.array_directory.count;
    } else if(tableView.tag == INDIRECTORY){
        return self.array_inDirecory.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedCell"];
    if(cell == nil){
        NSArray *array_xib = [[NSBundle mainBundle]loadNibNamed:@"DistributionReportView" owner:nil options:nil];
        cell = array_xib[1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSArray *array_temp;
    if(tableView.tag == DIRECTORY){
        array_temp = self.array_directory;
    }else if(tableView.tag == INDIRECTORY){
        array_temp = self.array_inDirecory;
    }
    
    UILabel *lb_name = (UILabel *)[cell viewWithTag:900001];
    UILabel *lb_phone = (UILabel *)[cell viewWithTag:900002];
    UILabel *lb_character = (UILabel *)[cell viewWithTag:900003];
    UILabel *lb_type = (UILabel *)[cell viewWithTag:900004];
    UILabel *lb_date = (UILabel *)[cell viewWithTag:900005];
    UILabel *lb_amount = (UILabel *)[cell viewWithTag:900006];
    UILabel *lb_income = (UILabel *)[cell viewWithTag:900007];
    
    if(array_temp > 0){
        NSDictionary *dic_temp = array_temp[indexPath.row];
        lb_name.text = [dic_temp objectForKey:RECOMMENDEDNAME];
        lb_phone.text = [dic_temp objectForKey:RECOMMENDEDPHONE];
        
        int character = [[dic_temp objectForKey:RECOMMENDEDCHARACTER] intValue];
        lb_character.text = [Tool getUserCharacterWithInt:character];
        
        int type = [[dic_temp objectForKey:RECOMMENDEDTYPE] intValue];
        lb_type.text = [Tool getUserCharacterWithInt:type];
        
        lb_date.text = [Tool getDateStringWithDate:[[dic_temp objectForKey:RECOMMENDEDDATE]longLongValue]];
        lb_amount.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:RECOMMENDEDAMOUT] doubleValue]];
        lb_income.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:RECOMMENDEDINCOME] doubleValue]];
//        NSLog(@"%s || data in array:%@, data of indexPath:%@", __FUNCTION__, dic_temp, indexPath);
    }else{
        lb_name.text = @"未知";
        lb_phone.text = @"13000000000";
        lb_character.text = @"未知角色";
        lb_type.text = @"未知角色";
        lb_date.text = @"1970-01-01 00:00:00";
        lb_amount.text = @"0.00";
        lb_income.text = @"0.00";
    }
    return cell;
}

#pragma mark - event reponse
- (void)didSelectionValueChanged:(id)sender{
    if([sender isKindOfClass:[UIButton class]]){
        UIButton *btn_temp = (UIButton *)sender;
        if(self.currentChosen != btn_temp.tag){
            self.currentChosen = btn_temp.tag;
            [UIView animateWithDuration:0.15f animations:^(void){
                [self.lb_marker setFrame:CGRectMake(btn_temp.frame.origin.x, self.lb_marker.frame.origin.y, self.lb_marker.frame.size.width, self.lb_marker.frame.size.height)];
                [self requestUserInfo];
            }completion:^(BOOL finished){
                [btn_temp setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                if(self.btn_directory.tag != btn_temp.tag){
                    [self.btn_directory setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.scrollView_selection setContentOffset:CGPointMake(xOriginOfIndirectoryTableView, 0) animated:YES];
                }else if(self.btn_indirectory.tag != btn_temp.tag){
                    [self.btn_indirectory setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.scrollView_selection setContentOffset:CGPointMake(xOriginOfDirectoryTableView, 0) animated:YES];
                }
                
            }];
        }
    }
}

#pragma mark - custom

- (void)requestUserInfo{
    [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES];
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];

    [ws requestReportsWithUrl:[NSString stringWithFormat:@"%@gain/userinfo", KUrlConfig] andSid:user.sid andLevel:(self.currentChosen - 800000) andPageNo:0 andPageSize:0 andResult:^(BOOL isSucceeded, id result, NSString *data){
        
        NSLog(@"%s || data:%@", __FUNCTION__, data);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic_temp = (NSDictionary *)result;
            if(dic_temp != nil){
                if([[dic_temp objectForKey:LISTCOUNT] integerValue] == 0){
                    [KGStatusBar showWithStatus:@"没有推荐人。"];
                }else{
                    switch (self.currentChosen) {
                        case DIRECTORY:
                            self.array_directory = [NSArray arrayWithArray:[dic_temp objectForKey:RECOMMENDLIST]];
                            break;
                        case INDIRECTORY:
                            self.array_inDirecory = [NSArray arrayWithArray:[dic_temp objectForKey:RECOMMENDLIST]];
                            break;
                        default:
                            break;
                    }
                }
            }
            [self setupData];
            
        }else{
            [KGStatusBar showErrorWithStatus:@"数据请求失败。"] ;
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
    }];
    
}

- (void)setupTopView{
    [self.selectionView_top addSubview:self.btn_directory];
    [self.selectionView_top addSubview:self.btn_indirectory];
    [self.selectionView_top addSubview:self.lb_marker];
}

- (void)setupData{
    switch (self.currentChosen) {
        case DIRECTORY:
            [self.tableView_directory reloadData];
            break;
        case INDIRECTORY:
            [self.tableView_indirectory reloadData];
            break;
        default:
            break;
    }
}

- (void)setupScrollView{
    [self.scrollView_selection addSubview:self.tableView_directory];
    self.tableView_directory.delegate = self;
    self.tableView_directory.dataSource = self;
    self.tableView_directory.tag = DIRECTORY;
    [self.scrollView_selection addSubview:self.tableView_indirectory];
    self.tableView_indirectory.delegate = self;
    self.tableView_indirectory.dataSource = self;
    self.tableView_indirectory.tag = INDIRECTORY;
}

#pragma mark - getter/setter
- (UIView *)selectionView_top{
    if(_selectionView_top == nil){
        _selectionView_top = [[UIView alloc]initWithFrame:CGRectMake(0, yOriginOfSelectionView, 320, heightOfSelectionView)];
        _selectionView_top.backgroundColor = [UIColor whiteColor];
    }
    return _selectionView_top;
}

- (UIScrollView *)scrollView_selection{
    if(_scrollView_selection == nil){
        _scrollView_selection = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.selectionView_top.frame.origin.y + heightOfSelectionView + 5, self.view.frame.size.width * 2, self.view.frame.size.height - (self.selectionView_top.frame.origin.y + heightOfSelectionView + 5))];
        [_scrollView_selection setScrollEnabled:NO];
        [_scrollView_selection setPagingEnabled:YES];
        if(self.currentChosen == INDIRECTORY){
            [_scrollView_selection setContentOffset:CGPointMake(xOriginOfIndirectoryTableView, 0)];
        }
    }
    return _scrollView_selection;
}

- (UITableView *)tableView_directory{
    if(_tableView_directory == nil){
        _tableView_directory = [[UITableView alloc]initWithFrame:CGRectMake(xOriginOfDirectoryTableView, 0, self.view.frame.size.width, self.scrollView_selection.frame.size.height) style:UITableViewStylePlain];
//        _tableView_directory.backgroundColor = [UIColor redColor];
        _tableView_directory.tableFooterView = [[UIView alloc]init];
        _tableView_directory.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView_directory;
}

- (UITableView *)tableView_indirectory{
    if(_tableView_indirectory == nil){
        _tableView_indirectory = [[UITableView alloc]initWithFrame:CGRectMake(xOriginOfIndirectoryTableView, 0, self.view.frame.size.width, self.scrollView_selection.frame.size.height) style:UITableViewStylePlain];
//        _tableView_indirectory.backgroundColor = [UIColor blueColor];
        _tableView_indirectory.tableFooterView = [[UIView alloc]init];
        _tableView_indirectory.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView_indirectory;
}

- (UILabel *)lb_marker{
    if(_lb_marker == nil){
        _lb_marker = [[UILabel alloc]init];
        _lb_marker.backgroundColor = [UIColor orangeColor];
        CGFloat xPosition;
        if(self.currentChosen == DIRECTORY){
            xPosition = xOriginOfDirectory;
        }else{
            xPosition = xOriginOfIndirectory;
        }
        [_lb_marker setFrame:CGRectMake(xPosition, yOriginOfSelectionMarker, widthOfSelectionMarker, heightOfSelectionMarker)];
    }
    return _lb_marker;
}

- (UIButton *)btn_directory{
    if(_btn_directory == nil){
        _btn_directory = [[UIButton alloc]initWithFrame:CGRectMake(xOriginOfDirectory, yOriginOfSelectionButton, widthOfSelectionButton, heightOfSelectionButton)];
        [_btn_directory setTitle:@"我直接推荐的人" forState:UIControlStateNormal];
        if(self.currentChosen == DIRECTORY){
            [_btn_directory setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else{
            [_btn_directory setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        _btn_directory.tag = DIRECTORY;
        [_btn_directory addTarget:self action:@selector(didSelectionValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_directory;
}

- (UIButton *)btn_indirectory{
    if(_btn_indirectory == nil){
        _btn_indirectory = [[UIButton alloc]initWithFrame:CGRectMake(xOriginOfIndirectory, yOriginOfSelectionButton, widthOfSelectionButton, heightOfSelectionButton)];
        [_btn_indirectory setTitle:@"我间接推荐的人" forState:UIControlStateNormal];
        if(self.currentChosen == INDIRECTORY){
            [_btn_indirectory setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else{
            [_btn_indirectory setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        _btn_indirectory.tag = INDIRECTORY;
        [_btn_indirectory addTarget:self action:@selector(didSelectionValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_indirectory;
}

- (NSArray *)array_directory{
    if(_array_directory == nil){
        _array_directory = [[NSArray alloc]init];
    }
    return _array_directory;
}

- (NSArray *)array_inDirecory{
    if(_array_inDirecory == nil){
        _array_inDirecory = [[NSArray alloc]init];
    }
    return _array_inDirecory;
}

@end
