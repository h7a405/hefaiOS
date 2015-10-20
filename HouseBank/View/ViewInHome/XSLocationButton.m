//
//  XSLocationButton.m
//  HouseBank
//
//  Created by 鹰眼 on 14/11/24.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSLocationButton.h"
#import "UIView+Extension.h"
@implementation XSLocationButton
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.font=[UIFont systemFontOfSize:16.f];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.width-10, self.height-10, 10, 10);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return self.bounds;
}
@end
