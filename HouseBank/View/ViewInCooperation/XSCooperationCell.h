//
//  XSCooperationCell.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-28.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XSCooperationBean;
@interface XSCooperationCell : UITableViewCell
@property(nonatomic,copy)NSString *object;
@property(nonatomic,strong)XSCooperationBean* cooperation;
@end
