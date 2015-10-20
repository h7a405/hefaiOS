//
//  SelectYears.m
//  USAEstate
//
//  Created by 鹰眼 on 14-7-14.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SelectString.h"

@implementation SelectString
{
    NSArray *_data;
    NSInteger _select;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"SelectString" owner:nil options:nil][0];
        _data=@[@"30",@"20",@"15",@"10"];
        _select=0;
        self.frame=[[UIScreen mainScreen]bounds];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagClick:)];
        [self.nilView addGestureRecognizer:tap];
        
    }
    return self;
}
- (IBAction)click:(id)sender {
    
    NSString *str=_data[_select];
    if ([_delegate respondsToSelector:@selector(didSelectFinished:index:)]) {
        
        [_delegate didSelectFinished:str index:_select];
    }
    [self removeFromSuperview];
}
-(void)tagClick:(UITapGestureRecognizer *)tap
{

    [self removeFromSuperview];
    
}
- (IBAction)cancel:(id)sender
{
    [self removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _data.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _data[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _select=row;
}
-(void)setupSelectData:(NSArray *)data
{
    _data=data;
    [_picker reloadAllComponents];
}
-(void)selectIndexInString:(NSString *)string
{
    [_data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *str=(NSString *)obj;
        if ([str isEqualToString:string]) {
            [_picker selectRow:idx inComponent:0 animated:YES];
            _select=idx;
            *stop=true;
        }
    }];
}
-(void)show
{
    [[[[UIApplication sharedApplication]delegate] window] addSubview:self];
}
@end
