//
//  SelectTypeView.h
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  弹窗选择一级项目

#import <UIKit/UIKit.h>
@class SelectTypeView;
typedef void (^Finished)(NSString * data);
@protocol SelectTypeViewDelegate <NSObject>

-(void)typeView:(SelectTypeView *)view didSelect:(NSString *)str selectIndex:(NSInteger)index;

@end
@interface SelectTypeView : UIView
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,assign)CGRect clickButtonFrame;
@property(nonatomic,weak)id<SelectTypeViewDelegate> delegate;
+(void)showSelectTypeViewWithClickFrame:(CGRect)frame Finished:(Finished)finish;
-(void)showWithTitle:(NSString *)title;
@end
