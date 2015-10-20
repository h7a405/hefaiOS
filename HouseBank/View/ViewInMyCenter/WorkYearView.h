//
//  WorkYearView.h
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 委托
 */
@protocol WorkYearViewDelegation <NSObject>

/**
 年份选择时回调
 */
-(void) onYearCheck : (NSInteger) integer;

@end

@interface WorkYearView : UIView

@property (nonatomic,weak) id<WorkYearViewDelegation> delegation;

//显示，默认第一年
-(void) show;
//显示，在指定的年份
-(void) showWithYear : (NSNumber *) year;

@end
