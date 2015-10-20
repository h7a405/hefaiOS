//
//  HouseInfoBGView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseInfoBGView.h"

@implementation HouseInfoBGView

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
         self.backgroundColor=[UIColor clearColor];
    }
    return self;
    
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIView *view=[self viewWithTag:23333333];
    if (view==nil) {
        view=[[UIView alloc]init];
        [self addSubview:view];
        view.tag=23333333;
        view.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.85];
       
    }
    view.frame=CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 0.5);
    
}
-(void)setCleanColor:(BOOL)cleanColor
{
    if (cleanColor==NO) {
        self.backgroundColor=[UIColor whiteColor];
    }
}
@end
