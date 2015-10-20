//
//  CustomStatueBar.m
//  CustomStatueBar
//
//  Created by 贺 坤 on 12-5-21.
//  Copyright (c) 2012年 深圳市瑞盈塞富科技有限公司. All rights reserved.
//

#import "CustomStatueBar.h"

@implementation CustomStatueBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = KNavBGColor;
        
        defaultLabel = [[BBCyclingLabel alloc]initWithFrame:[UIApplication sharedApplication].statusBarFrame andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.textColor = [UIColor whiteColor];
        defaultLabel.font = [UIFont systemFontOfSize:10.0f];
        defaultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:defaultLabel];
        [defaultLabel setText:@"default label text" animated:NO];
        defaultLabel.transitionDuration = 0.75;
        defaultLabel.shadowOffset = CGSizeMake(0, 1);
        defaultLabel.font = [UIFont systemFontOfSize:16];
        defaultLabel.clipsToBounds = YES;
        
        isFull = NO;
        
    }
    return self;
}
- (void)fullStatueBar:(BOOL)show{
    isFull = !show;
    if (isFull) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1.0f];
        self.frame =CGRectMake(320, 0,40, 20);
        [UIView commitAnimations];
    }else {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1.0f];
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        [UIView commitAnimations];
    }
}
- (void)showStatusMessage:(NSString *)message{
    self.hidden = NO;
    self.alpha = 1.0f;
    [defaultLabel setText:@"新信息" animated:NO];
    
    CGSize totalSize = self.frame.size;
    self.frame = (CGRect){ self.frame.origin, 0, totalSize.height };
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = (CGRect){ self.frame.origin, totalSize };
    } completion:^(BOOL finished){
        defaultLabel.text = message;
    }];
}
- (void)hide{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        defaultLabel.text = @"";
        self.hidden = YES;
    }];;

}
- (void)changeMessge:(NSString *)message{
    [defaultLabel setText:message animated:YES];
}

@end
