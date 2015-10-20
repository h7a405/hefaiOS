//
//  XSStarView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSStarView.h"
@interface XSStarView()
{
    NSInteger _count;
}

@end
@implementation XSStarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self){
        self=(XSStarView *)[ViewUtil xibView:@"XSStarView"];
    }
    
    return self;
}
- (IBAction)starClick:(UIButton *)sender
{
    _count=[self.subviews indexOfObject:sender]+1;
    if (_delegate&&[_delegate respondsToSelector:@selector(starView:DidChangeLevel:)]) {
        [_delegate starView:self DidChangeLevel:_count];
    }
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx<_count) {
            if (_count<3) {
                [obj setImage:[UIImage imageNamed:@"commentBad"] forState:UIControlStateNormal];
            }else{
                [obj setImage:[UIImage imageNamed:@"commentGood"] forState:UIControlStateNormal];
            }
        }else{
            [obj setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        }
        
    }];
    
    
}

@end
