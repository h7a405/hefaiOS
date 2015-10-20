//
//  SelectTypeView.h
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  二手房，租房条件过滤器

#import <UIKit/UIKit.h>
@class FilterView;
@protocol FilterViewDelegate <NSObject>
@optional
-(void)filterView:(FilterView *)view didSelectRoomNumWithBegin:(NSString *)begin andEnd:(NSString *)end;
-(void)filterView:(FilterView *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end;
-(void)filterView:(FilterView *)view didSelectSort:(NSString *)sort;
@end

typedef NS_ENUM(NSInteger, FilterViewType)
{
    FilterViewTypeSingle,
    FilterViewTypeDouble
};
@interface FilterView : UIView
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,assign)CGRect clickButtonFrame;
@property(nonatomic,weak)id<FilterViewDelegate> delegate;
@property(nonatomic,assign)FilterViewType type;

-(void)show;
@end
