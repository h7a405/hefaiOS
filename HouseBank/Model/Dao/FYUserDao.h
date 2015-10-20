//
//  CSUserDao.h
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"
#import "UserBean.h"

@interface FYUserDao : FYBaseDao

-(BOOL) isLogin;
-(void) setLogin: (BOOL) isLogin;
-(UserBean *) user;
-(void) saveUser : (UserBean *) user;
-(void) removeUser ;
-(BOOL) isLaunch;
-(void) setIsLaunch : (BOOL) isLaunch;

@end
