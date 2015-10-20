//
//  HomeButton.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HomeButton.h"
#import "UIImage+Helper.h"

@implementation HomeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self setImage:[[self imageForState:UIControlStateNormal]stretchableImageForHome] forState:UIControlStateNormal];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return self.bounds;
}
@end
