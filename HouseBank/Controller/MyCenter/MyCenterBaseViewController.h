//
//  MyCenterBaseViewController.h
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokerInfoBean.h"
#import "FYUserDao.h"

@interface MyCenterBaseViewController : UIViewController{

}

@property (nonatomic,weak) BrokerInfoBean *broker;

@end
