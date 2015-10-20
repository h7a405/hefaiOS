//
//  CRMBasicFactory.h
//  CRMApp
//
//  Created by liweiqiong on 14/10/23.
//  Copyright (c) 2014年 李韦琼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


@interface CRMBasicFactory : NSObject


+ (UILabel *)createLableWithFrame:(CGRect)frame
                             font:(UIFont *)textFont
                             text:(NSString *)text
                        textColor:(UIColor *)color
                    textAlignment:(NSTextAlignment)alignment
                  backgroundColor:(UIColor *)bgColor;

+ (UIButton *)createButtonWithType:(UIButtonType)type
                             frame:(CGRect)frame
                             title:(NSString *)title
                        titleColor:(UIColor *)color
                            target:(id)target
                            action:(SEL)action;
+ (UIButton *)createButtonWithType:(UIButtonType)type
                             frame:(CGRect)frame
                             image:(UIImage *)image
                     selectedImage:(UIImage *)selectedImage
                            target:(id)target
                            action:(SEL)action;

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                     font:(UIFont *)font
                                     text:(NSString *)placeholder
                                textColor:(UIColor *)color
                                alignment:(NSTextAlignment)alignment
                         contentAlignment:(UIControlContentVerticalAlignment)contentAlignment
                              borderStyle:(UITextBorderStyle)style
                                  bgColor:(UIColor *)color;

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                     font:(UIFont *)font
                                     text:(NSString *)placeholder
                                textColor:(UIColor *)textColor
                                alignment:(NSTextAlignment)alignment
                         contentAlignment:(UIControlContentVerticalAlignment)contentAlignment
                              borderStyle:(UITextBorderStyle)style
                                  bgColor:(UIColor *)color
                        withLeftLabelText:(NSString *)title;



@end

