//
//  CustomButton.m
//  cyr
//
//  Created by 植梧培 on 14-8-10.
//  Copyright (c) 2014年  植梧培. All rights reserved.
//

#import "CustomButton.h"
#import "UIImage+Helper.h"
@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundImage:[UIImage imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
        self.clipsToBounds=YES;
        self.layer.cornerRadius=5;
    }
    return self;
}
-(void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius=cornerRadius;
    self.layer.cornerRadius=_cornerRadius;
}
@end
