//
//  ArticleViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleData.h"
#import "ShareHandler.h"
#import "MBProgressHUD+Add.h"

@interface ArticleViewController ()<UIWebViewDelegate>{
    __weak MBProgressHUD *_mbpView;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ArticleViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_article.url]]];
    _webView.delegate = self;
}

- (IBAction)shard:(id)sender {
    [ShareHandler shareWith:[NSString stringWithFormat:@"%@ %@",self.article.title,self.article.imagePath] url:self.article.url title:self.article.title];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (_mbpView) {
        [_mbpView hide:NO];
        _mbpView = nil;
    }
    
    _mbpView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
};

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_mbpView) {
        [_mbpView hide:YES];
        _mbpView = nil;
    }
};

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (_mbpView) {
        [_mbpView hide:YES];
        _mbpView = nil;
    }
};

@end
