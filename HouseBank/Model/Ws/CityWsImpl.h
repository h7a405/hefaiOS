//
//  CityWs.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

//城市列表网络连接实现
@interface CityWsImpl : BaseWs

//获取城市列表
-(AFHTTPRequestOperationManager *) citys : (Result) result ;

@end
