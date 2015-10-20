//
//  XSNewHouseCell.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNewHouseCell.h"
#import "NewHouseBean.h"
#import "UIImageView+WebCache.h"
#import "URLCommon.h"

@interface XSNewHouseCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *highestPrice;
@property (weak, nonatomic) IBOutlet UILabel *commissionRate;
@property (weak, nonatomic) IBOutlet UIImageView *hotImage;
@property (weak, nonatomic) IBOutlet UILabel *addressText;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end
@implementation XSNewHouseCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(XSNewHouseCell *)[ViewUtil xibView:@"XSNewHouseCell"];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) refresh : (NSDictionary *) dict {
    _addressText.text = [TextUtil replaceNull: dict[@"address"]];
    [_icon sd_setImageWithURL:[NSURL URLWithString:[URLCommon buildImageUrl:dict[@"imagePath"] imageSize:D01] ] placeholderImage:[UIImage imageNamed:@"noimg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _projectName.text=[TextUtil replaceNull:dict[@"advTitle"]];
    _region.text=[TextUtil replaceNull:dict[@"region"]];
    if ([[TextUtil replaceNull:dict[@"avgPrice1"]]integerValue] == [dict[@"avgPrice2"] integerValue]) {
        _highestPrice.text=[NSString stringWithFormat:@"%@",dict[@"avgPrice1"]];
    }else{
        _highestPrice.text=[NSString stringWithFormat:@"%@~%@",[NSString stringWithFormat:@"%@",dict[@"avgPrice1"]],[NSString stringWithFormat:@"%@",dict[@"avgPrice2"]]];
    }
    _commissionRate.text=[NSString stringWithFormat:@"%@",dict[@"totalCount"]];
};

-(void)setHouse:(NewHouseBean *)house{
    _house=house;
    [_icon sd_setImageWithURL:_house.imagePath placeholderImage:[UIImage imageNamed:@"noimg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    _projectName.text=_house.projectName;
    _region.text=_house.region;
    if ([_house.highestPrice isEqualToString:_house.lowestPrice]) {
        _highestPrice.text=_house.highestPrice;
    }else{
        _highestPrice.text=[NSString stringWithFormat:@"%@~%@",_house.lowestPrice,_house.highestPrice];
    }
    
    if ([TextUtil isEmpty:house.title]) {
        _titleLabel.hidden = YES;
    }else{
        _titleLabel.text = house.title;
    }
    
    _addressText.text = house.address;
    
    _commissionRate.text=[NSString stringWithFormat:@"%@",_house.totleHouse];
}

-(void) dismissHotView : (BOOL) isDismiss{
    _hotImage.hidden = isDismiss;
    _addressText.hidden = isDismiss;
};

@end
