//
//  FYUploadCityTask.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYUploadCityTask.h"
#import "CityWsImpl.h"
#import "TimeUtil.h"
#import "FYAddressDao.h"
#import "MBProgressHUD+Add.h"

/**
 用于检查更新城市列表的任务类
 */
@implementation FYUploadCityTask

-(void) startCheckAndUpload{
    //检查是否要更新
    FYAddressDao *dao = [FYAddressDao new];
    //上次更新时间与现在的间隔
    long duration = [TimeUtil msFrom1970] - [dao uploadCityTime] ;
    
    if (duration > UploapCityDuration) {
        //如果上次更新的时间间隔大于规定的间隔则更新
        [self doTask];
    }
}

-(void) doTask{
    //开始更新任务
    [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES].labelText=@"正在更新城市数据,请稍等...";
    
    CityWsImpl *ws = [CityWsImpl new];
    [ws citys:^(BOOL isSuccess, id result, NSString *data) {
        [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
        
        if (isSuccess) {
            FYAddressDao *dao = [FYAddressDao new] ;
            [dao saveUploadCityTime : [TimeUtil msFrom1970]] ;
            
            [dao saveAddress : result];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KChangeCityNotification object:nil];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
    }];
}

@end
