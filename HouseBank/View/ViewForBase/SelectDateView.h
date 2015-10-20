//
//  SelectDateView.h
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  时间选择器封装

#import <UIKit/UIKit.h>
@class SelectDateView;
@protocol SelectDateViewDelegate <NSObject>

-(void)dateView:(SelectDateView *)dateView didChangeDate:(NSString *)date;
-(void)dateView:(SelectDateView *)dateView didSelectDate:(NSString *)date;
@end
@interface SelectDateView : UIView
@property(nonatomic,weak)id<SelectDateViewDelegate>delegate;
-(void)show;
@end
