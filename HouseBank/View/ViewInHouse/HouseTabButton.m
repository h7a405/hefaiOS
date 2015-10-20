//
//  HouseTabButton.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseTabButton.h"
#import "UIImage+Helper.h"

@implementation HouseTabButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setImage:[[self imageForState:UIControlStateNormal] stretchableImageForHomeButton] forState:UIControlStateNormal];
        [self setImage:[[self imageForState:UIControlStateSelected] stretchableImageForHomeButton] forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    int offset = 0;
    if (contentRect.size.width > 160) {
        offset = (contentRect.size.width - 160)/2;
    }
    return rect(20+offset, 10, 25, 20);
}

-(CGRect) titleRectForContentRect:(CGRect)contentRect{
    int offset = 0;
    if (contentRect.size.width > 160) {
        offset = (contentRect.size.width - 160)/2;
    }
    return rect(50+offset, 10, 90, 20);
}

@end
