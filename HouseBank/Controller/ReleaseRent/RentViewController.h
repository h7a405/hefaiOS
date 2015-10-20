//
//  RentViewController.h
//  housebank.1
//
//  Created by JunJun on 14/12/26.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class RoomView;
@class WriteView;
@class ShopView;
@interface RentViewController : BaseViewController
@property (nonatomic,strong)RoomView *roomView;
@property (nonatomic,strong)WriteView *writeView;
@property (nonatomic,strong)ShopView *shopView;
@end
