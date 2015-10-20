//
//  BrokerInfoView.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BrokerInfoView.h"
#import "TextUtil.h"
#import "UserBean.h"
#import "ViewUtil.h"
#import "BrokerCommon.h"
#import "URLCommon.h"
#import "UIImageView+WebCache.h"
#import "FYUserDao.h"

/**
 经理人信息界面
 */
@interface BrokerInfoView (){
    UIImageView *_headImgView;
    UILabel *_nameLabel;
    UILabel *_addLabel;
    UILabel *_phoneLabel;
    UILabel *_attestationLabel;
    UIImageView *_attestationImgView;
    UILabel *_company;
}

-(void) doLoadView;

@end

@implementation BrokerInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doLoadView];
    }
    return self;
}

-(void) doLoadView{
    CGRect rect = self.bounds;
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, rect.size.height-20)];
    headImgView.contentMode = UIViewContentModeScaleAspectFit;
    headImgView.image = [UIImage imageNamed:@"nophoto"];
    [self addSubview:headImgView];
    
    _headImgView = headImgView;
    
    float offset = 115;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 15, rect.size.width - offset, 17)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    CGFloat width=rect.size.width - offset;
    CGFloat  marge=5;
    //新增显示公司
    _company=[[UILabel alloc]initWithFrame:CGRectMake(offset, CGRectGetMaxY(_nameLabel.frame)+marge, width, 17)];
    [self addSubview:_company];
    // _company.text=@"公司";
    
    _company.font=[UIFont systemFontOfSize:14.f];
    
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, CGRectGetMaxY(_company.frame)+marge, rect.size.width - offset, 17)];
    addLabel.font = [UIFont systemFontOfSize:14];
    addLabel.adjustsFontSizeToFitWidth = YES;
    addLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    [self addSubview:addLabel];
    _addLabel = addLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, CGRectGetMaxY(_addLabel.frame)+marge, rect.size.width - offset, 17)];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    [self addSubview:phoneLabel];
    _phoneLabel = phoneLabel;
    
    _attestationLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset+20, CGRectGetMaxY(_phoneLabel.frame)+marge, rect.size.width - offset - 20, 17)];
    _attestationLabel.font = [UIFont systemFontOfSize:14];
    _attestationLabel.textColor = [ViewUtil string2Color:@"ff9900"];
    [self addSubview:_attestationLabel];
    
    _attestationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, CGRectGetMaxY(_phoneLabel.frame)+marge, 17 , 17)];
    _attestationImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_attestationImgView];
    
    UIView *cuttingLine = [[UIView alloc] initWithFrame:rect(0, self.frame.size.height - 0.5, 320, 0.5)];
    cuttingLine.backgroundColor = KColorFromRGB(0xdbdbdb);
    [self addSubview:cuttingLine];
}

-(void) setBroker : (BrokerInfoBean *) broker{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    if (broker==nil) {
        return;
    }
    _nameLabel.text = user.name;
    //显示门店
    _addLabel.text = broker.store;
    _phoneLabel.text = [NSString stringWithFormat:@"%@", broker.mobilephone];
    if ([broker.authStatus intValue] == ISPASSED) {
        _attestationImgView.image = [UIImage imageNamed:@"attestation_yes"];
    }else{
        _attestationImgView.image = [UIImage imageNamed:@"attestation_no"];
    }
    
    switch ([broker.authStatus intValue]) {
        case NOPASSED:
            _attestationLabel.text = NoPassStr;
            break;
        case AUTHSTR:
            _attestationLabel.text = AuthStr;
            break;
        case ISPASSED:
            _attestationLabel.text = IsPassStr;
            break;
        case UNPASSED:
            _attestationLabel.text = UnPassStr;
            break;
        default:
            _attestationLabel.text = OtherStr;
            break;
    }
    _company.text=broker.company;
    if (broker) {
        NSString *url = [URLCommon buildImageUrl:broker.brokerHeadImg imageSize:L03 brokerId:broker.brokerId];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nophoto"]];
    }
};

@end
