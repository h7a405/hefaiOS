//
//  TestViewController.h
//  HouseBank
//
//  Created by SilversRayleigh on 2/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterHandlerViewController : UIViewController

typedef NS_ENUM (NSInteger, RegistrationType){
    FYMemberRegistration = 0,
    FYBrokerRegistration = 1,
    FYPresidentRegistration = 2,
    FYShareholderRegistration = 3
};

@property (assign, nonatomic) NSInteger currentRegistrationType;

@end
