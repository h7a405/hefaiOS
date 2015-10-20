//
//  XSNeedListCell.h
//  HouseBank
//
//  Created by 鹰眼 on 14-10-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XSNeedBean;
@interface XSNeedListCell : UITableViewCell
+(instancetype)cell;
@property(nonatomic,strong)XSNeedBean *model;
@end
