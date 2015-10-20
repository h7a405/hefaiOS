//
//  XSLocationHouseTitleView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSLocationHouseTitleView.h"

@implementation XSLocationHouseTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(XSLocationHouseTitleView *)[ViewUtil xibView:@"XSLocationHouseTitleView"];
    }
    return self;
}
-(void)setLocationContent:(NSString *)location
{
    _locationInfo.text=[NSString stringWithFormat:@"当前位置:%@",location];
}
@end
