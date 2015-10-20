//
//  XSSelectMoreFilterView.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSSelectMoreFilterView.h"
@interface XSSelectMoreFilterView()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;
@property(nonatomic,strong)NSArray *data;

@end
@implementation XSSelectMoreFilterView

+(instancetype)selectMoreFilterViewWithData:(NSArray *)data
{
    XSSelectMoreFilterView *select=(XSSelectMoreFilterView *)[ViewUtil xibView:@"XSSelectMoreFilterView"];
    select.data=data;
    select.hidden=YES;
    [[KAPPDelegate window] addSubview:select];
    return select;
}
-(void)show
{
    self.hidden=NO;
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
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSSelectMoreFilterView"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XSSelectMoreFilterView"];
        cell.textLabel.font=[UIFont systemFontOfSize:14.f];
        cell.backgroundColor=[UIColor clearColor];
    }
    if (_tableView==tableView) {
        cell.textLabel.text=_data[indexPath.row][@"name"];
    }else{
        if(_currentIndex==0){
            cell.textLabel.text=_data[_currentIndex][@"data"][indexPath.row];
        }else{
            cell.textLabel.text=_data[_currentIndex][@"data"][indexPath.row][@"name"];
        }
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView==tableView) {
            _currentIndex=indexPath.row;
            [_moreTableView reloadData];
    }else{
        if (_currentIndex==0) {
            if (_delegate&& [_delegate respondsToSelector:@selector(selectMoreFilterView:didSelectNeedType:)]) {
                [_delegate selectMoreFilterView:self didSelectNeedType:indexPath.row];
            }
        }else{
            if (_delegate&&[_delegate respondsToSelector:@selector(selectMoreFilterView:didSelectAreaForm:andAreaTo:)]) {
                [_delegate selectMoreFilterView:self didSelectAreaForm:_data[_currentIndex][@"data"][indexPath.row][@"begin"] andAreaTo:_data[_currentIndex][@"data"][indexPath.row][@"end"]];
            }
        }
        self.hidden=YES;
    }
}
- (IBAction)otherViewClick:(UITapGestureRecognizer *)sender {
    self.hidden=YES;
}

@end
