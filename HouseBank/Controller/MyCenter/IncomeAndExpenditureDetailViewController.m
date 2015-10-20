//
//  IncomeAndExpenditureDetailViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 3/7/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "IncomeAndExpenditureDetailViewController.h"
#import "MyCenterWsImpl.h"
#import "Tool.h"
#import "MBProgressHUD+Add.h"
#import "KGStatusBar.h"
#import "FYUserDao.h"
#import "UserBean.h"

static CGFloat const yOriginOfHeaderView = 65.0;
static CGFloat const heightOriginOfHeaderView = 100.0;

static CGFloat const xOriginOfDetailTableView = 0;
static CGFloat const xOriginOfReportTableView = 320 * 1;
static CGFloat const xOriginOfWithDrawTabelView = 320 * 2;

@interface IncomeAndExpenditureDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *array_xib;
@property (strong, nonatomic) NSArray *array_detail;
@property (strong, nonatomic) NSArray *array_income;
@property (strong, nonatomic) NSArray *array_withdraw;

@property (strong, nonatomic) UIView *view_header;
@property (strong, nonatomic) UIView *view_withdraw;
@property (strong, nonatomic) UIScrollView *scrollView_selection;
@property (strong, nonatomic) UITableView *tableView_detail;
@property (strong, nonatomic) UITableView *tableView_report;
@property (strong, nonatomic) UITableView *tableView_withdraw;

@property (strong, nonatomic) UISegmentedControl *segmentedControl_selection;

@end

@implementation IncomeAndExpenditureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.array_xib = [[NSBundle mainBundle]loadNibNamed:@"DistributionReportView" owner:nil options:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"收支明细";
    
    [self setupHeaderView];
    [self setupScrollView];

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
    switch (tableView.tag) {
        case DETAILREPORT:
            return self.array_detail.count;
            break;
        case INCOMEREPORT:
            return self.array_income.count;
            break;
        case WITHDRAWREPORT:
            return self.array_withdraw.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view_temp;
    switch (tableView.tag) {
        case DETAILREPORT:
            view_temp = self.array_xib[3];
            break;
        case INCOMEREPORT:
            view_temp = self.array_xib[5];
            break;
        case WITHDRAWREPORT:
            view_temp = self.array_xib[7];
            break;
        default:
            view_temp = nil;
            break;
    }
    return view_temp;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case WITHDRAWREPORT:
            return self.view_withdraw.frame.size.height;
        default:
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (tableView.tag) {
        case WITHDRAWREPORT:
            return self.view_withdraw;
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *array_xib = [[NSBundle mainBundle]loadNibNamed:@"DistributionReportView" owner:nil options:nil];
    if(cell == nil){
        switch (tableView.tag) {
            case DETAILREPORT:
                cell = array_xib[4];
                break;
            case INCOMEREPORT:
                cell = array_xib[6];
                break;
            case WITHDRAWREPORT:
                cell = array_xib[8];
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic_temp;
    switch(tableView.tag){
        case DETAILREPORT:{
            dic_temp = self.array_detail[indexPath.row];
            UILabel *lb_date = (UILabel *)[cell viewWithTag:900001];
            UILabel *lb_remark = (UILabel *)[cell viewWithTag:900002];
            UILabel *lb_amount = (UILabel *)[cell viewWithTag:900003];
            UILabel *lb_balance = (UILabel *)[cell viewWithTag:900004];
            
            lb_date.text = [Tool getDateStringWithDate:[[dic_temp objectForKey:DETAILREPORTDATE] longLongValue]];
            int type = [[dic_temp objectForKey:DETAILREPORTREMARK] integerValue];
            NSString *string_temp;
            switch (type) {
                case 1:
                    string_temp = @"分销收入";
                    break;
                case 2:
                    string_temp = @"提现";
                    break;
                case 3:
                    string_temp = @"推荐注册";
                    break;
                case 4:
                    string_temp = @"购买商品";
                    break;
                case 5:
                    string_temp = @"充值";
                    break;
                default:
                    string_temp = @"未知";
                    break;
            }
            lb_remark.text = string_temp;
            lb_amount.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:DETAILREPORTAMOUNT] doubleValue]];
            lb_balance.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:DETAILREPORTBALANCE] doubleValue]];
        }
            break;
        case INCOMEREPORT:{
            dic_temp = self.array_income[indexPath.row];
            UILabel *lb_date = (UILabel *)[cell viewWithTag:900001];
            UILabel *lb_character = (UILabel *)[cell viewWithTag:900002];
            UILabel *lb_amount = (UILabel *)[cell viewWithTag:900003];
            UILabel *lb_source = (UILabel *)[cell viewWithTag:900004];
            UILabel *lb_income = (UILabel *)[cell viewWithTag:900005];
            
            lb_date.text = [Tool getDateStringWithDate:[[dic_temp objectForKey:INCOMEREPORTDATE] longLongValue]];
            int character = [[dic_temp objectForKey:INCOMEREPORTTYPE] integerValue];
            lb_character.text = [Tool getUserCharacterWithInt:character];
            lb_amount.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:INCOMEREPORTAMOUT] doubleValue]];
            int source = [[dic_temp objectForKey:INCOMEREPORTTYPE] integerValue];
            NSString *string_temp;
            if(source >= 3){
                string_temp = [NSString stringWithFormat:@"第%d级推广", source - 2];
            }else {
                switch (source) {
                    case 1:
                        string_temp = @"直接推荐";
                        break;
                    case 2:
                        string_temp = @"间接推荐";
                        break;
                    default:
                        string_temp = @"未知";
                        break;
                }
            }
            lb_source.text = string_temp;
            lb_income.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:INCOMEREPORTINCOME] doubleValue]];
        }
            break;
        case WITHDRAWREPORT:{
            dic_temp = self.array_withdraw[indexPath.row];
            UILabel *lb_date = (UILabel *)[cell viewWithTag:900001];
            UILabel *lb_amount = (UILabel *)[cell viewWithTag:900002];
            UILabel *lb_fee = (UILabel *)[cell viewWithTag:900003];
            UILabel *lb_status = (UILabel *)[cell viewWithTag:900004];
            
            lb_date.text = [Tool getDateStringWithDate:[[dic_temp objectForKey:WITHDRAWREPORTDATE] longLongValue]];
            lb_amount.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:WITHDRAWREPORTAMOUNT] doubleValue]];
            lb_fee.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:WITHDRAWREPORTFEE] doubleValue]];
            int status = [[dic_temp objectForKey:WITHDRAWREPORTSTATUS] integerValue];
            NSString *string_temp;
            switch (status) {
                case 1:
                    string_temp = @"待审核";
                    break;
                case 2:
                    string_temp = @"支付失败";
                    break;
                case 0:
                    string_temp = @"提现成功";
                    break;
                default:
                    string_temp = @"未知";
                    break;
            }
            lb_status.text = string_temp;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - event response
