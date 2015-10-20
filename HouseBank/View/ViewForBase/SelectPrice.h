//
//  SelectPrice.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  价格选择器

#import <UIKit/UIKit.h>
@class SelectPrice;
@protocol SelectPriceDelegate <NSObject>
@optional
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end;
-(void)selectPrice:(SelectPrice *)view didSelectBeginPrice:(NSString *)begin EndPrice:(NSString *)end name:(NSString *)name;

@end

@interface SelectPrice : UIView
@property(nonatomic,weak)id<SelectPriceDelegate>delegate;
@property(nonatomic,strong)NSArray *data;
- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data;
-(void)show;
@end
