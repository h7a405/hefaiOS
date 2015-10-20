//
//  XSNeedListCell.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//
#import "XSNeedBean.h"
#import "XSNeedListCell.h"
@interface XSNeedListCell()
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *blockNameMap;
@property (weak, nonatomic) IBOutlet UILabel *communityNameMap;
@property (weak, nonatomic) IBOutlet UIImageView *purpose;


@end
@implementation XSNeedListCell
+(instancetype)cell
{
    XSNeedListCell *cell=(XSNeedListCell *)[ViewUtil xibView:@"XSNeedListCell"];
    return cell;
    
}
-(void)setModel:(XSNeedBean *)model
{
    _model=model;
    _createTime.text=[TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[_model.createTime doubleValue]/1000]  format:@"yyyy-MM-dd"];
    _area.text=[NSString stringWithFormat:@"%@-%@平米",_model.areaFrom,_model.areaTo];
    if ([_model.tradeType integerValue]==2) {//出租
        _price.text=[NSString stringWithFormat:@"%@-%@元/月",_model.priceFrom,_model.priceTo];
    }else{//出售
        _price.text=[NSString stringWithFormat:@"%@-%@万",_model.priceFrom,_model.priceTo];
    }
    
    _purpose.image=[UIImage imageNamed:[NSString stringWithFormat:@"need%@",_model.purpose]];
    _blockNameMap.text=[_model.blockNameMap isEqualToString:@""]?@"不限":_model.blockNameMap;
    _communityNameMap.text=[_model.communityNameMap isEqualToString:@""]?@"不限":_model.communityNameMap;
}

@end
