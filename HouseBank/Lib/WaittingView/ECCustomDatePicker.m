//
//  ECCustomDatePicker.m
//  EverCard
//
//  Created by liweiqiong on 14/8/19.
//  Copyright (c) 2014年 ___Liweiqiong___. All rights reserved.
//

#import "ECCustomDatePicker.h"

@implementation ECCustomDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        sWidth = self.frame.size.width;
        sHeight = self.frame.size.height;
        
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setFrame:CGRectMake(0, 0, sWidth, sHeight)];
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, sHeight - 256, sWidth, 256)];
    bgView.backgroundColor = UIColorFromRGB(0xd3d6db);
    [self addSubview:bgView];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:rect(sWidth - 75, 10, 60, 35)];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 3;
    [okBtn addTarget:self action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setBackgroundImage:[ViewUtil imageWithColor:KNavBGColor] forState:UIControlStateNormal];
    [bgView addSubview:okBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:rect(15, 10, 60, 35)];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 3;
    [cancelBtn addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[ViewUtil imageWithColor:KNavBGColor] forState:UIControlStateNormal];
    [bgView addSubview:cancelBtn];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, sWidth, 216)];
    
    [_datePicker addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:_datePicker];
    self.alpha = 0;
    self.hidden = YES;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    _datePicker.datePickerMode = datePickerMode;
}

-(void) okTapped {
    [self hidePicker];
    
    NSString *result = [self stringFromDate:_datePicker.date];
    self.sendSelectedDate(result);
}

- (void)getDate:(UIDatePicker *)sender{
    NSString *result = [self stringFromDate:sender.date];
    self.sendSelectedDate(result);
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.dateFormat];
    NSString *result = [dateFormatter stringFromDate:date];
    return result;
}

- (void)hidePicker{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)showPicker{
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
