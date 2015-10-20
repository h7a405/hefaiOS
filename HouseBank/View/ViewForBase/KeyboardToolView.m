//
//  KeyboardTool.m
//  QCloud
//
//  Created by 鹰眼 on 14-7-1.
//  Copyright (c) 2014年 qcloud. All rights reserved.
//#define KNavBGColor [UIColor colorWithRed:20.0/255.0 green:150.0/255.0 blue:218.0/255.0 alpha:1.0]


#import "KeyboardToolView.h"

@implementation KeyboardToolView
{
    UIButton *_finished;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0, 0, KWidth, 44);
        self.backgroundColor=[UIColor colorWithRed:172.0/255.0 green:179.0/255.0 blue:190.0/255.0 alpha:1.0];
        _finished=[UIButton buttonWithType:UIButtonTypeCustom];
        _finished.backgroundColor=Color(209, 213, 219);
        [_finished setTitle:@"完成" forState:UIControlStateNormal];
        _finished.frame=CGRectMake(KWidth-60, 5, 55, 35);
        [_finished setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finished.layer.cornerRadius = 5;
        _finished.layer.masksToBounds = YES;
        _finished.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
        [_finished addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_finished];
    }
    return self;
}
-(void)click:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(keyboardTool:didClickFinished:)]) {
        [_delegate keyboardTool:self didClickFinished:button];
    }
}
-(void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle=buttonTitle;
    [_finished setTitle:_buttonTitle forState:UIControlStateNormal];
}
@end