- (void)didSegmentedControlValueChanged:(id)sender{
    UISegmentedControl *segmentedControl_temp = (UISegmentedControl *)sender;
    switch(segmentedControl_temp.selectedSegmentIndex){
        case 0:
            [self.scrollView_selection setContentOffset:CGPointMake(xOriginOfDetailTableView, 0) animated:YES];
            break;
        case 1:
            [self.scrollView_selection setContentOffset:CGPointMake(xOriginOfReportTableView, 0) animated:YES];
            break;
        case 2:
            [self.scrollView_selection setContentOffset:CGPointMake(xOriginOfWithDrawTabelView, 0) animated:YES];
            break;
    }
    [self requestUserInfo];
}

- (void)requestUserInfo{
    [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES];
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    
    [ws requestDetailWithUrl:[NSString stringWithFormat:@"%@gain/gaininfo", KUrlConfig] andSid:user.sid andLevel:1 andTab:(self.segmentedControl_selection.selectedSegmentIndex + 1) andPageNo:0 andPageSize:0 andResult:^(BOOL isSucceeded, id result, NSString *data){
        
        NSLog(@"%s || data:%@", __FUNCTION__, data);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic_temp = (NSDictionary *)result;
            if(dic_temp != nil){
                if([[dic_temp objectForKey:LISTCOUNT] integerValue] == 0){
                    [KGStatusBar showWithStatus:@"没有数据。"];
                }else{
                    [self setupDataWithDictionary:@{INCOME: [dic_temp objectForKey:INCOME], EXPENDITURE: [dic_temp objectForKey:EXPENDITURE], WITHDRAW: [dic_temp objectForKey:WITHDRAW], FEE: [dic_temp objectForKey:FEE]}];
                    switch (self.segmentedControl_selection.selectedSegmentIndex + 800001) {
                        case DETAILREPORT:
                            self.array_detail = [NSArray arrayWithArray:[dic_temp objectForKey:DETAILREPORTLIST]];
                            [self.tableView_detail reloadData];
                            break;
                        case INCOMEREPORT:
                            self.array_income = [NSArray arrayWithArray:[dic_temp objectForKey:INCOMEREPORTLIST]];
                            [self.tableView_report reloadData];
                            break;
                        case WITHDRAWREPORT:
                            self.array_withdraw = [NSArray arrayWithArray:[dic_temp objectForKey:WITHDRAWREPORTLIST]];
                            [self.tableView_withdraw reloadData];
                            break;
                        default:
                            break;
                    }
                }
            }
        }else{
            [KGStatusBar showErrorWithStatus:@"数据请求失败。"] ;
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
    }];
    
}

#pragma mark - custom
- (void)setupHeaderView{
    [self.view addSubview:self.view_header];
    [self.segmentedControl_selection setSelectedSegmentIndex:0];
    [self didSegmentedControlValueChanged:self.segmentedControl_selection];
    
    [self setupDataWithDictionary:@{INCOME: @"0.00", EXPENDITURE: @"0.00", WITHDRAW: @"0.00", FEE: @"0.00"}];
}

