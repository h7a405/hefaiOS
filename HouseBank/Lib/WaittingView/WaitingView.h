//
//  WaitingView.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingView : UIView

+(WaitingView *) defaultView;
-(void) showWaitingViewInView : (UIView *) view;
-(void) showWaitingViewWithHintTextInView: (UIView *) view hintText:(NSString *) text;
-(void) showWaitingViewWithDurationInView :(UIView *) view druation : (float) duration;
-(void) showWaitingViewWithDurationInView : (UIView *) view duration:(float) duration hintText:(NSString *) text;
-(void) dismissWatingView;

@end
