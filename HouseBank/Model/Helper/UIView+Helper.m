//
//  UIView+Helper.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

-(void)viewBorder{
    self.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    self.layer.borderWidth=1.5;
    self.clipsToBounds=YES;
    self.layer.cornerRadius=5.0;
}

+(instancetype)viewFormXib{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

@end
