//
//  XSHouseTypeView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-23.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSHouseTypeView.h"
#import "NewHouseTypeBean.h"

@interface XSHouseTypeView ()
@property (weak, nonatomic) IBOutlet UILabel *bedRooms;
@property (weak, nonatomic) IBOutlet UILabel *unitName;
@property (weak, nonatomic) IBOutlet UILabel *propertyType;
@property (weak, nonatomic) IBOutlet UILabel *sellStatus;
@property (weak, nonatomic) IBOutlet UILabel *mainUnit;
@property (weak, nonatomic) IBOutlet UILabel *about;
@end

@implementation XSHouseTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self=(XSHouseTypeView *)[ViewUtil xibView:@"XSHouseTypeView"];
        self.backgroundColor=[UIColor clearColor];
    }
    
    return self;
}
-(void)setFrame:(CGRect)frame
{
    CGRect tmp=self.frame;
    tmp.origin.x=0;
    tmp.origin.y=frame.origin.y;
    [super setFrame:tmp];
    UIView *view=[self viewWithTag:23333333];	
    if (view==nil) {
        view=[[UIView alloc]init];
        [self addSubview:view];
        view.tag=23333333;
        view.backgroundColor=[UIColor lightGrayColor];
        
    }
    view.frame=CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 0.5);
}
#pragma mark - 刷新界面
-(void)reloadData
{
    _propertyType.text=_propertyTypeString;

    _unitName.text=_type.unitName;
    if ([_type.livingRooms isEqualToString:@"0"]) {
        _bedRooms.text=[NSString stringWithFormat:@"%@室",_type.bedRooms==nil?@"0":_type.bedRooms];
    }else{
        _bedRooms.text=[NSString stringWithFormat:@"%@室%@厅",_type.bedRooms,_type.livingRooms];
    }
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
   
    _about.text=[NSString stringWithFormat:@"%@平米|%@室%@厅%@卫|%@套|%@",_type.buildArea, _type.bedRooms,_type.livingRooms,_type.washRooms,_type.unitCount,[Tool towartWithTypeString:_type.toward]];
    [self changeLabelStyle];
}
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

@end
