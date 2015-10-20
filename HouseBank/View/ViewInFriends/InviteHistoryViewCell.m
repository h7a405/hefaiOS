//
//  InviteHistoryViewCell.m
//  HouseBank
//
//  Created by Gram on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "InviteHistoryViewCell.h"
#import "InviteHistoryFriendsBean.h"
#import "NSString+Helper.h"
#import "UIImageView+WebCache.h"

@interface InviteHistoryViewCell()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *memberMobilePhone;
@property (weak, nonatomic) IBOutlet UILabel *memberStore;
@property (weak, nonatomic) IBOutlet UILabel *sendDate;
//@property (weak, nonatomic) IBOutlet UILabel *sendInviteStatus; //状态 0:邀请中；1:已接受；2:拒绝

@end

@implementation InviteHistoryViewCell

-(id)initWithFrame:(CGRect)frame
{
    
    if (self) {
        self=(InviteHistoryViewCell *)[ViewUtil xibView:@"InviteHistoryViewCell"];
    }
    return self;
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setInviteHistory:(InviteHistoryFriendsBean *)inviteHistory
{
    _inviteHistory=inviteHistory;
    [_icon sd_setImageWithURL:_inviteHistory.headImagePath placeholderImage:[UIImage imageNamed:@"noimg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _memberName.text= _inviteHistory.sendUserName;
    if (![_inviteHistory.companyName isEqualToString:@""]&& ![_inviteHistory.storeName isEmptyString]) {
        _memberStore.text= [NSString stringWithFormat:@"%@,%@", _inviteHistory.companyName, _inviteHistory.storeName];
    }
    _sendDate.text=[TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[_inviteHistory.sendDate doubleValue]/1000]  format:@"M-dd"];
    _memberMobilePhone.text= _inviteHistory.mobilephone;
    _requestId=_inviteHistory.requestId;
}
- (IBAction)changeStatus:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(onBtnAcceptClick:)]&&_btnAccept==sender) {
        [_delegate onBtnAcceptClick:self];
    }else if(sender==_btnRefuse){
        if (_delegate&&[_delegate respondsToSelector:@selector(onBtnRefuseClick:)]) {
            [_delegate onBtnRefuseClick:self];
        }
    }
    
    
}

@end
