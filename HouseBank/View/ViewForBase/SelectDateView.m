//
//  SelectDateView.m
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SelectDateView.h"
@interface SelectDateView()
@property (weak, nonatomic) IBOutlet UIView *top;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
@implementation SelectDateView

- (id)initWithFrame:(CGRect)frame
{
    
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"SelectDateView" owner:nil options:nil][0];
        self.frame=[[UIScreen mainScreen]bounds];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagClick:)];
        [self.top addGestureRecognizer:tap];
    }
    return self;
}
- (IBAction)clickSubmit:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(dateView:didSelectDate:)]) {
        [_delegate dateView:self didSelectDate:[self stringWithDate]];
    }
    [self removeFromSuperview];
}
- (IBAction)cancelClick:(id)sender
{
    [self removeFromSuperview];
}
-(void)tagClick:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(void)show
{
    [[[[UIApplication sharedApplication]delegate] window] addSubview:self];
}
- (IBAction)change:(id)sender {
    
    if (_delegate&&[_delegate respondsToSelector:@selector(dateView:didChangeDate:)]) {
        [_delegate dateView:self didChangeDate:[self stringWithDate]];
    }
    
}
-(NSString *)stringWithDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:_datePicker.date];
}
@end