- (void)setupScrollView{
    [self.view addSubview:self.scrollView_selection];
    
    [self.scrollView_selection addSubview:self.tableView_detail];
    [self.scrollView_selection addSubview:self.tableView_report];
    [self.scrollView_selection addSubview:self.tableView_withdraw];
    
    self.tableView_detail.delegate = self;
    self.tableView_detail.dataSource = self;
    self.tableView_detail.tag = DETAILREPORT;
    self.tableView_report.delegate = self;
    self.tableView_report.dataSource = self;
    self.tableView_report.tag = INCOMEREPORT;
    self.tableView_withdraw.delegate = self;
    self.tableView_withdraw.dataSource = self;
    self.tableView_withdraw.tag = WITHDRAWREPORT;
}

- (void)setupDataWithDictionary:(NSDictionary *)dic{
    UILabel *lb_totalIncome = (UILabel *)[self.view_header viewWithTag:900001];
    UILabel *lb_totalExpenditure = (UILabel *)[self.view_header viewWithTag:900002];
    
    UILabel *lb_totalWithdraw = (UILabel *)[self.view_withdraw viewWithTag:900001];
    UILabel *lb_totalFee = (UILabel *)[self.view_withdraw viewWithTag:900002];
    
    lb_totalIncome.text = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:INCOME] doubleValue]];
    lb_totalExpenditure.text = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:EXPENDITURE] doubleValue]];
    
    lb_totalWithdraw.text = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:WITHDRAW] doubleValue]];
    lb_totalFee.text = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:FEE] doubleValue]];
}

#pragma mark - getter/setter
- (NSArray *)array_xib{
    if(_array_xib == nil){
        
    }
    return _array_xib;
}

- (NSArray *)array_detail{
    if(_array_detail == nil){
        _array_detail = [NSArray array];
    }
    return _array_detail;
}

- (NSArray *)array_income{
    if(_array_income == nil){
        _array_income = [NSArray array];
    }
    return _array_income;
}

- (NSArray *)array_withdraw{
    if(_array_withdraw == nil){
        _array_withdraw = [NSArray array];
    }
    return _array_withdraw;
}
- (UIView *)view_header{
    if(_view_header == nil){
        _view_header = self.array_xib[2];
        [_view_header setFrame:CGRectMake(0, yOriginOfHeaderView, 320, heightOriginOfHeaderView)];
    }
    return _view_header;
}

- (UIView *)view_withdraw{
    if(_view_withdraw == nil){
        _view_withdraw = self.array_xib[9];
    }
    return _view_withdraw;
}

- (UIScrollView *)scrollView_selection{
    if(_scrollView_selection == nil){
        _scrollView_selection = [[UIScrollView alloc]initWithFrame:CGRectMake(0, yOriginOfHeaderView + self.view_header.frame.size.height, 320 * 3, self.view.frame.size.height - CGRectGetMaxY(self.view_header.frame))];
        [_scrollView_selection setPagingEnabled:YES];
//        [_scrollView_selection setContentSize:CGSizeMake(_scrollView_selection.frame.size.width, _scrollView_selection.frame.size.height)];
        [_scrollView_selection setScrollEnabled:NO];
    }
    return _scrollView_selection;
}

- (UITableView *)tableView_detail{
    if(_tableView_detail == nil){
        _tableView_detail = [[UITableView alloc]initWithFrame:CGRectMake(xOriginOfDetailTableView, 0, 320, self.scrollView_selection.frame.size.height) style:UITableViewStylePlain];
//        _tableView_detail.backgroundColor = [UIColor greenColor];
        _tableView_detail.tableFooterView = [[UIView alloc]init];
        _tableView_detail.tag = DETAILREPORT;
    }
    return _tableView_detail;
}

- (UITableView *)tableView_report{
    if(_tableView_report == nil){
        _tableView_report = [[UITableView alloc]initWithFrame:CGRectMake(xOriginOfReportTableView, 0, 320, self.scrollView_selection.frame.size.height) style:UITableViewStylePlain];
//        _tableView_report.backgroundColor = [UIColor redColor];
        _tableView_report.tableFooterView = [[UIView alloc]init];
        _tableView_report.tag = INCOMEREPORT;
    }
    return _tableView_report;
}

- (UITableView *)tableView_withdraw{
    if(_tableView_withdraw == nil){
        _tableView_withdraw = [[UITableView alloc]initWithFrame:CGRectMake(xOriginOfWithDrawTabelView, 0, 320, self.scrollView_selection.frame.size.height) style:UITableViewStylePlain];
//        _tableView_withdraw.backgroundColor = [UIColor blueColor];
//        _tableView_withdraw.tableFooterView = self.view_withdraw;
        _tableView_withdraw.tableFooterView = [[UIView alloc]init];
        _tableView_withdraw.tag = WITHDRAWREPORT;
    }
    return _tableView_withdraw;
}

- (UISegmentedControl *)segmentedControl_selection{
    if(_segmentedControl_selection == nil){
        _segmentedControl_selection = (UISegmentedControl *)[self.view_header viewWithTag:700001];
        [_segmentedControl_selection addTarget:self action:@selector(didSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl_selection;
}

@end
