//
//  XSHouseTypeView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewHouseTypeBean;
@interface XSHouseTypeView : UIView
@property(nonatomic,strong)NewHouseTypeBean *type;
@property(nonatomic,copy)NSString *propertyTypeString;
-(void)reloadData;
@end
