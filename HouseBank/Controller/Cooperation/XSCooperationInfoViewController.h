//
//  XSCooperationInfoViewController.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-28.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  看房合作信息

#import "BaseViewController.h"
@class XSCooperationBean;
@interface XSCooperationInfoViewController : BaseViewController
@property(nonatomic,strong)XSCooperationBean *cooperation;
@property(nonatomic,copy)NSString *object;
@end
