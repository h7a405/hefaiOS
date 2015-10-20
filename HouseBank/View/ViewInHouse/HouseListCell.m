//
//  HouseListCell.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseListCell.h"
#import "House.h"
#import <CoreText/CoreText.h>
#import "UIImageView+WebCache.h"

@interface HouseListCell()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *community;
@property (weak, nonatomic) IBOutlet UILabel *dujia;
@property (weak, nonatomic) IBOutlet UIImageView *tuijian;

@end

@implementation HouseListCell
@synthesize isBusiness;

-(id)initWithFrame:(CGRect)frame
{
    
    if (self) {
        self=(HouseListCell *)[ViewUtil xibView:@"HouseListCell"];
    }
    
    return self;
}
-(void)setHouse:(House *)house
{
    _house=house;
    
    [_icon sd_setImageWithURL:_house.imagePath placeholderImage:[UIImage imageNamed:@"noimg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    _title.text=_house.advTitle;
    _community.text=[NSString stringWithFormat:@"%@ %@",_house.region,_house.community];
    _room.text=[NSString stringWithFormat:@"%@室%@厅",_house.bedRooms,_house.livingRooms];
    _area.text=[NSString stringWithFormat:@"%@平米",_house.buildArea];
    _room.hidden = isBusiness;
    
    if (isBusiness) {
        _area.frame = rect(_room.frame.origin.x, _room.frame.origin.y, _area.frame.size.width, _area.frame.size.height);
    }
    
    if (_isSell) {
        _price.text=[NSString stringWithFormat:@"%.2f万",_house.price.floatValue];
    }else{
        if (isBusiness) {
            _price.text=[NSString stringWithFormat:@"%@元/平米.天",_house.price];
        }else{
            _price.text=[NSString stringWithFormat:@"%@元/月",_house.price];
        }
        
    }
    if ([_house.featureIcon isEqualToString:@"1"]) {
        _dujia.hidden=NO;
    }else if ([_house.featureIcon isEqualToString:@"8"]){
        _tuijian.hidden=NO;
    }else{
        _dujia.hidden=YES;
        _tuijian.hidden=YES;
    }
    _houseId=_house.houseId;
}

@end
