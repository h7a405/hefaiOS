//
//  HomePageWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/2.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

//首页网络连接实现
@interface HomePageWsImpl : BaseWs

//获取首页文章
-(AFHTTPRequestOperationManager *) article : (void(^)(BOOL isSuccess , id result,NSString* data)) result ;

@end
