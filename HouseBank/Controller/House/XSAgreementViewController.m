//
//  XSAgreementViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSAgreementViewController.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
@interface XSAgreementViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XSAgreementViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGTemplateEngine *engine=[MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"html"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setValue:_sellerString forKey:@"seller"];
    [dict setValue:_buyerString forKey:@"buyer"];
    NSMutableString *html=[NSMutableString stringWithString:[engine processTemplateInFileAtPath:path withVariables:dict]];
    [_webView loadHTMLString:html baseURL:nil];
}


@end
