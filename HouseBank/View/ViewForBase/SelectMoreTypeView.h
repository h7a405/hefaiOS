//
//  SelectMoreTypeView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  合发房银二手房等工具条

#import <UIKit/UIKit.h>
@class SelectMoreTypeView;
@protocol SelectMoreTypeViewDelegate <NSObject>

-(void)selectMoreView:(SelectMoreTypeView *)view didClickButtonIndex:(NSInteger)index;

@end
@interface SelectMoreTypeView : UIView
@property(nonatomic,weak)id<SelectMoreTypeViewDelegate>delegate;
@property(nonatomic,copy)NSString *prictButtonTitle;
-(void)setButton1Title:(NSString *)title;
-(void)setButton2Title:(NSString *)title;
-(void)setButton3Title:(NSString *)title;

@end
