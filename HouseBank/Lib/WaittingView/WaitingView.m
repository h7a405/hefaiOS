//
//  WaitingView.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "WaitingView.h"
#import "NSString+Helper.h"

@interface WaitingView (){
    UILabel *_label;
    UIView *_activityView;
}

@end


@implementation WaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
    }
    return self;
}

+(WaitingView *) defaultView{
    static WaitingView *view;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!view) {
            view = [[WaitingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    });
    return view;
};

-(void) showWaitingViewInView:(UIView *)view{
    [self showWaitingViewWithHintTextInView:view hintText:@""];
};

-(void) showWaitingViewWithDurationInView:(UIView *)view duration : (float) duration hintText:(NSString *) text{
    [self showWaitingViewWithHintTextInView:view hintText:text];
    [self performSelector:@selector(dismissWatingView) withObject:nil afterDelay:duration];
};

-(void) showWaitingViewWithHintTextInView:(UIView *)view hintText:(NSString *) text{
    [self removeFromSuperview];
    
    self.frame = view.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    CGPoint point = view.center;
    
    if (!_activityView) {
        UIActivityIndicatorView *activtyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:activtyView];
        activtyView.center = CGPointMake(point.x, point.y-30);
        [activtyView startAnimating];
        
        _activityView = activtyView;
    }
    
    if (!_label) {
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize size = [text sizeWithFont:font maxSize:CGSizeMake(self.frame.size.width - 30, self.frame.size.height/2-50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, point.y+10, self.frame.size.width - 30, size.height)];
        label.font = font;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        _label = label;
    }
    
    _label.text = text;
    
    if (view) {
        [view addSubview:self];
    }
};

-(void) showWaitingViewWithDurationInView:(UIView *)view druation : (float) duration{
    [self showWaitingViewInView:view];
    [self performSelector:@selector(dismissWatingView) withObject:nil afterDelay: duration];
};

-(void) dismissWatingView{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finish){
        [self removeFromSuperview];
        self.alpha = 1.0f;
    }];
};


@end
