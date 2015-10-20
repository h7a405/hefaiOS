//
//  CRMBasicFactory.m
//  CRMApp
//
//  Created by liweiqiong on 14/10/23.
//  Copyright (c) 2014年 李韦琼. All rights reserved.
//

#import "CRMBasicFactory.h"

@implementation CRMBasicFactory

#pragma mark - custom text field
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                     font:(UIFont *)font
                                     text:(NSString *)placeholder
                                textColor:(UIColor *)textColor
                                alignment:(NSTextAlignment)alignment
                         contentAlignment:(UIControlContentVerticalAlignment)contentAlignment
                              borderStyle:(UITextBorderStyle)style
                                  bgColor:(UIColor *)color{
    UITextField *textField = [[UITextField alloc] init];
    textField.font = font;
    textField.frame = frame;
    UIColor *_color = [UIColor darkGrayColor];
    if (placeholder) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:_color}];
        
    }
    textField.textColor = textColor;
    textField.textAlignment = alignment;
    textField.contentVerticalAlignment = contentAlignment;
    textField.borderStyle = style;
    textField.backgroundColor = color;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];//左侧占位空白
    textField.leftView = tempView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    return textField;
}
#pragma mark - custom label
+ (UILabel *)createLableWithFrame:(CGRect)frame
                             font:(UIFont *)textFont
                             text:(NSString *)text
                        textColor:(UIColor *)color
                    textAlignment:(NSTextAlignment)alignment
                  backgroundColor:(UIColor *)bgColor{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = textFont;
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.backgroundColor = bgColor;
    return label;
}
#pragma mark - custom button
+ (UIButton *)createButtonWithType:(UIButtonType)type
                             frame:(CGRect)frame
                             title:(NSString *)title
                        titleColor:(UIColor *)color
                            target:(id)target
                            action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:type];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)createButtonWithType:(UIButtonType)type
                             frame:(CGRect)frame
                             image:(UIImage *)image
                     selectedImage:(UIImage *)selectedImage
                            target:(id)target
                            action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:type];
    [button setFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                     font:(UIFont *)font
                                     text:(NSString *)placeholder
                                textColor:(UIColor *)textColor
                                alignment:(NSTextAlignment)alignment
                         contentAlignment:(UIControlContentVerticalAlignment)contentAlignment
                              borderStyle:(UITextBorderStyle)style
                                  bgColor:(UIColor *)color
                        withLeftLabelText:(NSString *)title{
    UITextField *textField = [[UITextField alloc] init];
    textField.font = font;
    textField.frame = frame;
//    UIColor *_color = [UIColor darkGrayColor];
//    if (placeholder) {
//        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:_color}];
//        
//    }
    textField.textColor = textColor;
    textField.textAlignment = alignment;
    textField.contentVerticalAlignment = contentAlignment;
    textField.borderStyle = style;
    textField.backgroundColor = color;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, frame.size.height)];//左侧占位空白
    UILabel *leftLabel = [self createLableWithFrame:CGRectMake(5, 0, tempView.bounds.size.width -5, frame.size.height -2) font:font text:title textColor:textColor textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    leftLabel.adjustsFontSizeToFitWidth = YES;
    [tempView addSubview:leftLabel];
    
    textField.leftView = tempView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    return textField;

}



@end
