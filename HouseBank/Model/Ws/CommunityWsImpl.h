//
//  CommunityWsImpl.h
//  HouseBank
//
//  Created by CSC on 15/1/18.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface CommunityWsImpl : BaseWs

-(AFHTTPRequestOperationManager *) requestCommunityList :(NSString *) areaId keyWord : (NSString *) keyWord result : (Result) result;

@end
