//
//  XSPrivacyViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14/10/28.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSPrivacyViewController.h"

@interface XSPrivacyViewController ()

@end

@implementation XSPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webview=[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.title = @"用户协议";
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.fybanks.com/xieyi.html"]]];

    [self.view addSubview:webview];
}

@end
