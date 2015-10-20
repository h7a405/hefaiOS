//
//  UIPlaceHolderTextView.h
//  Test
//
//  Created by CSC on 15/2/10.
//  Copyright (c) 2015年 CSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
