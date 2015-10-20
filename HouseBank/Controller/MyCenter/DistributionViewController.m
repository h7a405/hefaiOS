//
//  DistributionViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 5/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "DistributionViewController.h"
#import "MBProgressHUD+Add.h"
#import "MyCenterWsImpl.h"
#import "ResultCode.h"
#import "MBProgressHUD.h"
#import "WaitingView.h"
#import "KGStatusBar.h"
#import "FYUserDao.h"
#import "UserBean.h"
#import "DirectoryRecommendedUserViewController.h"
#import "IncomeAndExpenditureDetailViewController.h"

@interface DistributionViewController ()

@property (strong, nonatomic)UIView *headerView;

@property (strong, nonatomic) NSArray *array_xib;
//@property (strong, nonatomic) NSArray *array_userInfo;
@property (strong, nonatomic) NSArray *array_reportsInfo;

@property (strong, nonatomic) NSDictionary *dic_userInfo;

@end

@implementation DistributionViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"收入报表";
    [self setupLabelsWithDictionary:nil];
    [self setupButtonsWithTarget:YES];
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

#pragma mark - delegate method


#pragma mark - event reponse method
- (void)requestUserInfo{
    [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES];
    
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    MyCenterWsImpl *ws = [MyCenterWsImpl new];
    [ws requestUserReportWithUrl:[NSString stringWithFormat:@"%@gain/baseinfo", KUrlConfig] andSid:user.sid andResult:^(BOOL isSucceeded, id result, NSString *data){
        [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
        NSLog(@"%s || data:%@", __FUNCTION__, data);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic_temp = (NSDictionary *)result;
            if(dic_temp != nil){
                [self setupLabelsWithDictionary:dic_temp];
                [self setupButtonsWithTarget:YES];
            }
        }else{
            [KGStatusBar showErrorWithStatus:@"数据请求失败。"] ;
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)gotoIncomeAndExpenditureDetail{
    IncomeAndExpenditureDetailViewController *incomeAndExpendiureDetailVC = [[IncomeAndExpenditureDetailViewController alloc]init];
    [self.navigationController pushViewController:incomeAndExpendiureDetailVC animated:YES];
}
- (void)gotoDirectoryRecommendedCount{
    DirectoryRecommendedUserViewController *directoryRecomemndedUserVC = [[DirectoryRecommendedUserViewController alloc]init];
    directoryRecomemndedUserVC.isDirectory = YES;
    directoryRecomemndedUserVC.currentChosen = DIRECTORY;
    [self.navigationController pushViewController:directoryRecomemndedUserVC animated:YES];
}

- (void)gotoInDirectoryRecommendedCount{
    DirectoryRecommendedUserViewController *directoryRecommendedUserVC = [[DirectoryRecommendedUserViewController alloc]init];
    directoryRecommendedUserVC.isDirectory = NO;
    directoryRecommendedUserVC.currentChosen = INDIRECTORY;
    [self.navigationController pushViewController:directoryRecommendedUserVC animated:YES];
}

#pragma mark - private method
- (void)setupLabelsWithDictionary:(NSDictionary *)dic_temp{
    UILabel *lb_character = (UILabel *)[self.headerView viewWithTag:900001];
    UILabel *lb_joinDate = (UILabel *)[self.headerView viewWithTag:900002];
    UILabel *lb_totalIncome = (UILabel *)[self.headerView viewWithTag:900003];
    UILabel *lb_balance = (UILabel *)[self.headerView viewWithTag:900004];
    UILabel *lb_directRecommendCount = (UILabel *)[self.headerView viewWithTag:900005];
    UILabel *lb_directIncome = (UILabel *)[self.headerView viewWithTag:900006];
    UILabel *lb_indirectRecommendCount = (UILabel *)[self.headerView viewWithTag:900007];
    UILabel *lb_indirectIncome = (UILabel *)[self.headerView viewWithTag:900008];
    UILabel *lb_promoteCount = (UILabel *)[self.headerView viewWithTag:900009];
    UILabel *lb_promoteIncome = (UILabel *)[self.headerView viewWithTag:900010];
    UILabel *lb_withdrawMoney = (UILabel *)[self.headerView viewWithTag:900011];
    
    if(dic_temp == nil){
        lb_character.text = @"未知";
        lb_joinDate.text = @"未知";
        lb_totalIncome.text = @"0";
        lb_balance.text = @"0";
        lb_directRecommendCount.text = @"0";
        lb_directIncome.text = @"0";
        lb_indirectRecommendCount.text = @"0";
        lb_indirectIncome.text = @"0";
        lb_promoteCount.text = @"0";
        lb_promoteIncome.text = @"0";
        lb_withdrawMoney.text = @"0";
    } else {
        NSString *string_character;
        NSInteger userCharacter = [[dic_temp objectForKey:USERCHARACTER] integerValue];
        switch (userCharacter) {
            case FYMEMBER:
                string_character = @"会员";
                break;
            case FYBROKER:
                string_character = @"经纪人";
                break;
            case FYBANKER:
                string_character = @"行长";
                break;
            case FYHOLDER:
                string_character = @"股权人";
                break;
            default:
                string_character = @"未知";
                break;
        }
        lb_character.text = string_character;
        lb_joinDate.text = [self getDateStringWithDate:[[dic_temp objectForKey:USERREGISTERDATE] longLongValue]];
        lb_totalIncome.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:USERTOTALINCOME] doubleValue]];
        lb_balance.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:USERBALANCE] doubleValue]];
        lb_directRecommendCount.text = [NSString stringWithFormat:@"%.0f", [[dic_temp objectForKey:DIRECTORYCOUNT] doubleValue]];
        lb_directIncome.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:DIRECTORYINCOME] doubleValue]];
        lb_indirectRecommendCount.text = [NSString stringWithFormat:@"%.0f", [[dic_temp objectForKey:INDIRECOTRYCOUNT] doubleValue]];
        lb_indirectIncome.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:INDIRECTORYINCOME] doubleValue]];
        lb_promoteCount.text = [NSString stringWithFormat:@"%.0f", [[dic_temp objectForKey:PROMOTECOUNT] doubleValue]];
        lb_promoteIncome.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:PROMOTEINCOME] doubleValue]];
        lb_withdrawMoney.text = [NSString stringWithFormat:@"%.2f", [[dic_temp objectForKey:USERWITHDRAWNUMBER] doubleValue]];
    }
}

