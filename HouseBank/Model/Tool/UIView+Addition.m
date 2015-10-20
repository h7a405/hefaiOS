//
//  UIView+Addition.m
//  WXWeibo
//
//  Created by JayWon on 14-8-20.
//  Copyright (c) 2014年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

-(UIViewController *)viewController
{
    //拿到下一个响应者
    UIResponder* next = [self nextResponder];
    while (next) {
        //如果下一个响应者的类型是 视图控制器类型
        if([next isKindOfClass:[UIViewController class]]){
            //则返回这个响应者
            return (UIViewController *)next;
        }
        //如果不是的话 继续取下下一个响应者
        next = [next nextResponder];
    }
    
    return nil;
}

@end
