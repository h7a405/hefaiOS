//
//  HomeViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-12.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HomeViewController.h"
#import "Address.h"
#import "HouseListViewController.h"
#import "XSCycleScrollView.h"

#import "ArticleViewController.h"
#import "FriendsViewController.h"
#import "XSNeedViewController.h"
#import "XSNeedFilterViewController.h"
#import "HouseInfoViewController.h"
#import "XSNewHouseViewController.h"
#import "XSNeedDetailViewController.h"
#import "XSLocationButton.h"
#import "UIViewController+ECSlidingViewController.h"
#import "UIViewController+Storyboard.h"
#import "XSCooperationViewController.h"
#import "XSSubscibeViewController.h"
#import "HomePageWsImpl.h"
#import "MBProgressHUD+Add.h"
#import "ArticleData.h"
#import "FileUtil.h"
#import "HomePageFloatView.h"
#import "AppDelegate.h"
#import "MyShopCodeViewController.h"
#import "FYUserDao.h"
#import "DevelopersViewController.h"
#import "DelegationViewController.h"
#import "JoinViewController.h"
#import "FYUploadCityTask.h"
#import "SWRevealViewController.h"
#import "Share.h"
#import "ShareHandler.h"
#import "SaleViewController.h"
#import "RentViewController.h"
#import "NeedViewController.h"

@interface HomeViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,CycleScrollViewDelegate,FloatViewDelegation>{
    NSMutableArray *_adData;
    NSMutableArray *_urls;
    UIViewController *_currentController;
    XSLocationButton *_left;
    
    UserPermissionHandler *_handler ;
}

@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;


- (IBAction)fourBtnTapped:(UIButton *)sender;
- (void) initRightBarBtn ;
- (void) rightBtnTapped ;

@end

@implementation HomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _handler = [UserPermissionHandler new];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *item = [UIBarButtonItem new];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.delegate=self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    _adData=[NSMutableArray array];
    _urls=[NSMutableArray array];
    [_adView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ad"]]];
    _scrollView.contentSize=_scrollView.frame.size;
    _scrollView.frame=self.view.bounds;
    [self setupLeftItem];
    [self initArtcle];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCity) name:KChangeCityNotification object:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [self initRightBarBtn];
    
    FYUploadCityTask *task = [FYUploadCityTask new];
    [task startCheckAndUpload];
}

-(void) initRightBarBtn{
    UIBarButtonItem *btn = nil;
    if (![FYUserDao new].isLogin) {
        UIButton *button = [[UIButton alloc] initWithFrame:rect(0, 0, 45, 30)];
        [button setBackgroundImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        btn = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }else{
        btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shard)];
    }
    
    self.navigationItem.rightBarButtonItem = btn;
}

-(void) shard{
    [ShareHandler shareApp];
}

-(void) rightBtnTapped{
    [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Login"] animated:YES completion:^{
        
    }];
}

-(void)changeCity{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *city = [user objectForKey:KLocationCityName];
    [_left setTitle:city forState:UIControlStateNormal];
}

- (IBAction)centerBtnTapper:(id)sender {
    HomePageFloatView *floatView = (HomePageFloatView *)[ViewUtil xibView:@"HomePageFloatView"];
    floatView.delegation = self;
    [floatView showInView:[AppDelegate shareApp].window];
}

