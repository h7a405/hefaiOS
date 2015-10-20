//
//  SeeViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SeeViewController.h"
#import "MBProgressHUD+Add.h"

#define URL @"http://www.fybanks.com/chuangyeba.html"

@interface SeeViewController ()<UIWebViewDelegate>{
    MBProgressHUD *_mbpView ;
}

@end

@implementation SeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"加盟体系详情";
    
    
    UIWebView *wv = [[UIWebView alloc] initWithFrame:self.view.bounds];
    wv.delegate = self;
    wv.frame = self.view.bounds;
    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    
    [self.view addSubview:wv];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (!_mbpView) {
        _mbpView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
};

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(_mbpView){
        [_mbpView hide:YES];
        _mbpView = nil;
    }
};

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(_mbpView){
        [_mbpView hide:YES];
        _mbpView = nil;
    }
    [MBProgressHUD showNetErrorToView:self.view];
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
