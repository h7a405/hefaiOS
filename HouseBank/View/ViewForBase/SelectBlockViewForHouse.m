//
//  AddressSelectView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SelectBlockViewForHouse.h"
#import "Address.h"

@interface SelectBlockViewForHouse()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_areaData;
    NSMutableArray *_streetData;
    
    
    NSString *_areaId;
    NSString *_streetId;
}

@property (weak, nonatomic) IBOutlet UITableView *area;
@property (weak, nonatomic) IBOutlet UITableView *street;

@end
@implementation SelectBlockViewForHouse

- (id)initWithFrame:(CGRect)frame
{
    
    if (self) {
        self=(SelectBlockViewForHouse *)[ViewUtil xibView:@"SelectBlockViewForHouse"];
        _area.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _street.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _area.hidden=YES;
        _street.hidden=YES;
        
        _areaData=[NSMutableArray array];
        _streetData=[NSMutableArray array];
        
        _street.hidden=YES;
        [_areaData removeAllObjects];
        _area.hidden=NO;
        NSString *cityid=nil;
        if(_cityId){
            cityid=_cityId;
        }else{
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            cityid=[user objectForKey:KLocationCityId];
        }
        
        [_areaData addObjectsFromArray:[Address addressDataWithPid:cityid]];
        [_area reloadData];
        
        [self setupShow];
    }
    return self;
}
- (IBAction)otherViewClick:(id)sender
{
    self.hidden=YES;
}
-(void)setupShow
{
    [[KAPPDelegate window]addSubview:self];
    self.hidden=YES;
}
-(void)show
{
    self.hidden=NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_area==tableView){
        return _areaData.count + 1;
    }else{
        return _streetData.count + 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_area==tableView){
        static NSString *ID=@"City";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:14.0];
            UIView *view=[[UIView alloc]init];
            view.alpha=0.5;
            view.backgroundColor=[UIColor whiteColor];
            cell.selectedBackgroundView=view;
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=[UIColor clearColor];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不限";
        }else{
            Address *address=_areaData[indexPath.row - 1];
            cell.textLabel.text=address.name;
        }
        
        return cell;
    }else{
        static NSString *ID=@"City";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:14.0];
            UIView *view=[[UIView alloc]init];
            view.backgroundColor=[UIColor whiteColor];
            cell.selectedBackgroundView=view;
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=[UIColor clearColor];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不限";
        }else{
            Address *address=_streetData[indexPath.row - 1];
            cell.textLabel.text = address.name;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_area==tableView){
        if (indexPath.row == 0) {
            [self selectAllCity];
        }else{
            _areaId=[NSString stringWithFormat:@"%@",[_areaData[indexPath.row - 1] tid]];
            [_streetData removeAllObjects];
            _street.hidden=NO;
            [_streetData addObjectsFromArray:[Address streesWithArea:_areaData[indexPath.row - 1]]];
            [_street reloadData];
        }
    }else{
        if (indexPath.row > 0) {
            _streetId=[NSString stringWithFormat:@"%@",[_streetData[indexPath.row - 1] tid]];
        }
        
        [self finished : indexPath.row];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)finished : (NSInteger) index{
    self.hidden=YES;
    if ([_delegate respondsToSelector:@selector(streetAll:)] && index == 0) {
        [_delegate streetAll : _areaId];
    }else if (_delegate&&[_delegate respondsToSelector:@selector(blockSelectView:didSelectCityId:andAreaId:andStreetId:)]) {
        [_delegate blockSelectView:self didSelectCityId:_cityId andAreaId:_areaId andStreetId:_streetId];
    }
}

-(void)selectAllCity
{
    self.hidden=YES;
    if (_delegate&&[_delegate respondsToSelector:@selector(blockAll)]) {
        [_delegate blockAll];
    }
}
@end
