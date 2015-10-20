//
//  LoanResultForBJViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "LoanResultForBJViewController.h"

@interface LoanResultForBJViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_monthRepayDatas ;
}

@property (weak, nonatomic) IBOutlet UILabel *totalForLoad;

@property (weak, nonatomic) IBOutlet UILabel *totalForRepay;

@property (weak, nonatomic) IBOutlet UILabel *totalForInterest;

@property (weak, nonatomic) IBOutlet UILabel *months;

@property (weak, nonatomic) IBOutlet UITableView *moneyTableview;


-(void) initialize ;
-(void) initializeParamAndView ;
-(void) initializeTableView ;

//每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
-(float) monthForRepay : (float) total months : (int)months index : (int) index rate : (float) rate;

@end

@implementation LoanResultForBJViewController

@synthesize total1 ;
@synthesize months1 ;
@synthesize rate1 ;

@synthesize total2 ;
@synthesize months2 ;
@synthesize rate2 ;

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [self initialize] ;
    [self initializeTableView];
    [self initializeParamAndView] ;
}

-(void) initialize{
    NSString *title = nil;
    
    switch (_type) {
        case Business:
            title = @"商业";
            break;
        case ProvidentFund:
            title = @"公积金";
            break;
        case Combination:
            title = @"组合";
            break;
            
        default:
            title = @"商业";
            break;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@贷款计算结果",title];
}

-(void) initializeTableView{
    _moneyTableview.dataSource = self;
    _moneyTableview.delegate = self;
}

-(void) initializeParamAndView{
    //    总利息=还款月数×(总贷款额×月利率-月利率×(总贷款额÷还款月数)*(还款月数-1)÷2+总贷款额÷还款月数)
    float interest1 = months1*(total1*rate1 - rate1*(total1/months1)*(months1-1)/2+total1/months1) - total1;
    
    float totalForLabel = total1;
    float interestForLabel = interest1;
    
    if (_type == Combination) {
        float interest2 = months1*(total2*rate2 - rate2*(total2/months1)*(months1-1)/2+total2/months1) - total2;
        interestForLabel += interest2;
        totalForLabel += total2;
    }
    
    _totalForLoad.text = [NSString stringWithFormat:@"%.0f 万元",totalForLabel/10000];
    _months.text = [NSString stringWithFormat:@"%d (月)",months1];
    _totalForInterest.text = [NSString stringWithFormat:@"%.2f 元",interestForLabel];
    _totalForRepay.text = [NSString stringWithFormat:@"%.2f 元",interestForLabel + totalForLabel];
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i<months1; i++) {
        float monthForRepay1 = [self monthForRepay:total1 months:months1 index:i rate:rate1];
        float monthForRepay2 = 0;
        
        if (_type == Combination) {
            monthForRepay2 = [self monthForRepay:total2 months:months1 index:i rate:rate2];
        }
        
        [array addObject:[NSString stringWithFormat:@"%.2f 元",monthForRepay1 + monthForRepay2]];
    }
    
    _monthRepayDatas = array;
    
    [_moneyTableview reloadData];
}

//每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
-(float) monthForRepay : (float) total months : (int)months index : (int) index rate:(float)rate{
    float monthForRepay = total/months + (total - total/months * index)*rate;
    
    return monthForRepay;
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _monthRepayDatas.count;
};

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row < 9) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d月\t\t\t\t\t%@",indexPath.row+1,_monthRepayDatas[indexPath.row]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%d月\t\t\t\t%@",indexPath.row+1,_monthRepayDatas[indexPath.row]];
    }
    
    return cell;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
};

@end
