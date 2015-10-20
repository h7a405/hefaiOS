//
//  FloatButton.m
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FloatButton.h"
#import "UIView+Extension.h"

/**
 首页浮动界面上的按钮
 */
@implementation FloatButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height*0.65, self.width, 20);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height*0.1, self.width, self.height*0.45);
}


@end
