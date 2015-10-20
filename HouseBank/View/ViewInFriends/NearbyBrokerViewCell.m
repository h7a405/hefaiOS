//
//  NearbyBrokerViewCell.m
//  HouseBank
//
//  Created by Gram on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "NearbyBrokerViewCell.h"
#import "NearbyBrokerBean.h"
#import "UIImageView+WebCache.h"

@interface NearbyBrokerViewCell()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *memberMobilePhone;
@property (weak, nonatomic) IBOutlet UILabel *memberStore;
@property (weak, nonatomic) IBOutlet UILabel *scoreHouseTruth;
@property (weak, nonatomic) IBOutlet UILabel *scoreService;

@end

@implementation NearbyBrokerViewCell

-(id)initWithFrame:(CGRect)frame
{
    
    if (self) {
        self=(NearbyBrokerViewCell *)[ViewUtil xibView:@"NearbyBrokerViewCell"];
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

-(void)setNearbyBroker:(NearbyBrokerBean *)nearbyBroker
{
    _nearbyBroker=nearbyBroker;
    [_icon sd_setImageWithURL:_nearbyBroker.memberHeaderImage placeholderImage:[UIImage imageNamed:@"noimg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _memberName.text= _nearbyBroker.memberName;
    _memberStore.text= [NSString stringWithFormat:@"%@", _nearbyBroker.memberStore];
    _memberMobilePhone.text= [NSString stringWithFormat:@"%@",_nearbyBroker.memberMobilephone];
    _scoreHouseTruth.text = [NSString stringWithFormat:@"%@", _nearbyBroker.scoreHouseTruth];
    _scoreService.text = [NSString stringWithFormat:@"%@", _nearbyBroker.scoreService];
    _linkId=_nearbyBroker.linkId;
}

@end
