//
//  XSNewHouseCell.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewHouseBean;
@interface XSNewHouseCell : UITableViewCell
@property(nonatomic,strong)NewHouseBean *house;

-(void) dismissHotView : (BOOL) isDismiss;
-(void) refresh : (NSDictionary *) dict ;

@end
