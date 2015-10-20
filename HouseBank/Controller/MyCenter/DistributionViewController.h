//
//  DistributionViewController.h
//  HouseBank
//
//  Created by SilversRayleigh on 5/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokerInfoBean.h"

#define DIRECTORYINCOME @"income1"
#define DIRECTORYCOUNT @"people1"
#define INDIRECTORYINCOME @"income2"
#define INDIRECOTRYCOUNT @"people2"
#define PROMOTEINCOME @"income3"
#define PROMOTECOUNT @"people3"
#define USERCHARACTER @"chainRole"
#define USERBALANCE @"resetMoney"
#define USERTOTALINCOME @"totalMoney"
#define USERWITHDRAWNUMBER @"stopedMoney"
#define USERREGISTERDATE @"createDatetime"

@interface DistributionViewController : UIViewController

@property (nonatomic, weak) BrokerInfoBean *broker;

@end
