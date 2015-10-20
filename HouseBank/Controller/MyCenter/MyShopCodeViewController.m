//
//  MyShopCodeViewController.m
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "MyShopCodeViewController.h"
#import "QRCodeGenerator.h"
#import "ViewUtil.h"
#import "URLCommon.h"
#import "Constants.h"
#import "Share.h"
#import "MBProgressHUD+Add.h"
#import "Config.h"

/**
 我的微商城
 */
@interface MyShopCodeViewController (){
    NSString *_myAddress;
    UIImage *_myShopImage;
}

-(void) doLoadView;
-(void) onBtnClick;

@end

@implementation MyShopCodeViewController

@synthesize phone;


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"我的微商城";
    [self doLoadView];
}

//加载界面
-(void) doLoadView{
    CGRect rect = self.view.bounds;
    float topOffset = iOS7?70:10;
    
    float imgBackHeight = 350;
    
    UIView *imgBackView = [[UIView alloc] initWithFrame:CGRectMake(5, topOffset, rect.size.width - 10, imgBackHeight)];
    imgBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imgBackView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, topOffset + imgBackHeight +10, rect.size.width - 10, 40)];
    [btn setBackgroundImage:[ViewUtil imageWithColor:KNavBGColor]  forState:UIControlStateNormal];
    [btn setTitle:@"访问我的微商城" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 35)];
    titleLabel.text = @"我的微商城地址";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [imgBackView addSubview:titleLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, imgBackView.frame.size.width, 0.5)];
    lineLabel.alpha = 0.5;
    lineLabel.backgroundColor = [UIColor blackColor];
    [imgBackView addSubview:lineLabel];
    
    UILabel *shopAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 37, imgBackView.frame.size.width, 20)];
    shopAddLabel.font = [UIFont systemFontOfSize:14];
    shopAddLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    shopAddLabel.text = [FYBANKS_WAP_ADDRESS stringByAppendingFormat:@"/%@",phone==nil?self.broker.mobilephone:phone];
    [imgBackView addSubview:shopAddLabel];
    
    _myAddress = shopAddLabel.text;
    
    float codeImageWidth = 230;
    UIImageView *codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake((imgBackView.frame.size.width - codeImageWidth)/2, 70, codeImageWidth, codeImageWidth)];
    _myShopImage=[QRCodeGenerator qrImageForString:_myAddress imageSize : codeImgView.bounds.size.width*[UIScreen mainScreen].scale];
    codeImgView.image = _myShopImage;
    [imgBackView addSubview:codeImgView];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 310, imgBackView.frame.size.width - 10, 35)];
    hintLabel.text = @"让客户扫一扫，或点击屏幕右上方“分享”按钮进行分享，收藏您的微商城，即可出售整个合发房银的房源，成交机会倍增！";
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:11];
    [imgBackView addSubview:hintLabel  ];
}

//按钮事件，打开网址
-(void) onBtnClick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_myAddress]];
}

#pragma mark - 分享组件
- (IBAction)share:(id)sender{
    NSString *content=[NSString stringWithFormat:@"合发房银我的专属门店,精品房源总有一款适合你,快来我的商场看看吧,访问地址:%@",_myAddress];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"合发房银"
                                                image:[ShareSDK pngImageWithImage:_myShopImage]
                                                title:@"合发房银"
                                                  url:_myAddress
                                          description:@"合发房银房源分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess){
                                    [MBProgressHUD showSuccess:@"分享成功!" toView:self.view];
                                }else if (state == SSResponseStateFail){
                                    NSLog(@"###%d,%@", [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:@"分享失败!" toView:self.view];
                                }
                                
                            }];
    
}
@end
