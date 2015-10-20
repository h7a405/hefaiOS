//
//  UserPromoteViewController.h
//  HouseBank
//
//  Created by SilversRayleigh on 8/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, userRank){
    FYRANKMEMBER = 1,
    FYRANKBROKER = 2,
    FYRANKPRESIDENT = 3,
    FYRANKSHAREHOLDER = 4
};
typedef NS_ENUM(BOOL, userStatus){
    FYUSERPROMOTIONAPPLING = YES,
    FYUSERPROMOTIONHOLDING = NO
};

@interface UserPromoteViewController : UIViewController

@property (assign, nonatomic)BOOL currentUserStatus;
@property (assign, nonatomic)NSInteger currentUserRank;

@end
