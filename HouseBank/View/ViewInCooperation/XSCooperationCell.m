//
//  XSCooperationCell.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-28.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSCooperationCell.h"
#import "XSCooperationBean.h"
#import "UIImageView+WebCache.h"

@interface XSCooperationCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *brokerInfoTow;
@property (weak, nonatomic) IBOutlet UILabel *applyTime;
@property (weak, nonatomic) IBOutlet UILabel *houseInfo;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *isComment;


@end
@implementation XSCooperationCell
-(id)initWithFrame:(CGRect)frame
{
    
    if (self) {
        self=(XSCooperationCell *)[ViewUtil xibView:@"XSCooperationCell"];
    }
    return self;
}
#pragma mark -
-(void)setCooperation:(XSCooperationBean *)cooperation{
    _cooperation = cooperation;
    
    _applyTime.text=[TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[_cooperation.applyTime doubleValue]/1000] format:@"MM-dd HH:mm"];
    
    if ([_object isEqualToString:@"1"]) {
        _brokerInfoTow.text=_cooperation.brokerInfo;
    }else{
        _brokerInfoTow.text=_cooperation.brokerInfoTow;
    }
    
    [_icon sd_setImageWithURL:_cooperation.brokerHeaderImg placeholderImage:[UIImage imageNamed:@"nophoto"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _status.text=[Tool cooperationStatus:_cooperation.status];
    
    if ([_cooperation.commentCounts integerValue]>=2) {
        _isComment.hidden=NO;
    }else{
        _isComment.hidden=YES;
    }
    
    NSString *houseInfo = [TextUtil isEmpty : _cooperation.houseInfo] ? @"" : _cooperation.houseInfo;
    [_houseInfo setText : houseInfo];
}


@end
