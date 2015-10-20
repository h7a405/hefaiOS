//
//  XSBrokerCommentCell.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSBrokerCommentCell.h"
#import "BrokerCommentBean.h"
#import "UIImageView+WebCache.h"

@interface XSBrokerCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *targetBrokerName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIButton *zan;


@end
@implementation XSBrokerCommentCell
+(id)cell
{
    XSBrokerCommentCell *cell=(XSBrokerCommentCell *)[ViewUtil xibView:@"XSBrokerCommentCell"];
    return cell;
}
#pragma mark - 刷新界面
-(void)setModel:(BrokerCommentBean *)model
{
    _model=model;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:_model.targetBrokerHeadImg] placeholderImage:[UIImage imageNamed:@"nophoto"] options:SDWebImageRetryFailed|SDWebImageLowPriority ];
    _content.text=_model.content;
    _targetBrokerName.text=_model.targetBrokerName;
    _createTime.text=[TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[_model.createTime doubleValue]/1000] format:@"MM-dd HH:mm"];

    [_zan setTitle:[NSString stringWithFormat:@"有用(%@)",_model.usefulCount] forState:UIControlStateNormal];
    
}
- (IBAction)dianZan:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(clickComment:)]) {
        [_delegate clickComment:_model];
    }
}
@end
