//
//  BaseViewController.h
//  Left
//
//  Created by 植梧培 on 14-8-11.
//  Copyright (c) 2014年 . All rights reserved.
//  要在首页显示的页面就继承这个类，push,model后的页面不用继承。

#import <UIKit/UIKit.h>
//四个左侧菜单动画
typedef NS_ENUM(NSInteger, TransitionsType){
    TransitionsNone,
    TransitionsFold,
    TransitionsZoom,
    TransitionsDynamics
};

#import "ECSlidingViewController.h"
@interface MenuBaseViewController : UIViewController<ECSlidingViewControllerDelegate>
@property(nonatomic,assign)TransitionsType type;

@end
