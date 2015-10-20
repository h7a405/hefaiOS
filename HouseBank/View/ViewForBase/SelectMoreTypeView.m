//
//  SelectMoreTypeView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SelectMoreTypeView.h"
@interface SelectMoreTypeView()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@end
@implementation SelectMoreTypeView

- (id)initWithFrame:(CGRect)frame{
    if (self) {
        self =(SelectMoreTypeView *)[ViewUtil xibView:@"SelectMoreTypeView"];
        self.frame=(CGRect){{0,64},self.frame.size};
    }
    return self;
}

- (IBAction)buttonClick:(UIButton *)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(selectMoreView:didClickButtonIndex:)]) {
        [_delegate selectMoreView:self didClickButtonIndex:sender.tag];
    }
}

-(void)setPrictButtonTitle:(NSString *)prictButtonTitle
{
    [_button2 setTitle:prictButtonTitle forState:UIControlStateNormal];
}
-(void)setButton1Title:(NSString *)title
{
     [_button1 setTitle:title forState:UIControlStateNormal];
}
-(void)setButton2Title:(NSString *)title
{
    [_button2 setTitle:title forState:UIControlStateNormal];
}-(void)setButton3Title:(NSString *)title
{
    [_button3 setTitle:title forState:UIControlStateNormal];
}
@end
