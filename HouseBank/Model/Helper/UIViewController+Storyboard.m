//
//  UIViewController+Storyboard.m
//  CarManage
//
//  Created by 鹰眼 on 14/10/23.
//  Copyright (c) 2014年 mihawk. All rights reserved.
//

#import "UIViewController+Storyboard.h"

@implementation UIViewController (Storyboard)

+(instancetype)controllerWithStoryboard:(NSString *)storyboard andIdentify:(NSString *)controllerId{
    UIViewController *vc=[[UIStoryboard storyboardWithName:storyboard bundle:nil]instantiateViewControllerWithIdentifier:controllerId];
    return vc;
}

@end
