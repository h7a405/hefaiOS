//
//  FriendInviteViewCell.h
//  HouseBank
//
//  Created by Gram on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InviteHistoryFriendsBean;
@class InviteHistoryViewCell;
@protocol InviteHistoryViewCellDelegate <NSObject>

-(void)onBtnAcceptClick:(InviteHistoryViewCell *)cell;
-(void)onBtnRefuseClick:(InviteHistoryViewCell *)cell;

@end
@interface InviteHistoryViewCell : UITableViewCell
@property(nonatomic,copy)NSString *linkId;
@property(nonatomic,strong)InviteHistoryFriendsBean *inviteHistory;
@property (weak, nonatomic) IBOutlet UILabel *sendInviteStatus; //状态 0:邀请中；1:已接受；2:拒绝
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *labelYouInvite;
@property (weak, nonatomic) IBOutlet UILabel *labelInviteYou;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnRefuse;
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property(weak,nonatomic)id<InviteHistoryViewCellDelegate>delegate;
@property (weak, nonatomic) NSString *requestId;
@end
