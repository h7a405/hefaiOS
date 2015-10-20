//
//  HomeMenuButton.m
//  HouseBank
//
//  Created by 鹰眼 on 14/11/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HomeMenuButton.h"
#import "UIView+Extension.h"
#import "ViewUtil.h"

@implementation HomeMenuButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height*0.6, self.width, 20);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height*0.1, self.width, self.height*0.5);
}

@end
