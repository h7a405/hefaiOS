//
//  ReleaseWsImpl.h
//  HouseBank
//
//  Created by CSC on 15/1/19.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface ReleaseWsImpl : BaseWs

-(AFHTTPRequestOperationManager *) updateHouseSale : (NSDictionary *) params result : (Result) result ;

@end
