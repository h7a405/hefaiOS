//
//  XSSelectMoreFilterView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-10-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  客需选择更多，类型和面积

#import <UIKit/UIKit.h>
@class XSSelectMoreFilterView;
@protocol XSSelectMoreFilterViewDelegate <NSObject>
/**
 *  选择房子类型回调
 *
 *  @param view
 *  @param type
 */
-(void)selectMoreFilterView:(XSSelectMoreFilterView *)view didSelectNeedType:(HouseUseType)type;
/**
 *  选择面积回调
 *
 *  @param view
 *  @param form
 *  @param to       
 */
-(void)selectMoreFilterView:(XSSelectMoreFilterView *)view didSelectAreaForm:(NSString *)form andAreaTo:(NSString *)to;

@end
@interface XSSelectMoreFilterView : UIView
+(instancetype)selectMoreFilterViewWithData:(NSArray *)data;
-(void)show;
@property(nonatomic,weak)id<XSSelectMoreFilterViewDelegate>delegate;
@end
