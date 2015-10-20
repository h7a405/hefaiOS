//
//  ECCustomDatePicker.h
//  EverCard
//
//  Created by liweiqiong on 14/8/19.
//  Copyright (c) 2014年 ___Liweiqiong___. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ECCustomDatePicker : UIView
{
    float sWidth;
    float sHeight;
    
}
@property (nonatomic,retain) UIDatePicker *datePicker;

@property (nonatomic,assign) UIDatePickerMode datePickerMode;

@property (nonatomic,assign) NSString *dateFormat;

@property (nonatomic,copy) void(^sendSelectedDate)(NSString *curDate);

- (void)hidePicker;
- (void)showPicker;

@end
