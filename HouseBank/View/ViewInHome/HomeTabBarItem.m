//
//  HomeTabBarItem.m
//  HouseBank
//
//  Created by 鹰眼 on 14/11/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HomeTabBarItem.h"
#import "UIView+Extension.h"
@implementation HomeTabBarItem

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height-20, self.width, 20);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 8, self.width, self.height-25);
}

-(void)setHighlighted:(BOOL)highlighted{}
@end
