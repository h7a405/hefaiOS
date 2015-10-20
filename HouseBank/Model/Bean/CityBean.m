//
//  CityModel.m
//  HouseBank
//
//  Created by 鹰眼 on 14/11/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "CityBean.h"

@implementation CityBean
-(instancetype)initwithAddress:(Address *)address{
    if (self) {
        self.name=address.name;
        self.cityid=[NSString stringWithFormat:@"%@",address.tid];
    }
    return self;
}
@end
