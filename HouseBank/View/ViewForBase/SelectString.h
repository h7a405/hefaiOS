//
//  SelectYears.h
//  USAEstate
//
//  Created by 鹰眼 on 14-7-14.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  选择字符封装

#import <UIKit/UIKit.h>
@class SelectString;
@protocol SelectStringWithPickerDelegate <NSObject>

-(void)didSelectFinished:(NSString *)string index:(NSInteger)index;

@end
@interface SelectString : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *nilView;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property(nonatomic,weak)id<SelectStringWithPickerDelegate>delegate;
-(void)setupSelectData:(NSArray *)data;
-(void)selectIndexInString:(NSString *)string;
-(void)show;
@end
