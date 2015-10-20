//
//  PersonInfoViewController.h
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCenterBaseViewController.h"
#import "BrokerInfoBean.h"

@interface PersonInfoViewController : MyCenterBaseViewController

-(void) setBroker : (BrokerInfoBean *) broker;

@end
