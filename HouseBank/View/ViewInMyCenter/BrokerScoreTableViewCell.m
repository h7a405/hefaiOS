//
//  BrokerScoreTableViewCell.m
//  HouseBank
//
//  Created by CSC on 14-9-19.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BrokerScoreTableViewCell.h"
#import "ViewUtil.h"
#import "URLCommon.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "TimeUtil.h"

/**
 诚信评价列表item界面
 */
@interface BrokerScoreTableViewCell (){
    __weak UILabel *_nameLabel;
    __weak UILabel *_contentLabel ;
    __weak UILabel *_timeLabel ;
    __weak UILabel *_useFulLabel;
    __weak UIImageView *_headImgView;
}

-(void) doLoadView;

@end

@implementation BrokerScoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self doLoadView];
    }
    return self;
}

-(void) doLoadView{
    float height = CellHeight;
    
    float width = self.frame.size.width;
    float imgWidth = 60;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, imgWidth , height - 10)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"nophoto"];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgWidth + 15, 8, width - imgWidth * 2 - 20, 15)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor blackColor];
    [self addSubview:nameLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgWidth + 15, 25 , width - imgWidth *2 - 20, height - 50)];
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgWidth + 15, height - 25, width - imgWidth * 2 - 20, 15)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    timeLabel.numberOfLines = 0;
    [self addSubview:timeLabel];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(width - imgWidth - 7, height - 30, 15, 15)];
    img.image = [UIImage imageNamed:@"ic_action_praise"];
    [self addSubview:img];
    
    UILabel *useFulLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - imgWidth + 9, height - 30, 40, 15)];
    useFulLabel.textColor = [ViewUtil string2Color:@"ff6600"];
    useFulLabel.textAlignment = NSTextAlignmentCenter;
    useFulLabel.adjustsFontSizeToFitWidth = YES;
    useFulLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:useFulLabel];
    
    _nameLabel = nameLabel;
    _contentLabel = contentLabel;
    _timeLabel = timeLabel;
    _useFulLabel = useFulLabel;
    _headImgView  = imgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

-(void) refresh:(NSDictionary *)dic{
    _nameLabel.text = [dic objectForKey:@"targetBrokerName"];
    _contentLabel.text = [dic objectForKey:@"content"];
    _useFulLabel.text = [NSString stringWithFormat:@"有用(%@)",[dic objectForKey:@"usefulCount"]];
    _timeLabel.text = [TimeUtil timeStrByDataAndFormat:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"createTime"] doubleValue] /1000] format:@"MM-dd HH:mm"];
    
    
    NSString *url = [URLCommon buildImageUrl:[dic objectForKey:@"targetBrokerHeadImg"] imageSize:L03 brokerId:[dic objectForKey:@"brokerId"]];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nophoto"]];
}

@end
