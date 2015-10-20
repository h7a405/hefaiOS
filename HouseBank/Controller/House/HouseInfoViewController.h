//
//  HouseInfoViewController.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"

@interface HouseInfoViewController : BaseViewController
@property(nonatomic,copy)NSString *houseId;
@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString *communityString;

@property (nonatomic,assign) BOOL isBusiness;
@end
