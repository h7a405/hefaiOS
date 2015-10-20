//
//  HouseListCell.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class House;
@interface HouseListCell : UITableViewCell
@property(nonatomic,copy)NSString *houseId;
@property(nonatomic,strong)House *house;
@property(nonatomic,assign)BOOL isSell;
@property(nonatomic,assign)BOOL isBusiness ;
@end
