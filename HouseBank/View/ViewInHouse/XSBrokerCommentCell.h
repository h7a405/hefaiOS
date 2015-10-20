//
//  XSBrokerCommentCell.h
//  HouseBank
//
//  Created by 鹰眼 on 14-10-8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrokerCommentBean,XSBrokerCommentCell;
@protocol XSBrokerCommentCellDelegate <NSObject>

-(void)clickComment:(BrokerCommentBean *)comment;

@end
@interface XSBrokerCommentCell : UITableViewCell
+(id)cell;
@property(nonatomic,strong)BrokerCommentBean *model;
@property(nonatomic,weak)id<XSBrokerCommentCellDelegate>delegate;
@end
