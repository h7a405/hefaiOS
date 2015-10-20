//
//  XSComplainViewController.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  合作投诉

#import "BaseViewController.h"
@class XSCooperationBean;
@interface XSComplainViewController : BaseViewController
@property(nonatomic,strong)XSCooperationBean *cooperation;
@property(nonatomic,copy)NSString *object;
@end
