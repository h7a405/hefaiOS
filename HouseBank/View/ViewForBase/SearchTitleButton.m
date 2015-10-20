//
//  SearchTitleButton.m
//  GongChuang
//
//  Created by 鹰眼 on 14-9-9.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SearchTitleButton.h"

@implementation SearchTitleButton

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
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width-15, 0, 15, self.frame.size.height);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width-15, self.frame.size.height);
}
@end
