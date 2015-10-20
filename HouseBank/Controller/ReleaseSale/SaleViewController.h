//
//  SaleViewController.h
//  HouseBank1
//
//  Created by admin on 14/12/22.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class HouseView;
@class StoreView;
@class OfficeView;
@interface SaleViewController : BaseViewController

//新建线索view
@property (nonatomic,retain) HouseView *houseView;
@property (nonatomic,retain) StoreView *storeView;
@property (nonatomic,retain) OfficeView *officeView;
@end
