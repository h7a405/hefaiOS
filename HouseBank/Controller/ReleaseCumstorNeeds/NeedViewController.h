//
//  NeedViewController.h
//  HouseBank
//
//  Created by JunJun on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomerModel.h"
@class CustomerView;

@interface NeedViewController : BaseViewController
@property(nonatomic,strong)CustomerModel *model;
@property(nonatomic,strong)CustomerView *Cview;
@end
