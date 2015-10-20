//
//  CornerRadiusView.m
//  HouseBank
//
//  Created by CSC on 15/2/5.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "CornerRadiusView.h"

@implementation CornerRadiusView

-(id) initWithCoder:(NSCoder *)aDecoder{
    id this = [super initWithCoder:aDecoder];
    self.layer.cornerRadius = 7.5f;
    self.layer.masksToBounds = YES;
    return this;
}

@end
