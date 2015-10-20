//
//  KeyboardTool.h
//  QCloud
//
//  Created by 鹰眼 on 14-7-1.
//  Copyright (c) 2014年 qcloud. All rights reserved.
//  键盘工具条

#import <UIKit/UIKit.h>
@class KeyboardToolView;
@protocol KeyboardToolDelegate <NSObject>

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button;


@end
@interface KeyboardToolView : UIView
@property(nonatomic,weak)id<KeyboardToolDelegate>delegate;
@property(nonatomic,copy)NSString *buttonTitle;
@end
