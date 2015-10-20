//
//  BackButton.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20, 10, 15, 25);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(25, 7.5, 36, 20);
}
@end
