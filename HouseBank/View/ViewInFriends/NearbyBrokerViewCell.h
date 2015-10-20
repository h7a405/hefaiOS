//
//  FriendInviteViewCell.h
//  HouseBank
//
//  Created by Gram on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NearbyBrokerBean;
@class NearbyBrokerViewCell;
@protocol NearbyBrokerViewCellDelegate <NSObject>

-(void)onBtnAcceptClick:(NearbyBrokerViewCell *)cell;
-(void)onBtnRefuseClick:(NearbyBrokerViewCell *)cell;

@end
@interface NearbyBrokerViewCell : UITableViewCell
@property(nonatomic,copy)NSString *linkId;
@property(nonatomic,strong)NearbyBrokerBean *nearbyBroker;
@property (weak, nonatomic) IBOutlet UILabel *sendInviteStatus; //状态 0:邀请中；1:已接受；2:拒绝
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *labelYouInvite;
@property (weak, nonatomic) IBOutlet UILabel *labelInviteYou;@property(weak,nonatomic)id<NearbyBrokerViewCellDelegate>delegate;

@end
