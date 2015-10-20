//
//  LineLabel.m
//  HouseBank
//
//  Created by CSC on 15/2/10.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "LineLabel.h"

@implementation LineLabel

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self performSelector:@selector(change) withObject:nil afterDelay:0.3];
    }
    return self;
}

-(void) change{
    //    self.backgroundColor = KColorFromRGB(0xdddddddd);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0.5);
}

@end
