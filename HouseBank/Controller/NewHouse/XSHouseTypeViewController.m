//
//  XSHouseTypeViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-26.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSHouseTypeViewController.h"
#import "NewHouseTypeBean.h"
#import "UIView+Extension.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface XSHouseTypeViewController ()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *propertyType;
@property (weak, nonatomic) IBOutlet UILabel *sellStatus;
@property (weak, nonatomic) IBOutlet UILabel *mainUnit;
@property (weak, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet UILabel *hotPoint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation XSHouseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
}
#pragma mark - 刷新界面
-(void)reloadData
{
    _propertyType.text=_propertyTypeString;
   
    if([_type.sellStatus isEqualToString:@"1"]){
        _sellStatus.text=@"在售";
    }else{
        _sellStatus.text=@"售罄";
    }
    if([_type.mainUnit isEqualToString:@"1"]){
        _mainUnit.text=@"主力房型";
    }else{
        _mainUnit.text=@"非主力房型";
    }
    [_imageView sd_setImageWithURL:_type.imagePath placeholderImage:[UIImage imageNamed:@"noimgBig"] options:SDWebImageRetryFailed];
    _about.text=[NSString stringWithFormat:@"%@平米|%@室%@厅%@卫|%@套|%@",_type.buildArea, _type.bedRooms,_type.livingRooms,_type.washRooms,_type.unitCount,[Tool towartWithTypeString:_type.toward]];
    _hotPoint.text=_type.hotPoint;
    CGSize size=[TextUtil sizeWithContent:_hotPoint];
    if (size.height-_hotPoint.height>0) {
         _hotPoint.superview.height+=size.height-_hotPoint.height;
    }
    _hotPoint.size=size;
    [self changeLabelStyle];
    _scrollView.contentSize=CGSizeMake(KWidth, CGRectGetMaxY(_hotPoint.superview.frame));
}
#pragma mark - 修改label 样式
-(void)changeLabelStyle
{
    [self setLabelRound:_mainUnit];
    [self setLabelRound:_sellStatus];
    [self setLabelRound:_propertyType];
}
-(void)setLabelRound:(UILabel *)label
{
    label.clipsToBounds=YES;
    label.layer.cornerRadius=3;
}
#pragma mark - 展示大图
- (IBAction)imageClick:(id)sender
{
    NSMutableArray *data=[NSMutableArray array];
    MJPhoto *phone=[[MJPhoto alloc]init];
    phone.url=_type.imagePath;
    [data addObject:phone];
    MJPhotoBrowser *browser=[[MJPhotoBrowser alloc]init];
    browser.photos=data;
    [browser show];

}


@end