- (void)setupButtonsWithTarget:(BOOL)isEnabled{
    UIButton *btn_detail = (UIButton *)[self.headerView viewWithTag:800001];
    [btn_detail setEnabled:isEnabled];
    UIButton *btn_directoryCount = (UIButton *)[self.headerView viewWithTag:800002];
    [btn_directoryCount setEnabled:isEnabled];
    UIButton *btn_indirectoryCount = (UIButton *)[self.headerView viewWithTag:800003];
    [btn_indirectoryCount setEnabled:isEnabled];
    
    [btn_detail addTarget:self action:@selector(gotoIncomeAndExpenditureDetail) forControlEvents:UIControlEventTouchUpInside];
    [btn_directoryCount addTarget:self action:@selector(gotoDirectoryRecommendedCount) forControlEvents:UIControlEventTouchUpInside];
    [btn_indirectoryCount addTarget:self action:@selector(gotoInDirectoryRecommendedCount) forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)getDateStringWithDate:(long long)timestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date_timestamp = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    NSLog(@"%s || timestamp:%lld to NSDate:%@", __FUNCTION__, timestamp, date_timestamp);
    NSString *string_timestamp = [formatter stringFromDate:date_timestamp];
    NSLog(@"%s || NSDate:%@ to NSString:%@", __FUNCTION__, date_timestamp, string_timestamp);
    return string_timestamp;
}

#pragma mark - getter/setter

- (UIView *)headerView{
    if(_headerView == nil){
        _headerView = [self.array_xib objectAtIndex:0];
//        [_headerView setFrame:CGRectMake(0, 0, 320, 568)];
//        for(int i = 900000; i < 900000 + (_headerView.subviews.count); i++) {
//            UILabel *lb_temp = (UILabel *)[_headerView viewWithTag:i];
//            lb_temp.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            lb_temp.layer.borderWidth = 0.5;
//        }
        UIScrollView *scrollView_temp = (UIScrollView *)[_headerView viewWithTag:100001];
        scrollView_temp.contentSize = _headerView.frame.size;
    }
    return _headerView;
}

- (NSArray *)array_xib{
    if(_array_xib == nil){
        _array_xib = [[NSBundle mainBundle]loadNibNamed:@"DistributionReportView" owner:nil options:nil];
    }
    return _array_xib;
}

@end
