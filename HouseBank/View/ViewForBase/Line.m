//
//  Line.m
//  HouseBank
//
//  Created by CSC on 15/2/10.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "Line.h"

@implementation Line

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0.5);
    }
    return self;
}

@end
