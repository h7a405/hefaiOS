//
//  CustomStatueBar.h
//  CustomStatueBar
//
//  Created by 贺 坤 on 12-5-21.
//  Copyright (c) 2012年 深圳市瑞盈塞富科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCyclingLabel.h"

@interface CustomStatueBar : UIWindow
{
    BBCyclingLabel *defaultLabel;
    BOOL isFull;
}
- (void)showStatusMessage:(NSString *)message;
- (void)hide;
- (void)changeMessge:(NSString *)message;

- (void)fullStatueBar:(BOOL)show;
@end
