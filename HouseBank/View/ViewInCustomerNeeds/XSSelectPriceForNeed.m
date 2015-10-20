//
//  XSSelectPriceForNeed.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSSelectPriceForNeed.h"
@interface XSSelectPriceForNeed()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end
@implementation XSSelectPriceForNeed
+(instancetype)selectPrictForNeedWithData:(NSArray *)data
{
    XSSelectPriceForNeed *select=(XSSelectPriceForNeed *)[ViewUtil xibView:@"XSSelectPriceForNeed"];
    select.data=data;
    [[KAPPDelegate window]addSubview:select];
    select.hidden=YES;
    return select;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tableView==tableView){
        return _data.count;
    }
    return [_data[_currentIndex][@"data"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSSelectPriceForNeed"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XSSelectPriceForNeed"];
        cell.textLabel.font=[UIFont systemFontOfSize:14.f];
        cell.backgroundColor=[UIColor clearColor];
        
    }
    if (_tableView==tableView) {
        cell.textLabel.text=_data[indexPath.row][@"name"];
    }else{
        if(_currentIndex==0){
            _dataTableView.hidden=YES;
        }else{
            _dataTableView.hidden=NO;
        }
        cell.textLabel.text=_data[_currentIndex][@"data"][indexPath.row][@"name"];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView==tableView) {
        _currentIndex=indexPath.row;
        [_dataTableView reloadData];
        if (indexPath.row==0) {
           
            [ _delegate selectPrictForNeedView:self didSelectHouseType:_currentIndex prictForm:@"0" andPriceTo:@"0"];
            self.hidden=YES;
        }
    }else{
        
        if (_delegate&&[_delegate respondsToSelector:@selector(selectPrictForNeedView:didSelectHouseType:prictForm:andPriceTo:)]) {
            [ _delegate selectPrictForNeedView:self didSelectHouseType:_currentIndex prictForm:_data[_currentIndex][@"data"][indexPath.row][@"begin"] andPriceTo:_data[_currentIndex][@"data"][indexPath.row][@"end"]];
        }
        self.hidden=YES;
    }
}
-(void)show
{
    self.hidden=NO;
}
- (IBAction)otherViewClick:(id)sender
{
    self.hidden=YES;
}

@end