#pragma mark 浮动界面委托
-(void) didSelect : (HomePageFloatView *) floatView index : (NSInteger) index{
    [floatView dismiss:^{
        UIViewController *vc = nil;
        switch (index) {
            case 0:
                if ([_handler handleUserPermission:self]) {
                    vc = [[SaleViewController alloc] init];
                }
                break ;
            case 1:
                if ([_handler handleUserPermission:self]) {
                    vc = [RentViewController new];
                }
                break;
            case 2:
                if ([_handler handleUserPermission:self]) {
                    vc = [NeedViewController new];
                }
                break;
            case 3:
                vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"MortgageCalculatorViewController"];
                break;
            case 4:
                vc = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"TaxCalculatorViewController"];
                break;
            case 5:
                if ([_handler handleUserPermission:self]) {
                    vc = [[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MyShop"];;
                    MyShopCodeViewController *mVc = (MyShopCodeViewController *)vc;
                    NSString *username = [FYUserDao new].user.username;
                    mVc.phone = ![TextUtil isEmpty:username]?username: [FYUserDao new].user.mobilephone;
                }
                
                break;
        }
        
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
};

#pragma mark - 广告
-(void)setupAdView{
    XSCycleScrollView *cycle = [[XSCycleScrollView alloc] initWithFrame:_adView.bounds cycleDirection:CycleDirectionLandscape pictures:_urls defaultImg:nil];
    cycle.delegate = self;
    _page.numberOfPages = _urls.count;
    [_adView addSubview:cycle];
    [_adView sendSubviewToBack:cycle];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

#pragma mark - navgation 处理
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //隐藏客需的navigationbar
    if ((![viewController isKindOfClass: [HouseListViewController class]])&&![viewController isKindOfClass:[XSNeedViewController class]]&&(![viewController isKindOfClass:[XSNeedFilterViewController class]])) {
        
        [navigationController setNavigationBarHidden:NO animated:YES];
    }else if([viewController isKindOfClass: [HouseListViewController class]]||[viewController isKindOfClass: [XSNeedViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - 点击个人中心
- (IBAction)myCenter:(id)sender{
    if ([_handler handleUserPermission:self]) {
        UIViewController *controller=[[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"MyCenter"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 点击人脉
- (IBAction)friends:(id)sender{
    if ([_handler handleUserPermission:self]) {
        UIViewController *controller=[[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 获取所有文章
-(void)initArtcle{
    HomePageWsImpl *ws = [HomePageWsImpl new];
    [ws article:^(BOOL isSuccess, id result, NSString *data) {
        BOOL success = YES;
        if (isSuccess) {
            NSArray *data = result[@"data"];
            
            if(data && [data count]){
                [ArticleData saveAllArticleData:data];
                NSArray *acticleData = [ArticleData allArticle];
                [acticleData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ArticleData *article = obj;
                    [_adData addObject:article];
                    [_urls addObject:article.imagePath];
                }];
                
                [self setupAdView];
            }else{
                success = NO;
            }
        }else{
            success = NO;
        }
        
        NSArray *acticleData=[ArticleData allArticle];
        if (!success && acticleData.count>0) {
            [acticleData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ArticleData *article=obj;
                [_adData addObject:article];
                [_urls addObject:article.imagePath];
                
            }];
            [self setupAdView];
        }
    }];
}

-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didScrollImageView:(int)index{
    _page.currentPage=index-1;
}

-(void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didSelectImageView:(int)index{
    [self performSegueWithIdentifier:@"article" sender:_adData[index-1]];
}

#pragma mark - 跳转页面前处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"article"]) {
        ArticleViewController *vc=segue.destinationViewController;
        vc.article=sender;
    }else if([segue.identifier isEqualToString:@"ershoufang"]){
        HouseListViewController *house=segue.destinationViewController;
        house.houseType=HouseTypeSell;
    }else if([segue.identifier isEqualToString:@"zufang"]){
        HouseListViewController *house=segue.destinationViewController;
        house.houseType=HouseTypeRent;
    }
}

-(void)setupLeftItem{
    _left=[[XSLocationButton alloc]initWithFrame:CGRectMake(0, 0, 50, 22)];
    [_left setTitle:DefaultCity forState:UIControlStateNormal] ;
    [_left addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_left];
    [self changeCity];
}

- (IBAction)newHouse:(id)sender{
    XSNewHouseViewController *vc=[XSNewHouseViewController controllerWithStoryboard:@"NewHouse" andIdentify:@"XSNewHouseViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)needClick:(id)sender{
    if ([_handler handleUserPermission:self]) {
        XSNeedViewController *vc=[XSNeedViewController controllerWithStoryboard:@"Need" andIdentify:@"XSNeedViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)cooperationClick:(id)sender{
    if ([_handler handleUserPermission:self]) {
        XSCooperationViewController *vc=[XSCooperationViewController controllerWithStoryboard:@"Cooperation" andIdentify:@"XSCooperationViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)messageClick:(id)sender{
    if ([_handler handleUserPermission:self]) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"MyCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"Message"] animated:YES];
    }
}

- (IBAction)subscibeClick:(id)sender{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"HotHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"HotHouseViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    //以前的订阅
    //    if ([_handler handleUserPermission:self]) {
    //        XSSubscibeViewController *sub=[XSSubscibeViewController controllerWithStoryboard:@"Subscibe" andIdentify:@"XSSubscibeViewController"];
    //        [self.navigationController pushViewController:sub animated:YES];
    //    }
}

-(void)clickLeftBtn:(XSLocationButton *)btn{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)fourBtnTapped:(UIButton *)sender {
    if ( sender.tag == 0) {
        DevelopersViewController *vc = [DevelopersViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1){
        DelegationViewController *vc = [DelegationViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(sender.tag == 2){
        JoinViewController *vc = [JoinViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 3){
        [MBProgressHUD showMessag:@"即将开放，敬请期待..." toView:self.view];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
