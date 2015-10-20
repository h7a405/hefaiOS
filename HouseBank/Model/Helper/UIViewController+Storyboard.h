//
//  UIViewController+Storyboard.h
//  CarManage
//
//  Created by 鹰眼 on 14/10/23.
//  Copyright (c) 2014年 mihawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Storyboard)
+(instancetype)controllerWithStoryboard:(NSString *)storyboard andIdentify:(NSString *)controllerId;
@end
