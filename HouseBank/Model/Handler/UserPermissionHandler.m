//
//  UserPermissionHandler.m
//  HouseBank
//
//  Created by CSC on 15/1/7.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "UserPermissionHandler.h"
#import "FYUserDao.h"
#import "MBProgressHUD+Add.h"

@interface UserPermissionHandler ()<UIAlertViewDelegate>{
    __weak UIViewController *_vc ;
}

@end


@implementation UserPermissionHandler

- (BOOL) handleUserPermission : (UIViewController *) vc{
    FYUserDao *dao = [FYUserDao new];
    BOOL isLogin = [dao isLogin];
    if (!isLogin) {
        _vc = vc;
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能需要登录使用，您是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"登录",nil];
        [view show];
    }
    
    return isLogin ;
};

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [_vc presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Login"] animated:YES completion:^{}];
    }
}

@end
