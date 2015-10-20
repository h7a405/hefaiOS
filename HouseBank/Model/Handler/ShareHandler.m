//
//  ShareHandler.m
//  HouseBank
//
//  Created by CSC on 15/1/9.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "ShareHandler.h"
#import "Share.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"

@implementation ShareHandler

+(void) shareApp{
    
    NSString *content=[NSString stringWithFormat:@"我正在使用房源销售神器[合发房银APP],找房卖房房产交易很方便,还有超过55%%的佣金,你也可以来试试看吧!下载地址:http://www.fybanks.com/about/appdownload.html"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"合发房银"
                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"ico80"]]
                                                title:@"合发房银"
                                                  url:@"http://www.fybanks.com/about/wapappdownload.html"
                                          description:@"合发房银房源分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [MBProgressHUD showSuccess:@"分享成功!" toView:[AppDelegate shareApp].window];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //                                    NSLog(@"###%d,%@", [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:@"分享失败!" toView:[AppDelegate shareApp].window];
                                }
                                
                            }];
}

+(void) shareWith : (NSString *) content url : (NSString *) url title : (NSString *) title{
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"合发房银"
                                                image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"ico80"]]
                                                title:title
                                                  url:url
                                          description:@"合发房银房源分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [MBProgressHUD showSuccess:@"分享成功!" toView:[AppDelegate shareApp].window];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //                                    NSLog(@"###%d,%@", [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:@"分享失败!" toView:[AppDelegate shareApp].window];
                                }
                                
                            }];
};

@end
