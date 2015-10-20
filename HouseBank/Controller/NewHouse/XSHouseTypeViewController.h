//
//  XSHouseTypeViewController.h
//  HouseBank
//  查看房型
//  Created by 鹰眼 on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"
@class NewHouseTypeBean;
@interface XSHouseTypeViewController : BaseViewController
@property(nonatomic,copy)NSString * propertyTypeString;
@property(nonatomic,strong)NewHouseTypeBean *type;
@end
