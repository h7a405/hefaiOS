//
//  CityModel.h
//  HouseBank
//  作为本地数据库城市模型的转换类
//  Created by 鹰眼 on 14/11/26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface CityBean : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * cityid;
-(instancetype)initwithAddress:(Address *)address;
@end
