//
//  JoinButton.m
//  HouseBank
//
//  Created by CSC on 14/12/29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "JoinButton.h"

#define SubheadTitles [ NSArray arrayWithObjects:@"售楼神器",@"24小时快速出售",@"搭上成功的顺风车",@"天天都是双十一", nil]

@interface JoinButton ()

@end

@implementation JoinButton

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSArray *array = SubheadTitles;
        
        float heith = 35.0;
        CGRect subTitleFrame = rect(10, (self.frame.size.height - heith)/2 + 15, self.frame.size.width, heith);
        
        UILabel *label = [[UILabel alloc] initWithFrame:subTitleFrame];
        label.font = [UIFont systemFontOfSize:12];
        label.text = array[self.tag];
        [self addSubview:label];
    }
    return self;
}

-(CGRect) imageRectForContentRect:(CGRect)contentRect{
    float width = self.frame.size.height * 0.6;
    return rect(self.frame.size.width - width - 5, (self.frame.size.height - width)/2, width, width);
}

-(CGRect) titleRectForContentRect:(CGRect)contentRect{
    float heith = 35.0;
    return rect(10, (self.frame.size.height - heith)/2 - 8, self.frame.size.width, heith);
}

@end
